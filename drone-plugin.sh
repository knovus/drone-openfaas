#!/bin/sh

set -euo pipefail

#Prepare parameters to be used
if [[ "${PLUGIN_YAML:-}" ]]; then
    OF_YAML="--yaml ${PLUGIN_YAML}"
fi

if [[ "${PLUGIN_TLS_NO_VERIFY:-}" == "true" ]]; then
    OF_TLS_NO_VERIFY="--tls-no-verify"
fi

if [[ "${PLUGIN_USERNAME:-}" ]]; then
    OF_USERNAME="--username ${PLUGIN_USERNAME}"
fi

if [[ "${PLUGIN_TAG:-}" ]]; then
    OF_TAG="--tag=${PLUGIN_TAG}"
fi

if [[ "${PLUGIN_IMAGE_NAME:-}" ]]; then
    OF_IMAGE="--image=${PLUGIN_IMAGE_NAME}"
fi

if [[ "${PLUGIN_IMAGE_NAME:-}" && "${PLUGIN_REGISTRY:-}" ]]; then
    OF_IMAGE="--image=${PLUGIN_REGISTRY}/${PLUGIN_IMAGE_NAME}"
fi

if [[ "${PLUGIN_URL:-}" ]]; then
    OF_URL="--gateway ${PLUGIN_URL}"
fi

#
#Executing commands!!!
#
#Pull store template if needed
if [[ "${PLUGIN_TEMPLATE:-}" ]]; then
    /usr/bin/faas-cli template store pull "${PLUGIN_TEMPLATE}"
elif [[ ! "${PLUGIN_DEPLOY:-}" ]]; then
    /usr/bin/faas-cli template pull https://github.com/openfaas/templates.git
fi 
#Generate Step
if [[ ! "${PLUGIN_DEPLOY:-}" ]]; then
    /usr/bin/faas-cli build ${OF_YAML:-} --shrinkwrap
#Deploy Step
elif [[ -n "${PLUGIN_PASSWORD:-}" && -n "${PLUGIN_URL:-}" ]]; then
    #Login to OpenFaaS Gateway
    echo ${PLUGIN_PASSWORD} | /usr/bin/faas-cli login ${OF_USERNAME:-} --password-stdin ${OF_URL:-} ${TLS_NO_VERIFY:-}
    #Deploy the function
    /usr/bin/faas-cli deploy ${OF_YAML:-} ${OF_URL} ${OF_IMAGE:-} ${OF_TAG:-}
    else
        echo "ERROR: Must provide a OpenFaaS Gateway URL (url or plugin_url secret) and Password (password or plugin_password secret) parameters to Deploy"
        exit 1
fi