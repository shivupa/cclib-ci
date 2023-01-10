# cclib-ci

cclib CI Docker images

Building the images:

1. `cd path to py3*`
2. `sudo docker buildx build -t shivupa/cclib-ci:py37 . | tee buildlog.txt`
3. `sudo docker image ls` (get the build hash of the latest image
4. `sudo docker tag BUILDHASH shivupa/cclib-ci:py37`
5. `sudo docker push shivupa/cclib-ci:py37`

You may need to install https://github.com/docker/buildx first.

## Running with https://github.com/nektos/act

Your `.secrets` file (in `.env` format, just like setting a local variable in a `sh` shell script) must contain `GITHUB_TOKEN` for the Docker metadata action to work.  It is a [personal access token](https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token) that only needs repository read permissions to work.  If using a "fine-grained" token, no additional permissions beyond the defaults are necessary.
