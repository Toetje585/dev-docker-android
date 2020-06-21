# Docker for Building Android from Source

This repo contains Docker Bundle with Tools for Compiling/Building Android

The final image aims to simplify the Android build process by bundling necessary tools into an Ubuntu-based image .  It was originally built for compiling AOSP 10 for use as an AVD.  It was later expanded to facilitate building Lineage OS 15.1 for a ***ZTE Axon 7 (A2017G) smartphone device***.

Notes regarding the the final image:

* Derived from Ubuntu's official base image (`docker pull ubuntu:19.10`).
* Packs in Python script [sdat2img](https://github.com/xpirt/sdat2img) 'as is', which is used to convert from Android data images to ext4
* Leverages off the [Dockerfile](https://android.googlesource.com/platform/build/+/master/tools/docker/Dockerfile), as reference at [Android's Official Build Requirements](https://source.android.com/setup/build/requirements#software-requirements).
* Can be used to pull and compile Android source from code, all from within a docker container.
* The image has been tested for building Android `Lineage OS 15.1 ` for an Android ZTE Axon 7 smartphone.
* The image has also been used to create an SDK build of Android 10 AOSP API 29, which can be used as an Android Virtual Device (AVD) using the official Android Studio SDK Emulator.
* Has been tested from a Linux host machine running Ubuntu 19.10

# Installation Instructions

* Clone the repo to your local host as follows:

```
git clone https://github.com/tonys-code-base/dev-docker-android.git
```

* Update the cloned repo's `gitconfig` file to git profile:

```
[user]
    name = Your Name
    email = me@example.com
```

* To build the image with a `tag` of `android-dev`:

```
docker build --build-arg userid=$(id -u) \
--build-arg groupid=$(id -g) \
--build-arg username=$(id -un) -t android-dev .
```

The build arguments for the image are the effective values take from current user's host session (as described by `man`),  i.e. 

    Effective user ID (Numeric)
    id -u 
    
    Effective group ID (Numeric)
    id -g
    
    Effective Username (Alphanumeric)
    id --un

# Android Build Environment Preparation

Ideally, an Android root project path (`<HOST_Parent_path>`) should be established on the **host**.  This location should be mapped/mounted to the project root folder within the **container** .  The mount is to ensure that work carried out from within the container is always persisted and is not lost as a result of pruning your docker images/containers, or exiting the container's interactive shell.

## Create Host Work Directory

Create a directory on your **host** (`<HOST_Parent_path>`) where you plan to store your Android project components  .  As an example, if I was going to start work on an a *Lineage OS 15* build, I'd create the host project directory for the build as *$HOME/lineage15*, i.e:

```
mkdir $HOME/lineage15
```

## Run Docker Image with host:container Mount

Continuing from the example above, with **host** project path as `$HOME/lineage15` , the following command with `-v`, option would setup the host path to be mounted within the **container** at target `/lineage15`:

```
sudo docker run -it --rm --privileged \
--cap-add=ALL \
-v $HOME/lineage15:/lineage15 android-dev
```

You can now start using the environment from within the **container**, by changing directory to the project folder:

```
cd /lineage15
```

## Kick-off

After you've issued the `cd /lineage15` from within your container, you can kick-off development by the usual commands as  as `repo init`, `repo init -u` to retrieve the Android repo you wish to work with.

# Why use docker --privileged --cap-add=ALL?

In the `docker run` command above, the run option of `--privileged` was specified for the purposes of allowing the container  access to **host** devices.  

Many may consider this as an "obtrusive" approach from a security perspective.  It was mainly used to allow the container access **host** devices `/dev/loop` and the physical smartphone via `adb`.

You can fine-tune the access by exposing only a subset of host devices to the container by specifying the `--device` option.

In regards to the use of `--cap-add=ALL`, this was due to the build process generating kernel module errors when building Lineage from within a container.  The explicit capabilities required for inclusion with `--cap-add` is something that needs more investigation and the same applies in terms of identifying a subset of capabilities required, rather than a blanket "ALL".  

It goes without saying that this setup is not intended to be used in a Production environment.  
