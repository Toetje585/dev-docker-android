# Docker to Support Building Android from Source

Docker Bundle with Android Tools for Compiling/Building Android

This project contains artifacts for building a docker image that supports build tools required for compiling android from source.

It is basically a revision of the [Dockerfile]([tools/docker/Dockerfile - platform/build - Git at Google](https://android.googlesource.com/platform/build/+/master/tools/docker/Dockerfile)) that is referenced at [Android's Official Build Requirements](https://source.android.com/setup/build/requirements#software-requirements).

# Installation Instructions

Clone the repo to your local host.

## Clone Repo

```
git clone https://github.com/tonys-code-base/dev-docker-android.git
```

## Update Local gitconfig File

The cloned repo contains a `gitconfig` file.  Update this file to include (your Google account profile details):

```
[user]
    name = Your Name
    email = me@example.com
```

## Build Docker Image

To build the image with a `tag` of `android-dev`:

```
sudo docker build -t android-dev .
```

# Usage

Generally speaking, you'd be using this image to develop and build Android code sourced from git repos.  

Ideally, you would want to establish docker `host:container` mounts to store your Android source and build output. This is to also ensure that you do not lose any of your Android code/build artifacts when pruning your docker images/containers.

## Create Host Dev Directory

Create a directory on your host OS. At a high level, and for the purposes of an example, if I was going to start work on an Android Nougat AOSP build, I would create a directory on the host and call it `nougat`:

```
mkdir <parent path>/nougat
```

##  Run the Docker Image with Mounts

Assuming you've created your *host path* as `<parent path>/nougat` , run the image as follows to map this host folder to docker the container's internal location being `/root/nougat`:

```
sudo docker run -it --rm -v <parent path>/nougat/:/root/nougat/ android-dev
```

You can now use the docker container and specify `/root/nougat` as the `TOP LEVEL` directory for your Android  components.



 



