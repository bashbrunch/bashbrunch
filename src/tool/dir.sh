change_dir() {
  cd "$1"
  add_chat "system" "Changed directory to $(pwd)"
  println "Changed directory to $(pwd)"
}

