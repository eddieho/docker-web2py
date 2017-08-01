#!/bin/bash 

MYDIR=`dirname $0`
. $MYDIR/../env_for_cluster.sh

images_to_push="web2py_apache2 web2py_python27 web2py_mysql5"

for image in $images_to_push; do
  echo "image ${image}"
  tagged_image_name=${REGISTRY_HOSTNAME}:${REGISTRY_PUBLISHED_PORT}/${image}
  echo "docker tag ${image} ${tagged_image_name}"
  docker tag ${image} ${tagged_image_name}
  echo "docker push ${tagged_image_name}"
  docker push ${tagged_image_name}
done

