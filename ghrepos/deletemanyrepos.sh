#!/bin/bash

# GitHub username
AUTH_USER="cezarcozta"
# List of repositories to keep
repos_to_keep=(
  "$AUTH_USER/sinprocalcs"
  "$AUTH_USER/me"
  "$AUTH_USER/Starter-Rocketseat"
  "$AUTH_USER/Starter-Rocketseat"
  "$AUTH_USER/py-count-files"
  "$AUTH_USER/basics"
  "$AUTH_USER/impacto-pet"
)
# Convert the keep list to a regex pattern
keep_pattern=$(printf "|%s" "${repos_to_keep[@]}")
keep_pattern=${keep_pattern:1}  # Remove leading |
# Fetch all public repositories
mapfile -t REPOS < <(gh repo list $AUTH_USER --limit 100 --json name --jq '.[] | .name')
# Loop through the list of repositories and delete those not in the keep_list
for repo in "${REPOS[@]}"; do
  full_repo_name="$AUTH_USER/$repo"
  visibility=$(gh api repos/$AUTH_USER/$repo --jq '.visibility')
  if [[ $visibility == "public" ]]; then
    if ! [[ $full_repo_name =~ ^($keep_pattern)$ ]]; then
      echo "Deleting repository: $full_repo_name"
      gh repo delete $full_repo_name --confirm
    else
      echo "Keeping repository: $full_repo_name"
    fi
  else
    echo "Skipping private repository: $full_repo_name"
  fi
done
