define_project_name()
{
    local name=$(inputText "Project name")

    check_empty "$name" "Project name" || return 1

    # Retorna os dois valores separados por pipe
    echo "$name"
}
