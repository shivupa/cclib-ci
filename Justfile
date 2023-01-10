dir := invocation_directory()
tag := file_name(dir)

# These commands are meant to be executed from within each directory
# containing a Dockerfile.
#
# If your user is not a part of the `docker` group and needs elevated
# permissions to execute Docker commands, `sudo just ...` is sufficient.

build:
    docker buildx build -t shivupa/cclib-ci:{{ tag }} {{ dir }}

shell:
    docker run -it shivupa/cclib-ci:{{ tag }} bash

act:
    act -W ./.github/workflows/{{ tag }}.yaml -P ubuntu-latest=catthehacker/ubuntu:act-latest
