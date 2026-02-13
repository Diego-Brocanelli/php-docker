inputText()
{
    local placeholder="$1"
    local default_value="${2:-}"

    if [ -n "$default_value" ]; then
        gum input --placeholder "$placeholder" --value "$default_value"
    else
        gum input --placeholder "$placeholder"
    fi
}
choiceOption()
{
    local prompt="$1"
    shift
    local options=("$@")

    gum choose $prompt "${options[@]}"
}