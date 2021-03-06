#!/bin/bash
set -e

EXTENSION=markdown

function main() {
  TITLE="$@"
  # Check that we have a an argument
  if ! [ "${TITLE}" ]
  then
    echo "Usage: `basename $0` { <title for new post> | <existing draft to publish> }"
    echo "Example: `basename $0` \"My post\" (same if \"my-post.${EXTENSION}\" already exists.)"
    exit 1
  fi

  # Add extension
  # Create the file name -- lowercase and replace spaces with -
  FILE_NAME=`echo "${TITLE}" | tr "[A-Z]" "[a-z]" | tr " " "-"`
  FILE_NAME=${FILE_NAME}.${EXTENSION}
  FILE_PATH="_drafts/${FILE_NAME}"

  # If the file exists, consider it a draft and publish it; otherwise, create a new draft with that name
  echo file: ${FILE_PATH}
  if ! [ -f "${FILE_PATH}" ]; then
    create_new_draft
  else
    publish_draft
  fi
}

function create_new_draft() {
  echo "Creating new draft with title: '${TITLE}'."
  echo "Saving draft with filename: '${FILE_NAME}'."

  # Remove to get content of file to stdout
  # FILE_PATH="/dev/stdout"

  # Create the front matter
  echo "---" >> ${FILE_PATH}
  echo "layout: post" >> ${FILE_PATH}
  echo "title: \"$TITLE\"" >> ${FILE_PATH}
  echo "#date:" >> ${FILE_PATH}
  echo "---" >> ${FILE_PATH}
  echo "" >> ${FILE_PATH}

  # Open the file in the standard editor for this extension
  open "${FILE_PATH}"
}

function publish_draft() {
  DRAFT=${FILE_PATH}
  echo "Publishing draft: '${DRAFT}'."

  DRAFT_FILE_PATH="${DRAFT}"

  # Generate date and time to use for name and in front matter
  TODAYS_DATE=`date "+%Y-%m-%d"`
  TODAYS_DATE_AND_TIME=`date "+%Y-%m-%d %H:%M:%S"`

  # Prepend the current date to the file name of the draft
  POST_FILE_PATH="_posts/${TODAYS_DATE}-`basename ${DRAFT}`"
  echo "Publishing post at '${POST_FILE_PATH}'."

  # Remove to get content of file to stdout
  # POST_FILE_PATH="/dev/stdout"

  # Replace the %date% tag in the draft with the current date and time
  cat "${DRAFT_FILE_PATH}" | sed "s/^#date:$/date: ${TODAYS_DATE_AND_TIME}/g" >> "$POST_FILE_PATH"

  # Commit the post to git
  git add "$POST_FILE_PATH"
  git commit -m "Add post: ${TITLE}"
  
  # Remove draft
  rm ${DRAFT_FILE_PATH}
}

main $@

