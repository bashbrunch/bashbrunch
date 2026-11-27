version=$(cat $version_file)
latest_version=$(curl \
  -s https://bashbrunch.attaditya.space/bashbrunch/version.txt
)

if [ "$version" != "$latest_version" ]; then
  println "A new version of BashBrunch is available: $latest_version"
  println "To update, use: brunch --update"
  println ""
fi

