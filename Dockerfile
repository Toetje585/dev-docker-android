FROM ubuntu:20.04

## build 
## docker build --build-arg userid=$(id -u) --build-arg groupid=$(id -g) --build-arg username=$(id -un) -t android-dev .

ARG userid
ARG groupid
ARG username

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y android-tools-adb \
   bc \
   android-tools-fastboot \
   bison \
   build-essential \
   ccache \
   curl \
   flex \
   g++-multilib \
   gcc-multilib \
   git-core \
   gnupg \
   gperf \
   imagemagick \
   lib32ncurses5-dev \
   lib32readline-dev \
   lib32z1-dev \
   lib32z-dev \
   libc6-dev-i386 \
   libgl1-mesa-dev \
   liblz4-tool \
   libncurses5 \
   libncurses5-dev \
   libpulse0 \
   libsdl1.2-dev \
   libssl-dev \
   libx11-dev \
   libxml2 \
   libxml2-utils \
   lzop \
   pngcrush \
   python3 \
   python3-pip \
   rsync \
   schedtool \
   squashfs-tools \
   unzip \
   x11proto-core-dev \
   xsltproc \
   zip \
   zlib1g-dev \
   brotli \
   simg2img \
   patchelf \
   sudo \
   vim \
   nano \
 && apt-get purge --auto-remove -yqq \
 && apt-get autoremove -yqq --purge \
 && apt-get clean \
 && rm -rf \
     /var/lib/apt/lists/* \
     /tmp/* \
     /var/tmp/* \
     /usr/share/man \
     /usr/share/doc \
     /usr/share/doc-base

RUN curl -o jdk9.tgz \
 https://android.googlesource.com/platform/prebuilts/jdk/jdk9/+archive/master.tar.gz \
 && mkdir -p /usr/lib/jvm/java-9-openjdk-amd64 \
 && tar -zxf jdk9.tgz linux-x86 \
 && mv linux-x86 /usr/lib/jvm/java-9-openjdk-amd64 \
 && rm -rf jdk9.tgz

RUN curl -o /usr/local/bin/repo https://storage.googleapis.com/git-repo-downloads/repo \
 && chmod a+x /usr/local/bin/repo \
 && ln -s /usr/bin/pip3 /usr/bin/pip

COPY sdat2img.py /usr/local/bin/sdat2img.py
RUN chmod 755 /usr/local/bin/sdat2img.py

COPY build-metadata/lineage-build-targets.txt /lineage-build-targets.txt
RUN chmod 775 /lineage-build-targets.txt

RUN groupadd -g $groupid $username \
 && useradd -m -u $userid -g $groupid $username \
 && echo $username" ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers \
 && echo $username >/root/username \
 && usermod -aG sudo $username

RUN ln -s /usr/bin/python3 /usr/bin/python

COPY gitconfig /etc/gitconfig

ENV HOME=/home/$username
ENV USER=$username
ENV JAVA_HOME="/usr/lib/jvm/java-9-openjdk-amd64/linux-x86"
ENV PATH="$JAVA_HOME/bin":$PATH
ENV ANDROID_JACK_VM_ARGS="-Dfile.encoding=UTF-8 -XX:+TieredCompilation -Xmx8G"
ENV USE_CCACHE=1
ENV CCACHE_EXEC=/usr/bin/ccache
ENV CCACHE_DIR=/ccache
ENTRYPOINT chroot --userspec=$(cat /root/username):$(cat /root/username) / /bin/bash -i
