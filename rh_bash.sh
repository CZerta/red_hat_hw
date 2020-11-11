#!/usr/bin/env bash

function print_help() {
  # print help and exit
  echo "usage: rh_bash.py [-h] [-i INPUT_FILE] [-o OUTPUT_FILE]"
  echo
  echo "Shuffle paragraphs"
  echo
  echo "optional arguments:"
  echo "  -h, --help            show this help message and exit"
  echo "  -i INPUT_FILE, --input-file INPUT_FILE"
  echo "                        input file (stdin if omitted)"
  echo "  -o OUTPUT_FILE, --output-file OUTPUT_FILE"
  echo "                        output file (stdout if omitted)"
  exit $1
}

# process args, if fail print help and quit
args=$(getopt -uo i:o:h -l input-file:,output-file:,help -- "$@") || { print_help 1; }
set -- ${args}

while true; do
  case $1 in
  -h | --help)
    print_help 0
    ;;
  -i | --input-file)
    shift
    INPUT_FILE="${1}"
    ;;
  -o | --output-file)
    shift
    OUTPUT_FILE="${1}"
    ;;
  --) break ;;
  esac
  shift
done

if [[ -n ${INPUT_FILE} ]]; then
  # read from file
  if [[ ! -f ${INPUT_FILE} ]]; then
    # check existence of input file
    echo "Input file does not exists." 1>&2
    exit 2
  fi
  while read -r line; do
    text="${text}"${line}$'\n'
  done < ${INPUT_FILE}
  text="${text}"${line}
else
  # read from stdin
  while read -r line; do
    text="${text}"${line}$'\n'
  done
  text="${text}"${line}
fi

new_line=1
if [[ "${text: -1}" != $'\n' ]]; then
  # if there is not new line at the end of file, add now and remove at the end
  text+=$'\n'
  new_line=0
fi

# prepare paragraphs
list_to_shuffle=()
while IFS= read -r line; do
  if [[ -n ${line} ]]; then
    paragraph+=${line}$'\n'
  else
    list_to_shuffle+=("${paragraph}"$'\n')
    paragraph=''
  fi
done <<< "${text}"

# generate random sequence and concat paragraphs accordingly
for p in $(shuf -i 1-${#list_to_shuffle[@]}); do
  output+=${list_to_shuffle[${p} - 1]}
done

if [[ ${new_line} -eq 1 ]]; then
  # remove extra new line from end
  output=${output:0:${#output}-1}
else
  # remove two extra new lines from the end
  output=${output:0:${#output}-2}
fi

if [[ -n ${OUTPUT_FILE} ]]; then
  # output to file
  echo -n "${output}" > ${OUTPUT_FILE}
else
  # output to stdin
  echo -n "${output}"
fi

exit 0
