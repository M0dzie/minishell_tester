#!/bin/bash

green='\033[0;32m'
red='\033[0;31m'
yellow='\033[0;33m'

bold="\033[1m"
nc='\033[0m'

echo -e "${yellow}${bold}
.##.....##.####.##....##.####..######..##.....##.########.##.......##......
.###...###..##..###...##..##..##....##.##.....##.##.......##.......##......
.####.####..##..####..##..##..##.......##.....##.##.......##.......##......
.##.###.##..##..##.##.##..##...######..#########.######...##.......##......
.##.....##..##..##..####..##........##.##.....##.##.......##.......##......
.##.....##..##..##...###..##..##....##.##.....##.##.......##.......##......
.##.....##.####.##....##.####..######..##.....##.########.########.########
by Modzie${nc}"
echo

exec="minishell $>"

if test -f Makefile; then
    make
fi

norminette_success=true
find . -name "*.c" -exec sh -c '
    if test -f norminette; then
        ./norminette -R CheckForbiddenSourceHeader "$1"
        if [ $? -ne 0 ]; then
            exit 1
        fi  
    fi
' sh {} \; || norminette_success=false

if [ $norminette_success = true ]; then
    echo -e "${green}${bold}Norm OK${nc}"
else
    echo -e "${red}${bold}Norm KO${nc}"
fi

exec_cmd()
{
    cmd="$1"
    output=$(echo "$cmd" | ./minishell)
    echo "$output"
}

check_result()
{
    expected_output="$1"
    your_output="$2"
    if [ "$expected_output" = "$your_output" ]; then
        echo -e "${green}${bold}Success${nc}"
    else
        echo -e "${red}${bold}Fail${nc}"
        echo "Expected output : $expected_output"
        echo  "Your ouput : $your_output"
    fi
}

tests=(
    ### ECHO ###
    ["echo ' $ '"]=" $ "
    ["echo 'salut a tous'"]="salut a tous"

    ### VAR ENV ###
    ["echo \"$HOME\""]=$HOME
)

for cmd in "${!tests[@]}"
do
    expected_output="${tests[$cmd]}"
    your_output="$(exec_cmd "$cmd")"
    check_result "$expected_output" "$your_output"
done