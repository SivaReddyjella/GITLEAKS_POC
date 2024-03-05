# Prompt the user for GitHub username
read -p "Enter your GitHub username: " USERNAME

# Prompt the user for Personal Access Token (PAT)
read -sp "Enter your Personal Access Token (PAT): " TOKEN


# Specify the output file
OUTPUT_FILE="repository.txt"

# Make API request to fetch repositories and store the output in a file
curl -s -H "Authorization: token $TOKEN" "https://api.github.com/users/$USERNAME/repos" | jq -r '.[].name' > "$OUTPUT_FILE"

echo "List of repositories for $USERNAME is stored in $OUTPUT_FILE."
