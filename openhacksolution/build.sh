context_path=`pwd`
tag_name='tripinsights/poi'
version='1.0'
timestamp="`date -u +"%Y-%m-%dT%H:%M:%SZ"`"
docker_file_name='Dockerfile_3'

pushd $context_path
 docker build \
 -f ../../dockerfiles/$docker_file_name \
 -t "$tag_name:$version" \
 --no-cache \
 --build-arg IMAGE_VERSION="$version" \
 --build-arg IMAGE_CREATE_DATE="$timestamp" \
 --build-arg IMAGE_SOURCE_REVISION="`git rev-parse HEAD`" \
 .
 popd