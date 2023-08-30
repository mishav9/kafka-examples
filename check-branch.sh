#!/bin/bash

# Name of the target branch (main or master)
target_branch="main"

# Get the current branch name
current_branch=$(git symbolic-ref --short HEAD 2>/dev/null)

if [ -z "$current_branch" ]; then
    echo "Not in a Git repository."
    exit 1
fi

# Get the first commit hash of the current branch
current_first_commit=$(git rev-list --max-parents=0 HEAD)

# Get the first commit hash of the target branch
target_first_commit=$(git rev-list --max-parents=0 "$target_branch")

if [ "$current_first_commit" = "$target_first_commit" ]; then
    echo "The current branch '$current_branch' was created from '$target_branch'."
else
    echo "The current branch '$current_branch' was NOT created from '$target_branch'."
fi
