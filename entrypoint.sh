#!/bin/sh

function usage() {
  echo "usage : [cmd] -t GIT_TOKEN -u ORG/USER_NAME [-m mode] [-h]"
  echo ' -t: scm token to clone with'
  echo ' -u: user name'
  echo ' -o: organization name'
  echo ' -s: type of scm used, github, gitlab or bitbucket (default: github)'
  echo ' -b: branch left checked out for each repo cloned (default: default branch)'
  echo ' -h: host url, for on self hosted git repository (default: uses github/gitlab public api)'
  echo ' -f: Include repos are forks (default: skip fork repository)'
  echo ' -a: Include repos are archived (default: skip archived repository)'
}

function checkuser() {
      if [[ ! -z ${USER} ]];then
        echo "Only set username or organization name"
        exit 1
      fi
}

TOKEN=
USER=
MODE=
HOST=
BRANCH=
SERVICE=
SKIP_FORK="--skip-forks"
SKIP_ARCHIVED="--skip-archived"
while getopts "t:u:o:s:b:h:fa" opt; do
  case ${opt} in
    t)
      TOKEN=${OPTARG}
      ;;
    u)
      checkuser
      USER=${OPTARG}
      MODE=user
      ;;
    o)
      checkuser
      USER=${OPTARG}
      MODE=org
      ;;
    s)
      SERVICE="-s ${OPTARG}"
      ;;
    b)
      BRANCH="-b ${OPTARG}"
      ;;
    h)
      HOST="--base-url ${OPTARG}"
      ;;
    f)
      SKIP_FORK=""
      ;;
    a)
      SKIP_ARCHIVED=""
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      usage
      exit 1
      ;;
  esac
done

if [ -z "${TOKEN}" ]; then
  echo "require -t TOKEN"
  exit 1
fi

if [ -z "${USER}" ]; then
  echo "require -u or -o"
  exit 1
fi

ghorg clone "${USER}" -t "${TOKEN}" -c "${MODE}" $SERVICE $BRANCH $HOST $SKIP_FORK $SKIP_ARCHIVED -p /root/git --output-dir mnt

for f in `\find /root/git/ -type d -name ".git"`; do
  echo "Start scanning ${f%/.git}"
  shhgit -silent -local ${f%/.git}
done
