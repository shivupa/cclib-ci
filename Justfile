root := justfile_directory()
dockerfile := root / "Dockerfile"
tag := "py311"
image_base := "shivupa/cclib-ci"
build_arg := "--build-arg PYTHON_VERSION_DIR=" + tag

# These commands are meant to be executed with the subdirectory
# that corresponds to a Python version as an argument, like
# `just tag=py310 build-podman`..
#
# If your user is not a part of the `docker` group and needs elevated
# permissions to execute Docker commands, `sudo just ...` is sufficient.

build-docker:
    docker buildx build --target test -t {{ image_base }}:{{ tag }}-test {{ build_arg }} -f {{ dockerfile }} .
    docker buildx build --target ci -t {{ image_base }}:{{ tag }} {{ build_arg }} -f {{ dockerfile }} .
    docker untag {{ image_base }}:{{ tag }}-test

build-podman:
    podman build --format docker --target test -t {{ image_base }}:{{ tag }}-test {{ build_arg }} -f {{ dockerfile }} .
    podman build --format docker --target ci -t {{ image_base }}:{{ tag }} {{ build_arg }} -f {{ dockerfile }} .
    podman untag {{ image_base }}:{{ tag }}-test

shell-docker:
    docker run -it {{ image_base }}:{{ tag }} bash

shell-podman:
    podman run -it {{ image_base }}:{{ tag }} bash

act:
    act -W ./.github/workflows/build_and_push.yaml -P ubuntu-latest=catthehacker/ubuntu:act-latest
