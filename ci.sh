#!/bin/bash

# Define the branch to merge into (main branch) and the development branch
main_branch="main"
dev_branch="dev"

# Get the current branch name
current_branch=$(git symbolic-ref --short HEAD)

# Check if the current branch is not the main branch
if [ "$current_branch" != "$main_branch" ]; then
    # Get the base branch (parent branch) of the current branch
    base_branch=$(git merge-base $current_branch $main_branch)

    # Check if the base branch is not the development branch
    if [ "$base_branch" != "$(git merge-base $dev_branch $main_branch)" ]; then
        echo "Error: The current branch '$current_branch' is not created from the '$dev_branch' branch."
        echo "Merge cancelled."
        exit 1
    fi
fi

# If everything is fine, continue with the commit
exit 0



# .gitlab-ci.yml

pre_commit_check:
  before_script:
    - apt-get update
    - apt-get install -y git
  script:
    - git fetch --all # Fetch all branches before checking them out
    - current_branch=$(git symbolic-ref --short HEAD)
    - main_branch="main"
    - dev_branch="dev"
    - base_branch=$(git merge-base $current_branch $main_branch)
    - if [ "$current_branch" != "$main_branch" ] && [ "$base_branch" != "$(git merge-base $dev_branch $main_branch)" ]; then
    -   echo "Error: The current branch '$current_branch' is not created from the '$dev_branch' branch."
    -   exit 1
    - fi


stages:
  - check_branch

check_branch:
  script:
    - if [ "$CI_COMMIT_REF_NAME" != "master" ] && [ "$(git merge-base --is-ancestor master "$CI_COMMIT_REF_NAME" && echo true)" != "true" ]; then
        echo "Branch is not created from master.";
      else
        echo "Branch is created from master.";
      fi

