# stm32l4-dev-starter

This repository is the starter I will be using to develop code for the STM32L4.  This starter uses Docker to host a slimmed down Linux environment which I will use to cross-compile code for the STM32 devices.

I decided to write this Dockerfile because I hated having to dual-boot my laptop and switch between operating systems just to develop software for ARM.  I had debated using a VM to develop on, but found that to be too cumbersome and too resource heavy for my limited needs.  This solution proved to be the lightest weight and quickest to spin up.

This Dockerfile is far from complete (or even optimized), and I will be editing it as I need more functionality or learn new things about Docker that will improve the performance of this setup.

## Usage

First, you will need Docker Desktop or Docker CLI for whatever platform you are running.

If you are just getting started with Docker (like I am), I provided some scripts to ease installation and spinning up containers.  From within Powershell, run the following:

`.\scripts\build.ps1` to build the Docker image

`.\scripts\start.ps1` to start the Docker image with an integrated terminal.  From this terminal, you can edit, build, or delete any file within the image.  The `docker` user has sudo permissions, so additional packages may be downloaded if needed (they will not persist across container sessions however!).  To despose of the container, run `exit`.  The script defaults the volume (shared folder between your computer and the container) to `.\src\`, but you may change this to match your own folder structure.  Any edits you make within the `.\src\` folder within the container will be done to your own `.\src\` folder!

`.\scripts\start-background.ps1` to start the Docker image in the background.  You will have to run `docker ps -l` to identify the ID of the container and remove it with `docker container rm {ID}`.  This works nicely with the VS Code Insiders Remote-Container development extension, but it's up to you if you want this or not.

For all you UNIX-like freaks, there's some additional bash scripts provided.  You'll have to make them executable yourself with `chmod +x scripts/unix/*`.

## Future Plans

There's a few things I'd like to do to extend the functionality of this starter.

First, this starter is only built with limited HAL support for the STM32L4 family.  This Docker image builds the HAL library from the ECE486 stmdevel.zip.  This library has only a subset of the HAL and also has unnecessary (at least for myself) functions for ECE486 students.  I may attempt to merge this code with additional HAL functions for backwards compatablilty for ECE486 students aiming to use this starter for themselves.  This turns out to be much harder than anticipated.

~~Second, as of this writing, I am unable to flash to an actual STM32 board from within the container.  The host machine may be able to flash the board with the cross compiled binary generated by the container, but I'd like to have all dependencies within the container itself, such that I wouldn't have to install anything to start developing.~~

Flashing support has been added for Windows machines.  The drive letter assigned to my development board was `D:\`.  Your mileage may vary.  If the drive `D:\` is used by something else, DO NOT RUN THE SCRIPT.  Change it first, please.  For my Linux friends out there, you will need to find the correct `/dev/ttyUSB` that corresponds to the development board and replace that with the `D:\` in your script.  I wish there was an easier way to do this, but changing one word in the script is pretty simple and it's hard to get a solution that will work regardless of user.

Thirdly, there is a small issue with the current linker.  I had to change it when I was taking DSP, but I don't remember the change that was necessary.  I will be asking around and introduce this fix as necessary.

Finally, I want this to be a viable solution for ECE486 students developing on the STM32L4 development boards.  It can be difficult to get a whole Linux distro up and running, and if you can use Docker to at least as a stop-gap, that's good enough for me.  This aims to be one of the many ways you can succeed.