#!/bin/bash
function create_posts(){
    for event in $1
    do
        echo "Create new post $event.md"
        hexo new post "$1 Writeup" -p "$1"
        echo "--------"
    done
}

function replace(){
    for event in $1
    do
        path="_posts/$event.md"
        echo "Post path is $(pwd)/$path"
        files=`ls -R  CTF/$event/*/*.md | awk -F"/" '{print $3"/"$4}' | uniq`
        echo 'files' $files
        flag=true
        for file in $files
        do
            temp="<!-- md CTF/$event/$file -->"
            echo "insert${temp} into ${path}"
            echo "$temp" >> $path
            if [ "$flag" = "true" ]; then
                echo "<!--more-->" >> $path
                flag=false
            fi
            # replace asset path
            category=`echo $file | awk -F"/" '{print $1}'`
            sed -i 's%\(^\!\[.*\](\)%\1CTF\/'$event'\/'$category'\/%g' $path
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
events=`ls -R  CTF/*/*.md | awk -F"/" '{print $2}' | uniq`
exist_posts=`ls _posts/*.md |cut -c 8- | cut -d "." -f 1`
file1="/tmp/events"
echo -n "$events" > $file1
file2="/tmp/exists"
echo -n  "$exist_posts" > $file2

if [[ $1 == "new" ]];then
    new_events=`sort $file1 $file2 $file2| uniq -u` #  取差集
    create_posts $new_events
elif [[ $1 == "replace" ]];then
    exist_events=`sort $file1 $file2| uniq -d` # 取交集
    replace $events
else
    echo "Unknown command."
    help
fi
