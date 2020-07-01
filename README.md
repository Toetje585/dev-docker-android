# Docker for Building Android from Source

This repo contains Docker Bundle with Tools for Compiling/Building Android

The final image aims to simplify the Android build process by bundling necessary tools into an image.  If there are other repos that already provide this capability, then I don't really care :).  This was my own exploration piece, my side gig into finding out more on Android and Docker. 

It was originally built for compiling AOSP 10 for use as an AVD.  It was later expanded to facilitate building Lineage OS 15.1 for a ***ZTE Axon 7 (A2017G) smartphone device***.  If you do plan on using it, you may need a tweak (or two) for your specific setup.

Notes regarding the the final image:

* Derived from Ubuntu official base image `-->` `docker pull ubuntu:19.10`.
* Packs in Python script [sdat2img](https://github.com/xpirt/sdat2img) 'as is', which is used to convert from Android data images to ext4 format.
* Leverages from the [Dockerfile](https://android.googlesource.com/platform/build/+/master/tools/docker/Dockerfile), as reference at [Android's Official Build Requirements](https://source.android.com/setup/build/requirements#software-requirements).
* The image has been tested for building Android `Lineage OS 15.1 ` for an Android ZTE Axon 7 smartphone.  You can modify the Dockerfile and add/remove project-specific components as required.
* Tested for build of an Android 10 AOSP (API 29) AVD.
* The Linux host OS used for testing was Ubuntu 19.10.

# Installation Instructions

* Clone the repo to your local host as follows:

```
git clone https://github.com/tonys-code-base/dev-docker-android.git
```

* Update the cloned repo's `gitconfig` file to reflect the git identity to use.  *Note: This is treated as a "Container/Image Wide" git identify, i.e. it ends up in /etc/gitconfig*

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

## Create Host Working Directory

Create a directory on your **host** (`<HOST_Parent_path>`) where you plan to store your Android project components.  As an example, if I was going to start work on an a Lineage OS15.1 build, I'd create the host project directory for the build as *$HOME/lineage15*, i.e:

```
mkdir $HOME/lineage15
```

## Run Docker Image with host:container Mount

Continuing from the example above, with **host** project path as `$HOME/lineage15`, the following command using the `-v` option, would setup host path to be mounted within the **container** at target `/lineage15`:

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

In the `docker run` command, the run option of `--privileged` was specified for the purposes of allowing the container to access to **host** devices.  

This might be considered as an "obtrusive" approach from a security perspective.  It was mainly used to allow the container access **host** devices, `/dev/loop*` and  access to phone from the container via USB/ADB.

You can fine-tune the access by exposing only a subset of host devices to the container by specifying the `--device` option.

In regards to the use of `--cap-add=ALL`, this was added to eliminate kernel module errors encountered during the build of Lineage from within a container.  The explicit capabilities required for inclusion with `--cap-add` is something that needs more attention in terms of identifying a subset of capabilities required, rather than a blanket "ALL".

This setup is not intended to be used in a Production environment without further fine-tuning.
