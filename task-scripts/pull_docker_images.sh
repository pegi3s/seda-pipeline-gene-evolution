#!/bin/bash

for image in $(printenv | grep '_docker_image=' | grep -v "grep" | cut -f1 -d'='); do
    image_value=${!image}

    if [[ -n "$image_value" ]]; then
        if docker images --format '{{.Repository}}:{{.Tag}}' | grep -q "^$image_value$"; then
            echo "Docker image $image_value already exists locally. Skipping pull."
        else
            echo "Pulling Docker image: $image_value"
            docker pull "$image_value"
        fi
    else
        echo "Warning: Variable $image has an empty value"
    fi
done