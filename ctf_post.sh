#!/bin/bash
function create_posts(){
    flag=true
    for event in $1
    do
        echo "Create new post $event.md"
        hexo new post "$1 Writeup" -p "$1"
        files=`ls -R  CTF/$event/*/*.md | awk -F"/" '{print $3"/"$4}' | uniq`
        path="$(pwd)/_posts/$event.md"
        echo "Post path is $path"
        for file in $files
        do
            temp="<!-- md CTF/$event/$file -->"
            echo "insert" $temp
            echo "$temp" >> $path
            if [ "$flag" = "true" ]; then
                echo "<!--more-->" >> $path
                flag=false
            fi
        done
        echo "--------"
    done
}



function replace(){
    paths=`ls -R  CTF/*/*/*.md | awk -F"/" '{print "CTF" "/"$2"/"$3}' | uniq`
    for path in $paths
    do
        for file in `ls $path/*.md`
        do
            echo $file
            sed -i 's%\(^\!\[.*\](\)%\1'$path'\/%g' $file
        done
    done
}

function help(){
    echo "usage:  bash $0 new \"create new post\""
    echo -e "\tbash $0 repalce \"replace post asset path\""
}

if [ $# != 1 ];then
    echo "You can only specify one command."
    help
    exit 2
fi

cd source
if [[ $1 == "new" ]];then
    file1="/tmp/events"
    events=`ls -R  CTF/*/*.md | awk -F"/" '{print $2}' | uniq`
    echo -n "$events" > $file1
    file2="/tmp/exists"
    exists=`ls _posts/*.md |cut -c 8- | cut -d "." -f 1`
    echo -n  "$exists" > $file2

    new_events=`sort $file1 $file2 $file2| uniq -u`
    create_posts $new_events
elif [[ $1 == "replace" ]];then
    replace
else
    echo "Unknown command."
    help
fi
