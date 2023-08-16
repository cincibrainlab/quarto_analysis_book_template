# Quarto Analysis Book Template 

The Quarto Analysis Book template is designed to streamline the preparation and publication of scientific manuscripts and reports. This platform facilitates  collaboration among multiple users and integrates various data science tools, including R and Python, within a single environment. The organized file management structure ensures easy navigation and readability, allowing users to efficiently transition between preliminary analyses, testing, and the final manuscript.

The Quarto Analysis Book Template is designed to work with [Signalflow-Stacks](https://github.com/cincibrainlab/signalflow-stacks.git) which are Docker containers containing a full GUI analysis environment. With some modification this should be able to work on any local installation. 

For use in a Signalflow Container - follow the instructions below in the /srv directory of the container which should be linked to a local volume.

## Quick Start

1. Clone the repository. 

```bash
git clone https://github.com/cincibrainlab/quarto_analysis_book_template.git
```
2. Rename the folder
```bash
mv quarto_analysis_book_template/ new_project
```
3. Modify `setup/project.sh`

`PREFIX`: Root folder for Quarto Analysis Book projects.

`ENV_NAME`: Use the folder name from Step 2 as the virtual environment name.

`LINKED_FOLDER`: Folder paths can be symbolically linked within a project folder to enable access to parent directories when using programs like Jupyter Lab and RStudio. By default, these programs start in the working directory and restrict access to parent directories.

4. Modify `setup/conda.yml`

Modify `project_name` to project name from step 2 and 3. 

5. Run `setup/setup_mm.sh` to initialize the project.

This script performs the following tasks:

- Checks if Micromamba is installed; if not, it downloads and installs Micromamba in the specified folder.
- Creates a new Conda environment using the `conda.yml` configuration file.
- Sets up a symbolic link to access the server from the notebook, if the `$LINKED_FOLDER` environment variable is set and the symbolic link does not already exist.
- Configures R to use the Python environment by setting the `RETICULATE_PYTHON` variable in the `.Renviron` file.
- Adds the OpenAI API key to the `.Renviron` file.

The different file paths used in the script are:

- `$PREFIX/micromamba/micromamba`: The path where Micromamba is installed.
- `$PREFIX/envs/$ENV_NAME`: The path where the new Conda environment is created.
- `$PREFIX/$ENV_NAME/$LINKED_FOLDER`: The path where the symbolic link is created.
- `~/.Renviron`: The path to the R environment configuration file, where the `RETICULATE_PYTHON` and `OPENAI_API_KEY` variables are set.

6. Review Quarto documentation on how to edit and render books. We have included a example `quarto.yml` which is structured for an academic analysis project that includes preliminary analysis, manuscript, abstract, and grant assets.

[Quarto Documentation](https://quarto.org/docs/books/)

## Final Book/Project Structure

```
.
├── PREFIX
│   ├── ENV_NAME (book project)
│   │   └──index.qmd (book home page)
│   │   └── ... (book *.qmd files)
│   │   └──quarto.yml (book toc / config)
│   │   └──quarto_analysis_book.Rproj (open in RStudio)
│   │   └──quarto_analysis_book.code-workspace (open in VS code)
│   │   └──python_env.qmd (detailed python environment instructions)
│   │   └──useful_tools.qmd (optional softare and configuration steps)
│   │   └──setup
│   │      └──conda.yml    (update ENV_NAME and default py modules)
│   │      └──project.sh   (setup PREFIX, ENV_NAME and LINKED_FOLDER)
│   │      └──setup_mm.sh  (initialize environment)
│   │      └──start_lab.sh (Jupyter Lab startup)
│   ├── micromamba
│   │   └── micromamba (executable)
│   │   └── pkgs (downloaded py modules)
│   └── envs(python environments)
│       └── ENV_NAME
│           ├── LINKED_FOLDER (symbolic link to system folder)
│           └── ... (other environment files)
│   
└── ~/.Renviron (R environment configuration file)

```


Notes:

- Micromamba is a lightweight, standalone tool used to create isolated Python installations. It is particularly useful for managing dependencies and configurations in a project-specific manner. 
