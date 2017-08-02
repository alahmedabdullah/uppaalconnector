#!/bin/sh
# version 2.0


WORK_DIR=`pwd`

yum -y update
yum install -y unzip

# Install Java
ext="tar.gz"
jdk_version=8

# how to get the latest oracle java version ref: https://gist.github.com/n0ts/40dd9bd45578556f93e7
cd /opt/
readonly url="http://www.oracle.com"
readonly jdk_download_url1="$url/technetwork/java/javase/downloads/index.html"
readonly jdk_download_url2=$(curl -s $jdk_download_url1 | egrep -o "\/technetwork\/java/\javase\/downloads\/jdk${jdk_version}-downloads-.+?\.html" | head -1 | cut -d '"' -f 1)
[[ -z "$jdk_download_url2" ]] && error "Could not get jdk download url - $jdk_download_url1"

readonly jdk_download_url3="${url}${jdk_download_url2}"
readonly jdk_download_url4=$(curl -s $jdk_download_url3 | egrep -o "http\:\/\/download.oracle\.com\/otn-pub\/java\/jdk\/[7-8]u[0-9]+\-(.*)+\/jdk-[7-8]u[0-9]+(.*)linux-x64.$ext")

for dl_url in ${jdk_download_url4[@]}; do
    wget --no-cookies \
         --no-check-certificate \
         --header "Cookie: oraclelicense=accept-securebackup-cookie" \
         -N $dl_url
done
JAVA_TARBALL=$(basename $dl_url)
tar xzfv $JAVA_TARBALL

UPPAAL_PACKAGE_NAME=$(sed 's/UPPAAL_PACKAGE_NAME=//' $WORK_DIR/package_metadata.txt)  
mv $WORK_DIR/$UPPAAL_PACKAGE_NAME /opt
cd /opt
unzip $UPPAAL_PACKAGE_NAME

cd $WORK_DIR
