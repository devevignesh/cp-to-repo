#!/bin/sh -l

set -e  # if a command fails it stops the execution
set -u  # script fails if trying to access to an undefined variable

echo "starts"
SOURCE_DIR="$1"
DESTINATION_GITHUB_USERNAME="$2"
DESTINATION_REPOSITORY_NAME="$3"
USER_EMAIL="$4"
USER_NAME="$5"
TARGET_BRANCH="$6"
COMMIT_MESSAGE="$7"
API_TOKEN_GITHUB="$8"

# if [-z "$DESTINATION_GITHUB_USERNAME"]
# then 
#     DESTINATION_GITHUB_USERNAME="$DESTINATION_GITHUB_USERNAME"
# fi

# if [-z "$USER_NAME"]
# then 
#     USER_NAME="$DESTINATION_GITHUB_USERNAME"
# fi

TEMP_DIR=$(mktemp -d)

echo "Cloning destination git repository"
# Setup git
git config --global user.email "$USER_EMAIL"
git config --global user.name "$USER_NAME"
git clone -n "https://$USER_NAME:$API_TOKEN_GITHUB@github.com/$DESTINATION_GITHUB_USERNAME/$DESTINATION_REPOSITORY_NAME.git" --depth 1 "$TEMP_DIR"
cd "$TEMP_DIR"
git reset HEAD
git checkout HEAD "src/index.html"

echo "list source dir"
cd "$SOURCE_DIR"

echo "Copy index.html to target git repo"
ls "$SOURCE_DIR"

cp "$SOURCE_DIR"/index.html "$TEMP_DIR"/src/.
cd "$TARGET_DIR"

echo "Files that will be pushed"
ls

echo "git commit"
git commit -m "build file"

echo "git push origin"
git push "https://$USER_NAME:$API_TOKEN_GITHUB@github.com/$DESTINATION_GITHUB_USERNAME/$DESTINATION_REPOSITORY_NAME" --set-upstream "$TARGET_BRANCH"

echo "success"
