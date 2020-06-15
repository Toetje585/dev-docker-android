FROM ubuntu:19.10

RUN apt-get update && apt-get install -y git-core \
 && gnupg flex bison gperf build-essential zip curl \
 && zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 \
 && lib32ncurses5-dev x11proto-core-dev libx11-dev \
 && lib32z-dev ccache libgl1-mesa-dev libxml2-utils \
 && xsltproc unzip python libncurses5 rsync libpulse0

RUN curl -o jdk8.tgz \
 https://android.googlesource.com/platform/prebuilts/jdk/jdk8/+archive/master.tar.gz \
 && mkdir -p /usr/lib/jvm/java-8-openjdk-amd64 \
 && tar -zxf jdk8.tgz linux-x86 \
 && mv linux-x86 /usr/lib/jvm/java-8-openjdk-amd64 \
 && rm -rf jdk8.tgz

RUN curl -o /usr/local/bin/repo https://storage.googleapis.com/git-repo-downloads/repo \
 && chmod a+x /usr/local/bin/repo

COPY gitconfig /root/.gitconfig

RUN chown root:root /root/.gitconfig

ENV HOME=/root
ENV USER=root

ENTRYPOINT /bin/bash -i
