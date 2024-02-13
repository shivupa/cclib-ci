root := justfile_directory()
dockerfile := root / "Dockerfile"
dir := invocation_directory()
tag := file_name(dir)
image_base := "shivupa/cclib-ci"

# These commands are meant to be executed from within each directory
# that corresponds to a Python version.
#
# If your user is not a part of the `docker` group and needs elevated
# permissions to execute Docker commands, `sudo just ...` is sufficient.

build-docker:
    docker buildx build --target test -t {{ image_base }}:{{ tag }}-test -f {{ dockerfile }} {{ dir }}
    docker buildx build --target ci -t {{ image_base }}:{{ tag }} -f {{ dockerfile }} {{ dir }}
    docker untag {{ image_base }}:{{ tag }}-test

build-podman:
    podman build --format docker --target test -t {{ image_base }}:{{ tag }}-test -f {{ dockerfile }} {{ dir }}
    podman build --format docker --target ci -t {{ image_base }}:{{ tag }} -f {{ dockerfile }} {{ dir }}
    podman untag {{ image_base }}:{{ tag }}-test

shell-docker:
    docker run -it {{ image_base }}:{{ tag }} bash

shell-podman:
    podman run -it {{ image_base }}:{{ tag }} bash

act:
    act -W ./.github/workflows/build_and_push.yaml -P ubuntu-latest=catthehacker/ubuntu:act-latest
