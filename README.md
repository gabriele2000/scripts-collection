## Repository migrated to gitea - https://gitea.com/gabriele2000/scripts-collection

# IMAGE/VIDEO SCRIPTS

When moving media files from Google Photo to another cloud, I had to create a way to automate the convertion of **a lot** of images (we're talking about 10k+ images) while retaining one of the most important aspect of the file: the creation date.

I created those scripts to aid myself in this task, recently I made them more interactive.

- `creationdate-image.sh`
<br>This script can be used for retaining the creation date field for images

- `creationdate-video.sh`
<br>This script can be used for retaining the creation date field for videos

- `image-avif.sh`
<br>This script can be used to convert the images to AVIF.
<br>Personally I had to convert images from `PNG`, `JPEG` and `JPG`... it's case-sensitive for now so when it asks for the format, the format shall be inserted precisely.

Dependencies required:
- `avifenc`

--------------------------------------------

- `deduplicate-frames.sh`
<br>When preparing a file for interpolation, I must prepare them by eliminating excess frames or, should the framerate value be really off that its real value, changing the framerate then eliminating the excess frames.
<br>This second step is called **deduplication**, which is the process that will eliminate the duplicated frames, so that the interpolation will run smoothly without wasting CPU/GPU power AND, most importantly, the result will be perfect, without stuttering due to duplicated still frames (which would negate the interpolation).

This script is more complex to use: it has two modes, it'll ask for a the destination file's codec (I personally use `ffv1` since it's lossless (this makes it perfect for multiple manipulation steps of a video file)) and it'll ask for a format.

I think I'll soon make it so it defaults to `mkv` since it supports everything, so that a (mostly) useless step can be eliminated.

--------------------------------------------

# MISC SCRIPTS
**beammp-autoinstall.sh**

When helping a friend with a technical issue for BeamMP on linux I realized that the building instructions for BeamMP-Launcher on Linux were, let's say, not up to my standards.
<br>I created a script that creates a Dockerfile, builds the container (which will build the launcher, using an Ubuntu 22.04 image) and will copy the compiled launcher in the current working directory.

UPDATE: Since 24 October 2025, the script will also update the cloned repositories, so that it can also be used for updating BeamMP-Launcher.
<br>It compiles the main branch, so that you can receive the really latest fixes.

It's that easy
