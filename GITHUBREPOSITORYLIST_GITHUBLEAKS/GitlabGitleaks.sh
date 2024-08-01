
#!/bin/bash
 
# URL-encoded GitLab username and personal access token

USERNAME="Gangula%20Prathap%20Reddy%20CHALAMAKUNTA"

TOKEN="8jmstUzuFGrPgCc-Fb9b"
 
# Clone function to clone repositories

clone_repository() {

    local repo_url="$1"

    local repo_dir="$2"
 
    # Clone the repository using Git with the provided token in the URL

    echo "Cloning repository $repo_url..."

    git clone "$repo_url" "$repo_dir"
 
    # Check if the clone was successful

    if [ $? -ne 0 ]; then

        echo "Failed to clone repository $repo_url. Please check your GitLab username, Personal Access Token, and the repository URL."

        exit 1

    fi
 
    # Navigate into the cloned repository

    cd "$repo_dir" || exit 1
 
    # Create an empty JSON file to store the sensitive data

    touch ../combined_sensitive_data.json
 
    # Fetch all branches from remote

    git fetch --all
 
    # Iterate through each branch in the repository

    for branch in $(git branch -r | grep -v '\->'); do

        # Remove "origin/" prefix from branch name

        branch_name=$(echo "$branch" | sed 's/origin\///')
 
        # Checkout each branch

        git checkout --track "$branch_name"
 
        # Iterate through last 50 commits in the branch

        commit_count=0

        git rev-list --max-count=50 HEAD | while read -r commit_hash; do

            commit_count=$((commit_count + 1))

            # Loop through each file in the commit

            git diff-tree --no-commit-id --name-only -r "$commit_hash" | while read -r file; do

                # Print the user data

                echo "File: $file"

                (

                    # Extract repository name from URL

                    repo_name=$(basename "$repo_url" .git)

                    echo "Repository: $repo_name, Branch: $branch_name"

                    # Run GitLeaks to search for sensitive data and append JSON output to the file

                    gitleaks detect --report-format=json --verbose "$file" | sed 's/\x1B\[[0-9;]*[JKmsu]//g'

                ) >>../combined_sensitive_data.json

            done

        done

    done
 
    echo "Sensitive data appended to combined_sensitive_data.json."

}
 
# Clone the repositories

declare -a repos=(

    "mt-digital-ui/mt-products/hrms/applications/frontend/hrms-global-web.git"

)
 
# Clone repositories and append sensitive data

for repo_url in "${repos[@]}"; do

    # Extract repository name from URL to use as directory name

    repo_dir=$(basename "$repo_url" .git)

    # Clone repositories

    clone_repository "https://$USERNAME:$TOKEN@gitlab.mouritech.com/$repo_url" "$repo_dir"

done

after run this you need to run formated.csv file by using below code
 ----------------------------------------------------------------------------------------
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
