#!/bin/sh -l

set -e  # if a command fails it stops the execution
set -u  # script fails if trying to access to an undefined variable

echo "starts"
SOURCE_DIRECTORY="$1"
DESTINATION_GITHUB_USERNAME="$2"
DESTINATION_REPOSITORY_NAME="$3"
USER_EMAIL="$4"
USER_NAME="$5"
DESTINATION_REPOSITORY_USERNAME="$6"
TARGET_BRANCH="$7"
COMMIT_MESSAGE="$8"
API_TOKEN_GITHUB="$9"

# if [-z "$DESTINATION_REPOSITORY_USERNAME"]
# then 
#     DESTINATION_REPOSITORY_USERNAME="$DESTINATION_REPOSITORY_USERNAME"
# fi

# if [-z "$USER_NAME"]
# then 
#     USER_NAME="$DESTINATION_REPOSITORY_USERNAME"
# fi

# if [ ! -d "$SOURCE_DIRECTORY" ]
# then 
#     echo "ERROR: $SOURCE_DIRECTORY does not exist"
# fi

TARGET_DIR=$(mktemp -d)

echo "Copy index.html to target git repo"
cp "$SOURCE_DIRECTORY" "$TARGET_DIR"
cd "$TARGET_DIR"

echo "Files that will be pushed"
ls

echo "git add"
git add .

echo "git status"
git status

echo "git diff-index"
git diff-index --quiet HEAD || git commit --message "build file"

echo "git push origin"
# --set-upstream: sets de branch when pushing to a branch that does not exist
git push "https://$USER_NAME:$API_TOKEN_GITHUB@github.com/$DESTINATION_GITHUB_USERNAME/$DESTINATION_REPOSITORY_NAME.git" --set-upstream "$TARGET_BRANCH"