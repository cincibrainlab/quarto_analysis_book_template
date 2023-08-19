#!/bin/bash

source project.sh

if [ ! -f "$PREFIX/micromamba/micromamba" ]; then
  wget https://micromamba.snakepit.net/api/micromamba/linux-64/latest -O micromamba.tar.bz

  tar -xf micromamba.tar.bz

  mkdir -p $PREFIX/micromamba

  mv bin/micromamba $PREFIX/micromamba 

  rmdir bin
  rm micromamba.tar.bz
  rm -rf info
fi

$PREFIX/micromamba/micromamba create -y --prefix $PREFIX/envs/$ENV_NAME --root-prefix $PREFIX/micromamba -f conda.yml


# Setup symbolic link to access the server from the notebook
if [ -n "$LINKED_FOLDER" ] && [ ! -L "$PREFIX/$ENV_NAME/$LINKED_FOLDER" ]; then
  ln -s $LINKED_FOLDER $PREFIX/$ENV_NAME/$LINKED_FOLDER
else
  echo "Symbolic link $LINKED_FOLDER already exists or the environment variable is not set."
fi

# Prepare R to use python environment
# Set the RETICULATE_PYTHON variable
RETICULATE_PYTHON="$PREFIX/envs/$ENV_NAME/bin/python"

# Check if the RETICULATE_PYTHON line exists in the .Renviron file
grep -q "RETICULATE_PYTHON=\"$RETICULATE_PYTHON\"" ~/.Renviron

# If the line does not exist, append it to the .Renviron file
if [ $? -ne 0 ]; then
  echo "Adding RETICULATE_PYTHON to .Renviron..."
  echo "RETICULATE_PYTHON=\"$RETICULATE_PYTHON\"" >> ~/.Renviron
  echo "RETICULATE_PYTHON has been added to .Renviron."
else
  echo "RETICULATE_PYTHON is already set in .Renviron."
fi

# Prepare the environment to use the OpenAI API key
# Set the OPENAI_API_KEY variable
OPENAI_API_KEY="" # sk- value from openai.com

# Check if the OPENAI_API_KEY line exists in the .Renviron file
grep -q "OPENAI_API_KEY=\"$OPENAI_API_KEY\"" ~/.Renviron

# If the line does not exist, append it to the .Renviron file
if [ $? -ne 0 ]; then
  echo "Adding OPENAI_API_KEY to .Renviron..."
  echo "OPENAI_API_KEY=\"$OPENAI_API_KEY\"" >> ~/.Renviron
  echo "OPENAI_API_KEY has been added to .Renviron."
else
  echo "OPENAI_API_KEY is already set in .Renviron."
fi
