#!/bin/bash
function create_posts(){
    for event in $@
    do
        echo "Create new post $event.md"
        hexo new post "$event Writeup" -p "$event"
        echo "--------"
    done
    hexo g # generate abbrlink
}

function replace(){
    echo $@
    for event in $@
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
            sed -i 's%\(^\!\[.*\](\)%\1..\/..\/CTF\/'$event'\/'$category'\/%g' "CTF/$event/$file"
            sed -i 's%\(^<img src="\)assets%\1..\/..\/CTF\/'$event'\/'$category'\/assets%g' "CTF/$event/$file"
            sed -i 's%\(^<img src="\)images%\1..\/..\/CTF\/'$event'\/'$category'\/images%g' "CTF/$event/$file"
            cat "CTF/$event/$file" | grep 'assets \| images' | cat
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
cd ..

if [[ $1 == "new" ]];then
    new_events=`sort $file1 $file2 $file2| uniq -u` #  取差集
    create_posts $new_events
elif [[ $1 == "replace" ]];then
    cd source
    exist_events=`sort $file1 $file2| uniq -d` # 取交集
    replace $exist_events
else
    echo "Unknown command."
    help
fi
