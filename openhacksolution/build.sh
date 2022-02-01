pushd $context_path
 docker build \
 -f ../dockerfiles/$docker_file_name \
 -t "$tag_name:$version" \
 --no-cache \
 --build-arg IMAGE_VERSION="$version" \
 --build-arg IMAGE_CREATE_DATE="$timestamp" \
 --build-arg IMAGE_SOURCE_REVISION="`git rev-parse HEAD`" \
 .
 popd