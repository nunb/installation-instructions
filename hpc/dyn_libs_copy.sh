#!/bin/bash

OPTIONS_HELP='
Command line options:
     -h Print this help menu
     -v Verbose (lookup_dir_Path destination_dir_path)

Usage: ./dyn_libs_copy.sh lookup_dir_Path destination_dir_path
Usage Example:
./dyn_libs_copy.sh /package/version/os_compiler/bin /package/version/os_compiler/system_libs
./dyn_libs_copy.sh -v /package/version/os_compiler/lib /package/version/os_compiler/system_libs

Verbose mode: ./dyn_libs_copy.sh -v lookup_dir_Path destination_dir_path
'

# Debug function
log(){
if [[ \$debug -eq 1 ]]; then
        echo ``\$@''
    fi
}

## recur_copy function: takes two arguments: filename and Destination path
recur_copy()
{
    log -e ``#####\nFile Name(recur_copy) =>  $1''
    destination_copy_path_dir=''$2''
    log -e ``Destination dir path: $destination_copy_path_dir''
    dep_list=`ldd $1 | perl -p -e 's/[^=]*=> ([^\s]*).*/$1/g' | egrep '^\/.*'`
    dep_arr=($dep_list)

    for dep_file_path in ``${dep_arr[@]}''
    do
        log -e ``\t\tdependency:  $dep_file_path''
        dep_file_name=`basename $dep_file_path`
        log $dep_file_name
        if [ ! -f $dep_file_name ]
        then
            log -e ``\t\t\tFile $dep_file_name does not exists''
            cp $dep_file_path $destination_copy_path_dir
            log -e ``\t\t\tcopied $dep_file_name TO $destination_copy_path_dir''

            recur_copy $dep_file_name $destination_copy_path_dir
        else
            log -e ``\t\t\tFile $FILE DOES exists''
            continue
        fi
    done    
    log -e ``#####\n'' 
}


## list_file_in_dir: takes two arguments lookup directory name and Destination path. Call recur_
copy function
list_file_in_dir()
{
    cd $1
    log ``present working directory `pwd`''
    echo ``lookup dir name $1''
    for file in $1/* ## iterate over all files within directory
    do
        filename=`basename $file`
        log -e ``*****\nFile Name(list_files_in_dir) =>  $file''
        recur_copy $filename $2
        log -e ``*****\n''
    done
}

## Input args processing
echo ``WARNING : This script does not work with relative path. Please specify full path when you 
pass arguments.''

if [[ $# -le 0 ]]; then
        echo ``Invalid arguments''
        echo ``$OPTIONS_HELP''
        break
fi
while test $# -gt 0; do
    case $1 in
       -v)
          debug=1
          #log ``some text''
        ;;
       -h)
            echo ``$OPTIONS_HELP''
            break
        ;;
        *)
        if [ $# -eq 2 ] && [ ! -z $1 ] && [ ! -z $2 ]
            then
                log ``two args found''
                LOOKUP_DIR=''$1''
                DEST_DIR=''$2''
                log ``Lookup_Dir = $LOOKUP_DIR''
                log ``Destination_Dir = $DEST_DIR''
                list_file_in_dir $1 $2
            else
                echo ``Invalid arguments''
                echo -e ``\nUsage: `basename $0` -h for help'';
                echo ``$OPTIONS_HELP''
            fi
            break
        ;;
    esac
    shift 
done


