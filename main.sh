#!/bin/bash

# Check if exactly two filenames are provided
if [ "$#" -ne 2 ]; then
    echo " Please type exactly 2 file names in the following format:"
    echo " $0 <input_file> <output_file>"
    exit 1
fi

input_file="$1"
output_file="$2"

# Check if the input file exists
if [ ! -f "$input_file" ]; then
    echo "Error: Input file '$input_file' does not exist."
    exit 1
fi

echo "------------------" > "$output_file"
echo "Unique cities in the given data file:" >> "$output_file"

# Print unique cities from input file to output file
awk -F ', ' 'NR > 1 {print $3}' "$input_file" | sort -u >> "$output_file"

# Print another separator
echo "------------------" >> "$output_file"
echo "Details of top 3 individuals with the highest salary:" >> "$output_file"

# Find top 3 individuals with highest salary and save to output file
awk -F ', ' 'NR > 1 {print $4, $0}' "$input_file" | sort -t ',' -k 1,1nr -k 2,2 -k 3,3 | head -n 3 | cut -d ' ' -f 2- >> "$output_file"

# Print another separator
echo "------------------" >> "$output_file"
echo "Details of average salary of each city:" >> "$output_file"

# Compute average salary for each city and save to output file
awk -F ',' 'NR > 1 {sum[$3] += $4; count[$3]++} END {for (city in sum) print "City:" city ", Salary: " sum[city] / count[city]}' "$input_file" >> "$output_file"

# Calculate overall average salary
overall_average=$(awk -F ', ' 'NR > 1 {sum += $4; count++} END {print sum / count}' "$input_file")

# Print another separator
echo "------------------" >> "$output_file"
echo "Details of individuals with a salary above the overall average salary:" >> "$output_file"

# Identify individuals with salary above overall average and save to output file
awk -v avg="$overall_average" -F ', ' 'NR > 1 && $4 > avg {print $1 "  " $2 "  " $3 "  " $4}' "$input_file" >> "$output_file"

# Print another separator
echo "------------------" >> "$output_file"
echo "Operation completed successfully."
