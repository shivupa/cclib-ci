# cclib-ci
cclib ci docker images

Building the images:
 1. `cd path to py3*`
 2. `sudo docker build -t shivupa/cclib-ci . | tee buildlog.txt`
 3. `sudo docker image ls` (get the build hash of the latest image
 4. `sudo docker tag BUILDHASH shivupa/cclib-ci:py37`
 5. `sudo docker push shivupa/cclib-ci:py37`
