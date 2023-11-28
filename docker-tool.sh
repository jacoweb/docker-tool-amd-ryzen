#!/bin/bash

#
# Docker helper tool for AMD Hackintosh
#
# Docker Desktop is not working on systems running AMD Proccessors
# because of Intel Hyper Visor Framework.
#
# Workaround:
# https://gist.github.com/slykar/e92732be9bf81a71e08068245656d70e


opt=$1
val=$2

case $opt in
  '')
    echo '-------------------------------------------------'
    echo '|                                                |'
    echo '|       Docker Help tool for AMD systems         |'
    echo '|                                                |'
    if ! docker-machine &>/dev/null;
    then
    echo '-------------------------------------------------'
    echo '| Setup           |                              |'
    echo '-------------------------------------------------'
    echo '| install         | Installing all needed        |'
    echo '|                   dependencies.                |'
    echo '-------------------------------------------------'
    else
    echo '-------------------------------------------------'
    echo '| Docker Machine: |                              |'
    echo '-------------------------------------------------'
    echo '| machine-init    | Creates docker machine       |'
    echo '| machine-start   | Start up docker-machine      |'
    echo '| machine-stop    | Stop docker-machine          |'
    echo '-------------------------------------------------'
    echo '| Docker Compose: |                              |'
    echo '-------------------------------------------------'
    echo '| start           | Start docker-compose         |'
    echo '| stop            | Stop docker-compose          |'
    echo '| list            | See active containers        |'
    echo '| kill            | Stops all active containers  |'
    echo '-------------------------------------------------'
    fi
  ;;

  install)
    if docker-machine &>/dev/null; then
        echo "docker-machine is allready installed."
        docker-machine -v
    else
      echo '-------------------------------------------------'
      echo '| Installing dependencies                        |'
      echo '-------------------------------------------------'
      brew install docker docker-machine ; brew install --cask virtualbox ; 
      curl -L https://github.com/docker/compose/releases/download/1.25.5/docker-compose-`uname -s`-`uname -m` >~/docker-compose ;
      chmod +x ~/docker-compose ; sudo mv ~/docker-compose /usr/local/bin/docker-compose
    fi
  ;;

  machine-init)
    if ! docker-machine &>/dev/null; then
        echo "docker-machine is not installed."
    else
      echo '-------------------------------------------------'
      echo '| Creating default docker machine                |'
      echo '-------------------------------------------------'
      docker-machine create -d virtualbox --virtualbox-no-vtx-check docker
    fi
  ;;

  machine-start)
    if ! docker-machine &>/dev/null; then
        echo "docker-machine is not installed."
    else
      echo '-------------------------------------------------'
      echo '| Starting docker machine                        |'
      echo '-------------------------------------------------'
      docker-machine start docker ; eval $(docker-machine env docker)
    fi
  ;;

  machine-stop)
    if ! docker-machine &>/dev/null; then
        echo "docker-machine is not installed."
    else
      echo '-------------------------------------------------'
      echo '| Stopping docker machine                        |'
      echo '-------------------------------------------------'
      docker-machine stop docker
    fi
  ;;

  start)
    echo '-------------------------------------------------'
    echo '| Starting docker containers                     |'
    echo '-------------------------------------------------'
    docker-compose up -d
  ;;

  stop)
    echo '-------------------------------------------------'
    echo '| Stoping docker containers                      |'
    echo '-------------------------------------------------'
    docker-compose down
  ;;

  list)
    if ! docker &>/dev/null; then
        echo "docker is not installed."
    else
      echo '-------------------------------------------------'
      echo '| List all docker containers                     |'
      echo '-------------------------------------------------'
      docker ps -a
    fi
  ;;

  kill)
    if ! docker &>/dev/null; then
        echo "docker is not installed."
    else
      echo '-------------------------------------------------'
      echo '| Killing all docker containers                  |'
      echo '-------------------------------------------------'
      docker container kill $(docker ps -q)
    fi
  ;;

  *)
esac
