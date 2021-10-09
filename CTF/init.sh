#!/bin/bash
function process(){
    i=0
    str=""
    arry=("\\" "|" "/" "-")
    while [ $i -le 100 ]
    do
        let index=i%4
        if [ $i -le 20 ]; then
            let color=44
            let bg=34
        elif [ $i -le 45 ]; then
            let color=43
            let bg=33
        elif [ $i -le 75 ]; then
            let color=41
            let bg=31
        else
            let color=42
            let bg=32
        fi
        printf "\033[${color};${bg}m%-s\033[0m %d %c\r" "$str" "$i" "${arry[$index]}"
        sleep 0.02
        let i=i+1
        str+="#"
        echo ""
    done
}

if [ $# != 1 ];then
    echo "You must specify one contest name."
    exit 2
fi

function main() {
    name=$1
    mkdir $name
    cd $name
    echo -e "# $name Writeup\n
## Misc\n
## Crypto\n
## Web\n
## Reverse\n" >> README.md
    mkdir Misc Crypto Web Reverse
}

main $1 &
process