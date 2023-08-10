#!/bin/bash

function install_docker() {
    sudo apt install -y gcc g++ git vim curl make cmake gedit unzip cutecom can-utils net-tools
    sudo modprobe overlay
    sudo docker -v 1>/dev/null 2>&1
    if [ $? -eq 0 ]
    then
        docker ps 1>/dev/null 2>&1
        if [ $? -eq 0 ]
        then
            echo "docker is OK!"
            return 1
        else
            sudo gpasswd -a $USER docker
            sudo usermod -aG docker $USER
            sudo systemctl restart docker
            echo "please run the scripts again!"
            return 2
        fi
    else
        curl https://github.com/grant-tt/docker/blob/main/get_docker.sh | sh && sudo systemctl --now enable docker
	if [ $? -ne 0 ]
	then
	    echo "install docker failed!"
	    return -1
	fi
        sudo systemctl restart docker
        sudo gpasswd -a $USER docker
        sudo usermod -aG docker $USER
        sudo systemctl restart docker
        sudo chmod 777 /var/run/docker.sock
        echo "please run the scripts again!"
        return 3
    fi

    return 0
}

install_docker
