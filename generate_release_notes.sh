#!/bin/bash

current_tag="v$(date +"%Y%m%d%H%M%S")"
last_release_tag=$(git describe --tags --abbrev=0 2>/dev/null)

if [ -z "$last_release_tag" ]; then
  echo "No previous releases found. Tagging as $current_tag."
  release_notes="Initial release."
else
  release_notes=$(git log "$last_release_tag"..HEAD --pretty=format:"* %h: %s")
  if [ -z "$release_notes" ]; then
    echo "No new commits since last release."
  fi
fi

git tag "$current_tag"
git push origin "$current_tag"

gh release create "$current_tag" --title "Release $current_tag" --discussion-category "Software Releases" --notes "## Release Notes

$release_notes"

echo "Release $current_tag created with the following notes:"
echo -e "## Release Notes\n\n$release_notes"

