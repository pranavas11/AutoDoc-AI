from langchain_core.output_parsers import StrOutputParser
from langchain_core.prompts import PromptTemplate


from utils import extract_code_from_message, llm

write_test_template = """<|begin_of_text|><|start_header_id|>system<|end_header_id|>
You are a smart developer. You can do this! You will write unit 
tests that have a high quality.

Reply with the source code for the test only. 
Do not include the class or imports in your response. I will add the imports myself.

If there is no test to write, reply with "# No test to write" and 
nothing more. Do not include the class in your response.

You will be given the code and you need to describe the test cases that should be done for. Use the information from the code and the test case specifications to create a comprehensive set of tests that cover all possible scenarios and edge cases.

Explain the progress of the test case in comments: 
 - Preparation: what should be done to prepare the test case: should I create entities in the database before running the test? if yes, I need to delete them after the test
 - Execution: what should be done to run the test case
 - Checking: what should be done to check the result of the test case
 - Cleaning: what should be done to clean the test case: entities created in during the Preparation or Execution phase should be deleted

Each test case should be independent from other test cases and should not depend on the order of execution.

If a test case is not possible to be done with the available action or if you need to mock an response then you should not do the test case.


Example:

```
def test_function():
    ...
```

I will give you $200 if you adhere to the instructions and write a high quality test. 
Do not write test classes, only methods.

<|eot_id|><|start_header_id|>user<|end_header_id|>

Here is a class:
'''
{class_source}
'''

Implement a test for the method \"{class_method}\".
<|eot_id|><|start_header_id|>assistant<|end_header_id|>
"""


# This method will write a test.
def write_tests_function(state):
    # Get the next method to write a test for.
    class_method = state["class_methods"].pop(0)
    print(f"Writing test for {class_method}.")

    # Get the source code.
    class_source = state["source"].decode("utf8")

    # Get the test source code.
    prompt = PromptTemplate(template=write_test_template, input_variables=["class_source", "class_method"])

    chain = prompt | llm | StrOutputParser()
    test_source = chain.invoke({"class_source": class_source, "class_method": class_method})
    test_source = extract_code_from_message(test_source)
    state["tests_code"] += test_source + "\n\n"

    return state
