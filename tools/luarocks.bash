#!/bin/bash
set -e

apt update
apt install luarocks -y

# Emit the current versions
echo "Current versions"
cat provision/lualist

mv provision/lualist provision/lualist.bak
touch provision/lualist
while read line; do
    echo "Working with ${line}"
    input=(${line// / })
    echo "Determining version for ${input}"
    luarocks install "${input}"
    version=$(luarocks show ${input} | egrep "${input} ([0-9]{1,}\.)+[0-9]{1,}" | awk -F' ' '{print $2}')
    echo "Found version as ${version}"
    echo "${input} ${version}" >> provision/lualist
done <provision/lualist.bak

#
rm provision/lualist.bak
cat provision/lualist