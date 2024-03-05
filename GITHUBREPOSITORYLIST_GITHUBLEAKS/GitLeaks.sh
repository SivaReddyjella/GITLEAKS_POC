#!/bin/bash

# GitHub username
read -p "Enter your GitHub username: " USERNAME

# GitHub Personal Access Token (PAT)
read -sp "Enter your Personal Access Token (PAT): " TOKEN

# Directory to store cloned repositories
CLONE_DIR="/home/ubuntu/GITHUBREPOS/siva/Final/cloned_repositories"

# Ensure clone directory exists
mkdir -p "$CLONE_DIR"

# List of repositories to clone
REPOSITORY_FILE="repository.txt"

# Create an empty JSON file to store the combined sensitive data
SENSITIVE_DATA_FILE="$CLONE_DIR/sensitive_data.json"
touch "$SENSITIVE_DATA_FILE"

# Loop through each repository name in repository.txt
while IFS= read -r repo_name; do
    echo "Processing $repo_name"

    # Clone the repository
    git clone "https://$USERNAME:$TOKEN@github.com/$USERNAME/$repo_name.git" "$CLONE_DIR/$repo_name"

    # Navigate into the cloned repository
    cd "$CLONE_DIR/$repo_name" || continue

    # Fetch all branches
    git fetch --all

    # Loop through each branch
    for branch in $(git branch -r | grep -v '\->'); do
        # Check out the branch
        git checkout --track "$branch"

        # Print the user data
        (echo "Repository: $repo_name, Branch: $branch"

        # Run GitLeaks to search for sensitive data and append JSON output to the file
        gitleaks detect --report-format=json --verbose) >> "$SENSITIVE_DATA_FILE"
    done

    # Move out of the repository directory
    cd ..

    # List the active directories after scanning the repository
    echo "Active directories after scanning repository $repo_name:"
    ls -l "$CLONE_DIR"

done < "$REPOSITORY_FILE"

echo "All repositories processed. Sensitive data appended to $SENSITIVE_DATA_FILE."

