
# Loads common project variables
source project.sh
$PREFIX/envs/$ENV_NAME/bin/jupyter lab --notebook-dir=$PREFIX/$ENV_NAME
