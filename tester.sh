#!/bin/bash

green='\033[0;32m'
blue='\033[1;34m'
red='\033[0;31m'
yellow='\033[0;33m'
pink='\033[0;35m'
bold='\033[1m'
nc='\033[0m'

dir='../'
dir_tests='minishell_tester/Tests/'

echo -e "${yellow}${bold}
##     ## #### ##    ## ####  ######  ##     ## ######## ##       ##      
###   ###  ##  ###   ##  ##  ##    ## ##     ## ##       ##       ##      
#### ####  ##  ####  ##  ##  ##       ##     ## ##       ##       ##      
## ### ##  ##  ## ## ##  ##   ######  ######### ######   ##       ##      
##     ##  ##  ##  ####  ##        ## ##     ## ##       ##       ##      
##     ##  ##  ##   ###  ##  ##    ## ##     ## ##       ##       ##      
##     ## #### ##    ## ####  ######  ##     ## ######## ######## ########
by Modzie${nc}"

## Make project ##
printf "\n\n${blue}${bold}#####		MAKE		#####\n${nc}"
cd ${dir}
if test -f Makefile; then
    make 1>/dev/null
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
printf "\n${blue}${bold}#####		TEST NORM		#####\n\n${nc}"
norminette -R CheckForbiddenSourceHeader 1>/dev/null
if [[ $? -eq 0 ]]; then
    echo -e "${green}${bold}Norm OK ✓${nc}"
else
    echo -e "${red}${bold}⚠️ Norm KO ⚠️${nc}"
fi

## Exec command in minishell ##
exec_cmd()
{
    cmd="$1"
    output=$(echo "$cmd" | ./minishell | sed '1d;$d')
    echo "$output"
}

success=0
fail=0
## Check if the output is good ##
check_result()
{
    expected_output="$1"
    your_output="$2"
    if [[ "$expected_output" = "$your_output" ]]; then
        echo -e "${green}${bold}Success ✓${nc}"
		((success++))
    else
        echo -e "${red}${bold}⚠️ Fail ⚠️${nc}"
		echo -e "${bold}Test : $test${nc}$"
        echo -e "${green}Expected output : ${nc}$expected_output"
        echo -e "${red}Your ouput : ${nc}$your_output"
		((fail++))	
    fi
}

## Check the exit value with $? ##
check_exit_value()
{
	bash_exit="$1"
	your_exit="$2"
	echo "$1 et $2"
	if [[ "$bsah_exit" = "$your_exit" ]]; then
		echo -e "${green}${bold}Exit value OK ✓${nc}"
		((success++))
	else
        echo -e "${red}${bold}⚠️ Wrong exit value ⚠️${nc}"
        echo -e "${green}Expected value : ${nc}$bash_exit"
        echo -e "${red}Your value : ${nc}$your_exot"
		((fail++))
	fi
}

## Read file ##
read_test_file()
{
	i=1
	while IFS= read -r test; do
		echo 
		echo -e "${pink}${bold}test $i:${nc}"; ((i++))
		check_result "$(echo "$test" | bash)" "$(exec_cmd "$test")"
	done < "$1"
}

## Tests ##
if [[ $1 == "basic" ]]; then
	printf "${blue}${bold}\n\n#####		BASIC TESTS		#####\n${nc}"
	read_test_file "${dir_tests}basic_tests"
elif [[ $1 == "echo" ]]; then
	printf "${blue}${bold}\n\n#####		TESTS ECHO		#####\n${nc}"
	read_test_file "${dir_tests}echo_tests"
elif [[ $1 == "env" ]]; then
	printf "${blue}${bold}\n\n#####		TESTS ENV		#####\n${nc}"
	read_test_file "${dir_tests}env_tests"
elif [[ $1 == "export" ]]; then
	printf "${blue}${bold}\n\n#####		TESTS EXPORT		#####\n${nc}"
	read_test_file "${dir_tests}export_tests"
elif [[ $1 == "unset" ]]; then
	printf "${blue}${bold}\n\n#####		TESTS UNSET		#####\n${nc}"
	read_test_file "${dir_tests}unset_tests"
