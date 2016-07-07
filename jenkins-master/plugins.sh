#! /bin/bash

# Parse a support-core plugin -style txt file as specification for jenkins plugins to be installed
# in the reference directory, so user can define a derived Docker image with just :
#
# FROM jenkins
# COPY plugins.txt /plugins.txt
# RUN /usr/local/bin/plugins.sh /plugins.txt
#

set -e

REF=/usr/share/jenkins/ref/plugins
mkdir -p $REF

while read spec || [ -n "$spec" ]; do
    plugin=("${spec%%:*}" "${spec#*:}");
    [[ ${plugin[0]} =~ ^# ]] && continue
    [[ ${plugin[0]} =~ ^\s*$ ]] && continue
    [[ -z ${plugin[1]} ]] && plugin[1]="latest"

    echo "Downloading ${plugin[0]}:${plugin[1]}"
    
    if [[ ${plugin[1]} =~ ^https?:// ]]
    then
        URI="${plugin[1]}"
    else
        if [ -z "$JENKINS_UC_DOWNLOAD" ]; then
          JENKINS_UC_DOWNLOAD=$JENKINS_UC/download
        fi
        URI="${JENKINS_UC_DOWNLOAD}/plugins/${plugin[0]}/${plugin[1]}/${plugin[0]}.hpi"
    fi

    #echo "Checking cache for : ${plugin[0]}:${plugin[1]}"
    #if [ -f $REF/${plugin[0]}/${plugin[1]}/${plugin[0]}.jpi ];then
    #    echo "Using cache for plugin : $REF/${plugin[0]}/${plugin[1]}/${plugin[0]}.jpi"
    #    unzip -qqo $REF/${plugin[0]}/${plugin[1]}/${plugin[0]}.jpi
    #else
    #    mkdir -p $REF/${plugin[0]}/${plugin[1]}
    #    echo "Downloading ${plugin[0]}:${plugin[1]}"
        curl -sSL -f "${URI}" -o $REF/${plugin[0]}.jpi
        unzip -qqo $REF/${plugin[0]}.jpi
    #fi
done  < $1
