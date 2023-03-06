#!/bin/bash

green='\033[0;32m'
blue='\033[1;34m'
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

## Make project ##
if test -f Makefile; then
    make
	echo 
	if [[ $? -eq 0 ]]; then
		echo -e "${green}${bold}Compilation succeeded ✓${nc}"
	else
		echo -e "${red}${bold}⚠️ Compilation failed ⚠️${nc}"
		exit 1
	fi
	echo 
fi

## Norm test ##
printf "${blue}${bold}#####		TEST NORM		#####\n\n${nc}"
norminette -R CheckForbiddenSourceHeader 1>/dev/null
if [[ $? -eq 0 ]]; then
    echo -e "${green}${bold}Norm OK ✓${nc}"
else
    echo -e "${red}${bold}⚠️ Norm KO ⚠️${nc}"
fi

## Test functions ##
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
        echo -e "${green}${bold}Success ✓${nc}"
    else
        echo -e "${red}${bold}⚠️ Fail ⚠️${nc}"
        echo "Expected output : $expected_output"
        echo  "Your ouput : $your_output"
    fi
}

tests=(
    ### ECHO ###
    ["echo "echo " $ """]=" $ "
    ["echo "echo "salut a tous"""]="salut a tous"

    ### VAR ENV ###
    ["echo \"$HOME\""]=$HOME
)

for cmd in "${!tests[@]}"
do
    expected_output="${tests[$cmd]}"
    your_output="$(exec_cmd "$cmd")"
    check_result "$expected_output" "$your_output"
done