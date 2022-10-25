# cclib-ci

cclib CI Docker images

Building the images:

1. `cd path to py3*`
2. `sudo docker buildx build -t shivupa/cclib-ci:py37 . | tee buildlog.txt`
3. `sudo docker image ls` (get the build hash of the latest image
4. `sudo docker tag BUILDHASH shivupa/cclib-ci:py37`
5. `sudo docker push shivupa/cclib-ci:py37`

You may need to install https://github.com/docker/buildx first.
