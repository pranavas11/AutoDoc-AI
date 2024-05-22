# AutoDoc-AI
This README provides detailed instructions for setting up and running the program. Ensure you follow these steps to set up your environment and execute the program correctly.

## Description
AutoDoc-AI is a Python-based project that aims to automate the process of generating documentation for code. It uses advanced AI techniques to understand the code structure and generate meaningful documentation.

## Prerequisites
Before you start, ensure you have Ollama installed on your system. If you don't have Ollama installed, visit [Ollama's official website](https://ollama.com) for installation instructions.

## Installation

Follow these steps to set up the program:

1. **Pull the Necessary LLM:**
   Open a terminal and execute the following command to pull the required llama3 model:
   ```bash
   ollama pull llama3
   ```

2. **Start the Ollama Service:**
   Once the image is pulled, you can start the Ollama service by running:
   ```bash
   ollama serve
   ```

3. **Install Python Dependencies:**
   Install all required Python packages using pip. Run the following command in the terminal:
   ```bash
   pip install -r requirements.txt
   ```

## Running the Program

To run the program, you have two options:

### Option 1: Using Jupyter Notebook

- Open the Jupyter Notebook in your browser.
- Navigate to the notebook file and open it.
- Run all cells by selecting "Run All" from the menu or run each cell individually as needed.

### Option 2: Using the Command Line

If you prefer using the command line, execute the program with Python by running:
```bash
python autodoc.py <file path>
```
Replace `<file path>` with the path to your Python file you wish to document.

