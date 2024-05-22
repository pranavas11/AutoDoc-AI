import sys
from typing import List

from tree_sitter import Tree
from typing_extensions import TypedDict
from langgraph.pregel import GraphRecursionError
from langgraph.graph import END, StateGraph

from utils import should_continue, read_file, parse_source, edit_function_declarations, discover_function, \
    write_file_comments, write_test_file, write_md_file

from test import write_tests_function

from documentation import documentation


# State
class GraphState(TypedDict):
    file_path: str
    source: bytes
    new_code: str
    tree: Tree
    class_methods: List[str]
    tests_code: str
    import_statements: List[str]
    md_file: str


workflow = StateGraph(GraphState)

workflow.add_node("read_file", read_file)  # discover
workflow.add_node("parse_source", parse_source)  # write tests
workflow.add_node("edit_function_declarations", edit_function_declarations)  # write file
workflow.add_node("discover", discover_function)  # discover
workflow.add_node("write_file_comments", write_file_comments)  # write file
workflow.add_node("write_tests", write_tests_function)  # write tests
workflow.add_node("write_test_file", write_test_file)  # write test file
workflow.add_node("write_md_file", write_md_file)  # write md file
workflow.add_node("documentation", documentation)  # write md file

workflow.set_entry_point("read_file")
workflow.add_edge("read_file", "parse_source")
workflow.add_edge("parse_source", "discover")
workflow.add_edge("discover", "edit_function_declarations")
workflow.add_edge("edit_function_declarations", "write_file_comments")
workflow.add_edge("write_file_comments", "documentation")
workflow.add_edge("documentation", "write_md_file")
workflow.add_edge("write_md_file", "write_tests")
workflow.add_conditional_edges(
    "write_tests",
    should_continue,
    {
        "continue": "write_tests",
        "end": "write_test_file"
    }
)
workflow.add_edge("write_test_file", END)

# Compile
app = workflow.compile()

if __name__ == "__main__":

    if len(sys.argv) < 2:
        print("Usage: python autodoc.py <file_path>")
        sys.exit(1)


    file_path = sys.argv[1]

    # Configure inputs and settings
    inputs = {"file_path": file_path}
    config = {"recursion_limit": 100}

    try:
        result = app.invoke(inputs, config)
        print(result)
    except GraphRecursionError:
        print("Graph recursion limit reached.")
