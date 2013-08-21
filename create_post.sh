#!/bin/bash
set -e

EXTENSION=markdown

function main() {
  TITLE="$@"
  # Check that we have a an argument
  if ! [ "${TITLE}" ]
  then
    echo "Usage: `basename $0` { <title for new post> | <existing draft to publish> }"
    exit 1
  fi

  # If the file exists, consider it a draft and publish it; otherwise, create a new draft with that name
  if ! [ -f "${TITLE}" ]; then
    create_new_draft
  else
    publish_draft
  fi
}

function create_new_draft() {
  echo "Creating new draft with title: '${TITLE}'."

  # Create the file name -- lowercase and replace spaces with -
  FILE_NAME=`echo "${TITLE}" | tr "[A-Z]" "[a-z]" | tr " " "-"`

  # Add extension
  FILE_NAME=${FILE_NAME}.${EXTENSION}

  echo "Saving draft with filename: '${FILE_NAME}'."

  # Remove to get content of file to stdout
  # FILE_PATH="/dev/stdout"

  FILE_PATH="_drafts/${FILE_NAME}"

  # Create the front matter
  echo "---" >> ${FILE_PATH}
  echo "layout: post" >> ${FILE_PATH}
  echo "title: \"$TITLE\"" >> ${FILE_PATH}
  echo "#date:" >> ${FILE_PATH}
  echo "categories: [  ]" >> ${FILE_PATH}
  echo "---" >> ${FILE_PATH}
  echo "" >> ${FILE_PATH}

  # Open the file in the standard editor for this extension
  open "${FILE_PATH}"
}

function publish_draft() {
  DRAFT=${TITLE}
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
  
  # Remove draft
  rm ${DRAFT_FILE_PATH}
}

main $@

