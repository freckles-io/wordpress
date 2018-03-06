#! /usr/bin/env bash

MYSQL_DIR=".freckelize/docker/mysql_volume"
BACKUPS_DIR="backups"
WORDPRESS_DIR="wordpress"
DOCKER_ID="local"

#THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
THIS_DIR="$( pwd )"
THIS_DIR_NAME=$(basename ${THIS_DIR})
cd -P "$THIS_DIR"

function display_help {
    echo ""
    echo "Usage:"
    echo "    init_blueprint.sh -h                      Display this help message."
    echo "    init_blueprint.sh [-m]               Build a Docker container for this freckle folder."
}


while getopts ":hmn:" opt; do
    case ${opt} in
        h )
            display_help
            exit 0
            ;;
        m )
            mount_mysql=true
            ;;
        n )
            IMAGE_NAME=$OPTARG
            ;;
        \? )
            echo "Invalid Option: -$OPTARG" 1>&2
            display_help
            exit 1
            ;;
    esac
done
shift $((OPTIND -1))

if [[ -z "$IMAGE_NAME" ]]; then
    IMAGE_NAME="${DOCKER_ID}:freckelize_${THIS_DIR_NAME}"
fi

if [ "${mount_mysql}" = true ]; then
    if [ ! -d "${THIS_DIR}/${MYSQL_DIR}/mysql" ] && [ "$MOUNT_MYSQL_VOLUME" = true ]; then
        # copy 'raw' mysql database, so we don't loose the data we are working on when docker container is stopped
        echo "Copying initial mysql data to: ${THIS_DIR}/${MYSQL_DIR}..."
        mkdir -p "${THIS_DIR}/${MYSQL_DIR}"
        docker run -i --rm --mount type=bind,source="${THIS_DIR}/${MYSQL_DIR}",target="/mysql_init" ${IMAGE_NAME} /bin/bash << EOF
cp -a /var/lib/mysql/* /mysql_init
EOF
    fi
fi

if [ ! -s ${THIS_DIR}/wordpress/wp-config.php ]; then
    echo "Copying initial wordpress config file to: wordpress/wp-config.php..."
    docker run -i --rm --mount type=bind,source="${THIS_DIR}/wordpress",target="/freckle/wordpress_init" ${IMAGE_NAME} /bin/bash << EOF
cp -a /freckle/wordpress/wp-config.php /freckle/wordpress_init/wp-config.php
EOF
fi

if [ ! -d ${THIS_DIR}/wordpress/wp-content/themes ]; then
    echo "Copying initial wordpress content folder to: wordpress/wp-content..."
    docker run -i --rm --mount type=bind,source="${THIS_DIR}/wordpress",target="/freckle/wordpress_init" ${IMAGE_NAME} /bin/bash << EOF

cp -a /freckle/wordpress/wp-content/* /freckle/wordpress_init/wp-content/
EOF
fi
