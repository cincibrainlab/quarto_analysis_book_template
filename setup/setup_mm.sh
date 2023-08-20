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

Rscript -e 'if (!requireNamespace("IRkernel", quietly = TRUE)) install.packages("IRkernel"); IRkernel::installspec()'

# update_shell_script() {
#   local file="$1"

#   if [ ! -f "$file" ]; then
#     touch "$file"
#   fi

#   # Remove the existing delimiter block
#   sed -i.bak '/^# >>> micromamba init >>>$/,/^# <<< micromamba init <<<$/{/^# >>> micromamba init >>>$/d;/^# <<< micromamba init <<<$/{d};d}' "$file"

#   # Check if the delimiter block exists and append it if not
#   grep -q "# >>> micromamba init >>>" "$file" || echo "# >>> micromamba init >>>" >> "$file"
#   grep -q "export PATH=\"$PREFIX/micromamba:\$PATH\"" "$file" || echo "export PATH=\"$PREFIX/micromamba:\$PATH\"" >> "$file"
#   grep -q "alias micromamba=\"$PREFIX/micromamba/micromamba --root-prefix $PREFIX/micromamba\"" "$file" || echo "alias micromamba=\"$PREFIX/micromamba/micromamba --root-prefix $PREFIX/micromamba\"" >> "$file"
#   grep -q "# <<< micromamba init <<<" "$file" || echo "# <<< micromamba init <<<" >> "$file"
# }

# # Update both ~/.bash_profile and ~/.bashrc
# update_shell_script "$HOME/.bash_profile"
# update_shell_script "$HOME/.bashrc"

# # Report the Micromamba status
# echo "Micromamba is activated on login with the following configuration:"
# grep -A2 "# >>> micromamba init >>>" "$HOME/.bash_profile" || grep -A2 "# >>> micromamba init >>>" "$HOME/.bashrc"

# echo "Custom folders based on \$PREFIX:"
# echo "Micromamba executable: $PREFIX/micromamba/micromamba"
# echo "Environments: $PREFIX/envs"

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
OPENAI_API_KEY="" # sk- 

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


# Add echo statements to the specified files for debugging
add_echo() {
  local file="$1"
  local message="$2"

  if [ -f "$file" ]; then
    if ! grep -q "echo \"$message\"" "$file"; then
      echo "echo \"$message\"" >> "$file"
      echo "Added echo statement to $file"
    else
      echo "Echo statement already exists in $file"
    fi
  else
    echo "$file not found"
  fi
}

# Add echo statements to the shell startup scripts
add_echo "/etc/profile" "Sourced /etc/profile"
add_echo "$HOME/.bash_profile" "Sourced ~/.bash_profile"
add_echo "$HOME/.bash_login" "Sourced ~/.bash_login"
add_echo "$HOME/.profile" "Sourced ~/.profile"
add_echo "$HOME/.bashrc" "Sourced ~/.bashrc"
