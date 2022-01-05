---
id: 20211216152226
created: 2021-12-16T15:22:26-0800
modified: 2021-12-16T15:22:26-0800
---
# Pluralsight Course: Getting Started with Jupyter Notebook and Python

- Interactive Environment vs IDE, or text editor
- Data science workflow
  - set up an experiment
  - supply initial parameters
  - run the experiment
  - gather results
  - tweak params & repeat
- REPL - Read-Evaluate-Print Loop
- History
  - Python REPL
  - IPython to enhance basic Python REPL
  - IPython Notebook
    - Local server, open in browser
    - sessions saved to disk as notebook files
    - Visualizations
    - Will render static version in GitHub
  - Jupiter Notebook = a shell to support languages other than Python (e.g. R or F#)
- Installation methods
  - Python via Pip
  - [Anaconda](https://www.anaconda.com/download)
    - 1000+ data science packages, including Python and Jupyter Notebooks
    - 400-500 Mb install, but has everything to get started
  - Docker ([good base image](https://hub.docker.com/r/jupyter/datascience-notebook))

    ```shell
    docker pull jupyter/datascience-notebook
    ```

  - [Azure Notebooks](https://notebooks.azure.com)
    - many datascience packages pre-installed e.g. `numpy`, `pandas`

- example
  - Sieve of Aristophanes [[Sieve of Aristophanes]]

## How it works

- cell = block of either code, or markdown
- can run code in the cell, and print the output below the cell
- "[SHIFT+ENTER]" = run cell, and select the next cell
- "[SHIFT+TAB]" = show documentation for function at cursor
- can only infer about code that has been run inside a cell, which affects whether tab completion will find functions, etc.
- can execute shell commands inside code cells
  - prefix with `!` e.g. `!pwd` to print working directory
  - can be combined with python e.g.

    ```jupyter
    files = !ls
    ```

  - can pass arguments to shell commands by wrapping in curly-braces e.g.

    ```jupyter
    filename = 'README.txt'
    !cat {filename}
    ```

  - Input and output of cells are available via the `In[n]` and `Out[n]` collections, where the index is an integer representing the cell position in the notebook
  - Underscore (`_`) holds the value of the **most recent** output (which is not necessarily the last cell in the notebook, or even the previous cell, if you run cells out of order)
    - it is common to use underscore to represent a throwaway value in python.
      Watch out for conflicts between the throwaway value pattern and the Jupyter functionality

## Reference

- _Getting Started with Jupyter Notebook and Python_ on PluralSight <https://app.pluralsight.com/course-player?courseId=8b54dbf1-c0ab-4d68-b092-10674d8fe1a9>
