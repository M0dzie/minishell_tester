#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m'

echo -e "${YELLOW}
.##.....##.####.##....##.####..######..##.....##.########.##.......##......
.###...###..##..###...##..##..##....##.##.....##.##.......##.......##......
.####.####..##..####..##..##..##.......##.....##.##.......##.......##......
.##.###.##..##..##.##.##..##...######..#########.######...##.......##......
.##.....##..##..##..####..##........##.##.....##.##.......##.......##......
.##.....##..##..##...###..##..##....##.##.....##.##.......##.......##......
.##.....##.####.##....##.####..######..##.....##.########.########.########
by Modzie${NC}"
echo

EXEC="minishell $>"

if test -f Makefile; then
    make
fi

norminette_success=true
for file in $(find . -name "*.c"); do
    if test -f norminette; then
        ./norminette "$file"
        if [ $? -ne 0 ]; then
            norminette_success=false
        fi
    fi
done

if [ $norminette_success = true ]; then
    echo -e "${GREEN}Norm OK${NC}"
else
    echo -e "${RED}Norm KO${NC}"
fi

exec_cmd()
{
    cmd=$(echo "$1" | ./minishell)
    echo "$cmd"
}

check_result()
{
    expected_output="$1"
    your_output="$2"
    if [ "$expected_output" = "$your_output" ]; then
        echo -e "${GREEN}Success${NC}"
    else
        echo -e "${RED}Fail${NC}"
        echo -e "Expected output : $expected_output"
        echo -e "Your ouput : $your_output"
    fi
}

tests=(
    ### ECHO ###
    ["echo 'salut a tous'"]="salut a tous"
    ["echo ' $ '"]=" $ "

    ### VAR ENV ###
    ["echo \"$HOME\""]=$HOME
)

for cmd in "${!tests[@]}"
do
    expected_output="${tests[$cmd]}"
    your_output="$(exec_cmd "$cmd")"
    check_result "$expected_output" "$your_output"
done