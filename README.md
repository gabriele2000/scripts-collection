# VIDEO SCRIPTS
When moving media files from Google Photo to another cloud, I had to create a way to automate the convertion of **a lot** of images (we're talking about 10k+ images) while retaining one of the most important aspect of the file: the creation date.

I created those scripts to aid myself in this task, recently I made them more interactive.
They're useful for both videos and images.

The only dependency is `avifenc`
--------------------------------------------
# BeamMP-Launcher builder
When helping a friend I realized that the building instructions for BeamMP-Launcher were, let's say, not up to my standards.
I created a script that creates a Dockerfile, builds the container (which will build the launcher, using an Ubuntu 22.04 image) and will copy the compiled launcher in the current working directory.

UPDATE: Since 24 October 2025, the script will also update the cloned repositories, so that it can also be used for updating BeamMP-Launcher.
It compiled the main branch, so that you can receive the really latest fixes.

It's that easy
