resuming=0
incognito=0
colorfree=0

parse_args() {
  local arg

  while [ $# -gt 0 ]; do
    arg="$1"
    shift

    case "$arg" in
      --version|-v)
        println "BashBrunch ${version}"
        exit 0
        ;;
      --help|-h)
        cat "$help_file"
        exit 0
        ;;
      --session|-s|--resume|-r)
        if [ -z "$1" ]; then
          println "Please provide a session ID."
          exit 1
        fi
        session_id="$1"
        resuming=1
        shift
        ;;
      --incognito|-i)
        incognito=1
        session_id="INCOGNITO"
        ;;
      --plain|-p)
        colorfree=1
        ;;
    esac
  done
}

parse_args "$@"

