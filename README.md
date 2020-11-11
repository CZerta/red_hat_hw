# red_hat_hw
This repo contains two scripts that take input and shuffle paragraphs from it.

## Running

- "python3 rh_python.py" or "chmod +x rh_python.py && ./rh_python.py"
- "bash rh_bash.sh" or "chmod +x rh_bash.sh && ./rh_bash.sh"

## Parameters

Both scripts take three optional parameters.
- rh_bash.py [-h] [-i INPUT_FILE] [-o OUTPUT_FILE]
- rh_python.py [-h] [-i INPUT_FILE] [-o OUTPUT_FILE]
```
  -h, --help            show this help message and exit
  -i INPUT_FILE, --input-file INPUT_FILE
                        input file (stdin if omitted)
  -o OUTPUT_FILE, --output-file OUTPUT_FILE
                        output file (stdout if omitted)
```

## Special cases
If there is not new line at the end of input, output also will not have empty line at the end.
If there are more continual blank lines, scripts take it as empty paragraph. This is similar for empty lines at beginning and end of file.

