#!/bin/bash

# Open Screenshot.app
open /System/Applications/Utilities/Screenshot.app

# Wait for the screenshot to be taken (adjust sleep duration if needed)
sleep 5

# Check for the latest screenshot on the Desktop (assumes screenshots are saved with 'Screen Shot' in the name)
screenshot=$(ls -t ~/Desktop/Screenshot*.png | head -1)

# If no screenshot is found, exit
if [ -z "$screenshot" ]; then
  osascript -e 'display notification "No screenshot found." with title "Upload Failed"'
  exit 1
fi

# Upload the screenshot to 0x0.st
upload_link=$(curl -sF "file=@$screenshot" https://0x0.st)

# Check if the upload was successful
if [[ $upload_link == http* ]]; then
  # Send a desktop notification with the upload link
  osascript -e "display notification \"Uploaded!\" with title \"Screenshot Uploaded\" subtitle \"Link copied to clipboard\""

  # Copy the link to the clipboard
  echo "$upload_link" | pbcopy

  # Remove the screenshot from the desktop
  rm "$screenshot"
else
  # Notify of the upload failure
  osascript -e 'display notification "Upload failed." with title "Upload Error"'
fi

