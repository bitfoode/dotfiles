# Get the name of the shell executing the script
shell_name=$(ps -p $$ -o comm=)
# If the shell is zsh, run autoload bashcompinit and bashcompinit
if [[ $shell_name == *zsh* ]]; then
autoload bashcompinit && bashcompinit
fi
# For both bash and zsh, set up AWS CLI completion
complete -C 'aws_completer' aws
