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

CLONE_DIR=$(mktemp -d)

echo "Cloning destination git repository"
# Setup git
git config --global user.email "$USER_EMAIL"
git config --global user.name "$USER_NAME"
git clone -n "https://$USER_NAME:$API_TOKEN_GITHUB@github.com/$DESTINATION_REPOSITORY_USERNAME/$DESTINATION_REPOSITORY_NAME.git" --depth 1 "$CLONE_DIR"
git reset HEAD
git checkout HEAD "src/index.html"

TARGET_DIR=$(mktemp -d)

mv "src/index.js" "$TARGET_DIR"

# if [ ! -d "$SOURCE_DIRECTORY" ]
# then 
#     echo "ERROR: $SOURCE_DIRECTORY does not exist"
# fi

echo "Copy index.html to target git repo"
cp "$SOURCE_DIRECTORY" "$TARGET_DIR"
cd "$TARGET_DIR"

echo "Files that will be pushed"
ls

echo "git add"
git add .

echo "git commit"
git commit -m "build file"

echo "git push origin"
git push "https://$USER_NAME:$API_TOKEN_GITHUB@github.com/$DESTINATION_GITHUB_USERNAME/$DESTINATION_REPOSITORY_NAME" --set-upstream "$TARGET_BRANCH"

echo "success"
