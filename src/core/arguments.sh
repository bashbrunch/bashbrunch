resuming=0
proxying=0
incognito=0
colorfree=0
remote_url=""
remote_pwd=""
remote_max_wait=60

order_check() {
  local args="$1"
  local arg1="$2"
  local arg2="$3"

  local flipped=$(echo "$args" \
    | grep -- "${arg2}.*${arg1}"
  )

  if [ -z "$flipped" ]; then
    return 0
  fi

  println "$arg1 must be specified before $arg2."
  exit 1
}

requisite_check() {
  local args="$1"
  local arg1="$2"

  local check_required=$(echo "$args" \
    | grep -- "${arg1}"
  )

  if [ -z "$check_required" ]; then
    return 0
  fi
  
  shift
  shift
  
  local arg_opts="$@"
  local missing=1

  for arg2 in $arg_opts; do
    local curr=$(echo "$args" \
      | grep -- "${arg1}" \
      | grep -v -- "${arg2}"
    )

    if [ -z "$curr" ]; then
      missing=0
      break
    fi
  done

  if [ $missing -eq 1 ]; then
    println "$arg1 requires $arg2 to be specified"
    exit 1
  fi
}

parse_args() {
  local arg

  order_check "$*" "--provider" "--model"
  order_check "$*" "--provider" "-M"
  order_check "$*" "-P" "--model"
  order_check "$*" "-P" "-M"

  order_check "$*" "--provider" "--key"
  order_check "$*" "--provider" "-K"
  order_check "$*" "-P" "--key"
  order_check "$*" "-P" "-K"

  requisite_check "$*" "--proxy" "--remote" "-R"
  requisite_check "$*" "-X" "--remote" "-R"

  while [ $# -gt 0 ]; do
    arg="$1"
    shift

    case "$arg" in
      update|--update|-u)
        curl -sSL https://bashbrunch.attaditya.space/install | bash
        exit 0
        ;;
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
      --provider|-P)
        if [ -z "$1" ]; then
          println "Please provide a provider name."
          exit 1
        fi
        provider="$1"
        provider_file="$brunch_root/providers/$provider.sh"
        api_key_file="$data_dir/keys/$provider.txt"
        model_select_file="$data_dir/models/$provider.txt"

        api_key=$(cat $api_key_file)
        model=$(cat $model_select_file)
        shift
        ;;
      --model|-M)
        if [ -z "$1" ]; then
          println "Please provide a model name."
          exit 1
        fi

        model="$1"
        shift
        ;;
      --key|-K)
        if [ -z "$1" ]; then
          println "Please provide an API key."
          exit 1
        fi

        api_key="$1"
        shift
        ;;
      --remote|-R)
        if [ -z "$1" ]; then
          println "Please provide a remote URL."
          exit 1
        fi

        remote_url="$1"
        shift
        ;;
      --remote-password|-S)
        if [ -z "$1" ]; then
          println "Please provide a remote password."
          exit 1
        fi

        remote_pwd="$1"
        shift
        ;;
      --remote-max-wait|-W)
        if [ -z "$1" ]; then
          println "Please provide a maximum wait time in seconds."
          exit 1
        fi

        remote_max_wait="$1"
        shift
        ;;
      --proxy|-X)
        proxying=1
        ;;
    esac
  done
}

parse_args "$@"

