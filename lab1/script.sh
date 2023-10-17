#!/bin/bash -e

target=$1
folder_temporary=$(mktemp -d)

if [[ -z "$target" ]]; then
echo "Enter the filename. For example, $0 program1.cpp"
exit 1
fi

complete_name="$(grep -i "Output:" "$target" | cut -d ':' -f2- | tr -d '[:space:]/')"

if [[ -z "$complete_name" ]]; then
echo "Name for output file is missing or not determined."
exit 1
fi

function cleanup_function() {
local rc=$?
echo "Removing temp directory: $folder_temporary"
rm -rf "$folder_temporary"
exit $rc
}

trap cleanup_function EXIT HUP INT QUIT PIPE TERM

copy_source="$(cp "$target" "$folder_temporary")"
current_directory=$(pwd)
go_temp_direct="$(cd "$folder_temporary")"

file_extension="${target##*.}"

declare -A compiler=( ["c"]="gcc" ["cpp"]="g++" )

if [[ ${compiler[$file_extension]} ]]; then
${compiler[$file_extension]} "$target" -o "$complete_name"
else
echo "Unsupported file type"
exit 1
fi

move_output="$(mv "$complete_name" "$current_directory")"
get_back="$(cd "$current_directory")"

echo "Successfully compiled: $complete_name"

exit 0
