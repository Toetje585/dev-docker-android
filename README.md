# Docker to Support Building Android from Source

Docker Bundle with Android Tools for Compiling/Building Android

This project contains artifacts for building a docker image that supports build tools required for compiling android from source.

It is basically a revision of the [Dockerfile](https://android.googlesource.com/platform/build/+/master/tools/docker/Dockerfile) that is referenced at [Android's Official Build Requirements](https://source.android.com/setup/build/requirements#software-requirements).

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

Ideally, you would want to establish docker `host:container` mounts to store your Android source and build output components. The mount is to also ensure that you do not lose any of your Android code/build artifacts, in cases such as pruning your docker images/containers.

## Create Host Dev Directory

Create a directory on your **host** OS where you plan on to store your Android project components (<HOST Parent path>).  At a high level, and for the purposes of an example, if I was going to start work on an a *LineageOS 15* build, I would create a directory on the host specific to my *Lineage15*:

```
mkdir <HOST Parent path>/Lineage15
```

## Run the Docker Image with Mounts

Continuing from the example above, if I've created my **host** project directory as `<HOST Parent path>/Lineage15` , and want to work/access this path from within the **container** at `/root/Lineage15` then I would run the following:

```
sudo docker run -it --rm -v <HOST Parent path>/Lineage15:\ 
/root/Lineage15 android-dev
```

Your build components are now accessible from the host at : `<HOST Parent path>/Lineage15` and from within the container at : `/root/Lineage15`.