elif [[ $1 == "binary" ]]; then
	printf "${blue}${bold}\n\n#####		TESTS BINARY		#####\n${nc}"
	read_test_file "${dir_tests}binary_tests"
elif [[ $1 == "pwd" ]]; then
	printf "${blue}${bold}\n\n#####		TESTS PWD		#####\n${nc}"
	read_test_file "${dir_tests}pwd_tests"
elif [[ $1 == "cd" ]]; then
	printf "${blue}${bold}\n\n#####		TESTS CD		#####\n${nc}"
	read_test_file "${dir_tests}cd_tests"
elif [[ $1 == "exit" ]]; then
	printf "${blue}${bold}\n\n#####		TESTS EXIT		#####\n${nc}"
	read_test_file "${dir_tests}exit_tests"
elif [[ $1 == "pipes" ]]; then
	printf "${blue}${bold}\n\n#####		TESTS PIPES		#####\n${nc}"
	read_test_file "${dir_tests}pipes_tests"
elif [[ $1 == "redir" ]]; then
	printf "${blue}${bold}\n\n#####		TESTS REDIRECTIONS		#####\n${nc}"
	read_test_file "${dir_tests}redirections_tests"
elif [[ $1 == "heredoc" ]]; then
	printf "${blue}${bold}\n\n#####		TESTS HEREDOC		#####\n${nc}"
	read_test_file "${dir_tests}heredoc_tests"
else
	printf "${blue}${bold}\n\n#####		BASIC TESTS		#####\n${nc}"
	read_test_file "${dir_tests}basic_tests"
	printf "${blue}${bold}\n\n#####		TESTS ECHO		#####\n${nc}"
	read_test_file "${dir_tests}echo_tests"
	printf "${blue}${bold}\n\n#####		TESTS ENV		#####\n${nc}"
	read_test_file "${dir_tests}env_tests"
	printf "${blue}${bold}\n\n#####		TESTS EXPORT		#####\n${nc}"
	read_test_file "${dir_tests}export_tests"
	printf "${blue}${bold}\n\n#####		TESTS UNSET		#####\n${nc}"
	read_test_file "${dir_tests}unset_tests"
	printf "${blue}${bold}\n\n#####		TESTS BINARY		#####\n${nc}"
	read_test_file "${dir_tests}binary_tests"
	printf "${blue}${bold}\n\n#####		TESTS PWD		#####\n${nc}"
	read_test_file "${dir_tests}pwd_tests"
	printf "${blue}${bold}\n\n#####		TESTS CD		#####\n${nc}"
	read_test_file "${dir_tests}cd_tests"
	printf "${blue}${bold}\n\n#####		TESTS EXIT		#####\n${nc}"
	read_test_file "${dir_tests}exit_tests"
	printf "${blue}${bold}\n\n#####		TESTS PIPES		#####\n${nc}"
	read_test_file "${dir_tests}pipes_tests"
	printf "${blue}${bold}\n\n#####		TESTS REDIRECTIONS		#####\n${nc}"
	read_test_file "${dir_tests}redirections_tests"
	printf "${blue}${bold}\n\n#####		TESTS HEREDOC		#####\n${nc}"
	read_test_file "${dir_tests}heredoc_tests"
fi

## Print score ##
printf "${blue}${bold}\n\n#####		FINAL SCORE		#####\n\n${nc}"
total=$((success + fail))
res=$(( 100 * success / total + (1000 * success / total % 10 >= 5 ? 1 : 0) ))
echo -e "${pink}${bold}$res%${nc}"
if [[ $res -gt 90 ]]; then
	echo -e "${green}${bold}Congratulations ✓${nc}"
else
	echo -e "${red}${bold}⚠️ You failed ! ⚠️${nc}"
fi

## Cleaning files ##
rm -rf a b c d e dir bonjour bonjour1 cat echo export hey hola HOLA rm hello hola1 hola2 ls ls1 bonjour_1 prout pwd whereis
cd ~ > /dev/null
rm -rf bonjour hello bonjour
cd - > /dev/null
