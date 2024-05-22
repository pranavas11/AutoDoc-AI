from langchain_core.output_parsers import StrOutputParser
from langchain_core.prompts import PromptTemplate

from utils import llm

documentation_template = """<|begin_of_text|><|start_header_id|>system<|end_header_id|>
You are a developer.

Your goal is to write the technical documentation for a peace of code given.
You will be given code of all the user functions involved.    

User functions with comments:
{code}

Follow this template if it is an API endpoint:
## METHOD /api/path

<description>

### Request

The request should be a JSON object with the following properties:

- \`<property1>\` (<type>, <required|optional>): <description>
- \`<property2>\` (<type>, <required|optional>): <description>

Example with CURL:

\`\`\`bash
<curl command>
\`\`\`

### Response

<description of the result and response format>

Example:

\`\`\`json
<JSON response example>
\`\`\`

### Error

<description of the error response format>

<description of possible errors>

- \`<error1>\`: <description>
- \`<error2>\`: <description>

Example:

\`\`\`json
<example of error response format>
\`\`\`


If the code that is given is not a API endpoint, then follow this template:
## <actionName>

<description>

### Input

The input should be a JSON object with the following properties:

- \`<property1>\` (<type>, <required|optional>): <description>

Example:

\`\`\`json
<example of input>
\`\`\`

### Output

<description of the output and response format>

Example:

\`\`\`json
<example of output>
\`\`\`

### Error

<description of the error response format>

<description of possible errors>

- \`<error1>\`: <description>
- \`<error2>\`: <description>

Example:

\`\`\`json
<example of error response format>
\`\`\`
<|eot_id|><|start_header_id|>assistant<|end_header_id|>
"""


# This method will write a test.
def documentation(state):
    # Get the next method to process.
    code = state["new_code"]

    # Get the test source code.
    prompt = PromptTemplate(template=documentation_template, input_variables=["code"])

    chain = prompt | llm | StrOutputParser()
    md_file = chain.invoke({"code": code})

    state["md_file"] = md_file
    return state
