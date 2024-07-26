#!/bin/bash
 
# Output header
echo "Repository,Branch,File,Finding,Secret,RuleID,Entropy,Commit,Author,Email,Date,Fingerprint,LineNumber" > formatted_data.csv
echo "Output header written to formatted_data.csv"
 
# Read input from file
while IFS= read -r line; do
    if [[ $line =~ Repository:\ (.+),\ Branch:\ (.*) ]]; then
        repository="${BASH_REMATCH[1]}"
        branch="${BASH_REMATCH[2]}"
    elif [[ $line =~ File:\ (.*) ]]; then
        file="${BASH_REMATCH[1]}"
    elif [[ $line =~ Finding:\ (.*) ]]; then
        finding="${BASH_REMATCH[1]}"
    elif [[ $line =~ Secret:\ (.*) ]]; then
        secret="${BASH_REMATCH[1]}"
    elif [[ $line =~ Line:\ (.*) ]]; then
        line_number="${BASH_REMATCH[1]}"
    elif [[ $line =~ RuleID:\ (.*) ]]; then
        rule_id="${BASH_REMATCH[1]}"
    elif [[ $line =~ Entropy:\ (.*) ]]; then
        entropy="${BASH_REMATCH[1]}"
    elif [[ $line =~ Commit:\ (.*) ]]; then
        commit="${BASH_REMATCH[1]}"
    elif [[ $line =~ Author:\ (.*) ]]; then
        author="${BASH_REMATCH[1]}"
    elif [[ $line =~ Email:\ (.*) ]]; then
        email="${BASH_REMATCH[1]}"
    elif [[ $line =~ Date:\ (.*) ]]; then
        date="${BASH_REMATCH[1]}"
    elif [[ $line =~ Fingerprint:\ (.*) ]]; then
        fingerprint="${BASH_REMATCH[1]}"
 
        # Append the formatted information to the CSV file
        echo "\"$repository\",\"$branch\",\"$file\",\"$finding\",\"$secret\",\"$rule_id\",\"$entropy\",\"$commit\",\"$author\",\"$email\",\"$date\",\"$fingerprint\",\"$line_number\"" >> formatted_data.csv
    fi
done < combined_sensitive_data.json
 
echo "Formatted data has been written to formatted_data.csv"
