#!/bin/bash

# Git default configuration
GITHUB_ACCOUNT="cezarcozta"
GITHUB_EMAIL="cezarcozta@gmail.com.br"
GITHUB_NAME="César Augusto Costa"
GITHUB_SSH_KEY="cezarcozta"

usage() {
    echo "Usage: $0 <repo_name> [<project_dir>] [nextios]"
    exit 1
}

if [ $# -lt 1 ] || [ $# -gt 4 ]; then
    usage
fi

REPO_NAME="$1"

if [ "$3" == 'nextios' ]; then
    GITHUB_EMAIL="cesar.costa@nextios.com.br"
    GITHUB_NAME="César Augusto Costa"
    GITHUB_SSH_KEY="nextiosdev"
    GITHUB_ACCOUNT="development-nextios"
fi

PROJECT_DIR="${2:-.}"

# Check if project directory exists
if [ ! -d "$PROJECT_DIR" ]; then
    echo "Error: Project directory '$PROJECT_DIR' does not exist."
    exit 1
fi

cd "${PROJECT_DIR}" || exit 1

response=$(curl -s -o /dev/null -w "%{http_code}" "https://api.github.com/repos/$GITHUB_ACCOUNT/$REPO_NAME")

if [ "$response" -eq 200 ]; then
    echo "Error: Repository '$REPO_NAME' already exists under account '$GITHUB_ACCOUNT'."
    exit 1
fi

gh repo create "${GITHUB_ACCOUNT}/${REPO_NAME}" --description "Created by CLI script bash" --public

# Initialize the repository
git init
git remote add origin "git@github.com:${GITHUB_ACCOUNT}/${REPO_NAME}.git"

# Set Git config
git config user.email "${GITHUB_EMAIL}"
git config user.name "${GITHUB_NAME}"
git config user.signinkey "${HOME}/.ssh/${GITHUB_SSH_KEY}.pub"
eval "$(ssh-agent -s)"
ssh-add "${HOME}/.ssh/${GITHUB_SSH_KEY}"
git add .
git commit -m "bash script initial commit"
git push --set-upstream origin main