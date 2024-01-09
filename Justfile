dir := invocation_directory()
tag := file_name(dir)

# These commands are meant to be executed from within each directory
# containing a Dockerfile.
#
# If your user is not a part of the `docker` group and needs elevated
# permissions to execute Docker commands, `sudo just ...` is sufficient.

build-docker:
    docker buildx build --target test -t shivupa/cclib-ci:{{ tag }}-test {{ dir }}
    docker buildx build --target ci -t shivupa/cclib-ci:{{ tag }} {{ dir }}
    docker untag shivupa/cclib-ci:{{ tag }}-test

build-podman:
    podman build --format docker --target test -t shivupa/cclib-ci:{{ tag }}-test {{ dir }}
    podman build --format docker --target ci -t shivupa/cclib-ci:{{ tag }} {{ dir }}
    podman untag shivupa/cclib-ci:{{ tag }}-test

shell-docker:
    docker run -it shivupa/cclib-ci:{{ tag }} bash

shell-podman:
    podman run -it shivupa/cclib-ci:{{ tag }} bash

act:
    act -W ./.github/workflows/build_and_push.yaml -P ubuntu-latest=catthehacker/ubuntu:act-latest
