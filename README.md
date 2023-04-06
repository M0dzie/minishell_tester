# minishell_tester
**minishell_tester** is a tool designed to automate the testing process of a `minishell` project. To use the tool, simply clone the repository into your project folder using the following command:

```bash
git clone https://github.com/M0dzie/minishell_tester
```

## Launching the Tester
To launch the tester, navigate to the `minishell_tester` directory in your terminal and run the `tester.sh` script using the following command:

```bash
bash tester.sh
```
The tester.sh script will automatically compile your minishell project and run a series of tests to verify its functionality. The test results will be displayed in your terminal, indicating whether the project has passed or failed the tests.

## Specific Tests
To launch specific tests, you can add one of these following arguments : 
- `basic`
- `echo`
- `env`
- `export`
- `unset`
- `binary`
- `pwd`
- `exit`
- `pipes`

For example :
```bash
bash tester.sh pwd
```

## Disclaimer

`echo -n` tests are still in WIP  
The tester will only run a series of basics and errors tests, you need to make your own tests for `heredoc`, `cd` and `redirections`

## Testing Process
The testing process involves two steps: 

1. Checking the _norm_: The tester will first check the conformity of the project code with the specified norms from 42 School.

2. Building the project: If the project has not already been built, the tester will then use the `make` command to build it.

## Test Results
After running the tests, the following outcomes may occur:

- Successful output: If the output is correct, you will see a `success` message displayed on your terminal for each test.

- Failed output: If the output is incorrect, you can compare the expected output with your output by checking the `Expected output` and `Your output` sections.
