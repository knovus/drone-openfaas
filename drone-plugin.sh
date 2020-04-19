#!/bin/sh

set -euo pipefail

#Prepare parameters to be used
if [[ "${PLUGIN_YAML:-}" ]]; then
    OF_YAML="--yaml ${PLUGIN_YAML}"
fi

if [[ "${PLUGIN_TLS_NO_VERIFY:-}" == "true" ]]; then
    OF_TLS_NO_VERIFY="--tls-no-verify"
fi

if [[ "${PLUGIN_USERNAME:-}" == "true" ]]; then
    OF_USERNAME="--username ${PLUGIN_USERNAME}"
fi

if [[ "${PLUGIN_TAG:-}" ]]; then
    OF_TAG="--tag=${PLUGIN_TAG}"
fi

if [[ "${PLUGIN_IMAGE_NAME:-}" ]]; then
    OF_IMAGE="--image=${PLUGIN_IMAGE}"
fi

if [[ "${PLUGIN_IMAGE_NAME:-}" && ${PLUGIN_REGISTRY:-} ]]; then
    OF_IMAGE="--image=${PLUGIN_REGISTRY}/${PLUGIN_IMAGE}"
fi

if [[ "${PLUGIN_URL:-}" ]]; then
    OF_URL="--gateway ${PLUGIN_URL}"
fi

#
#Executing commands!!!
#
#Get Tags from Git to be used from OpenFaaS CLI tag
if [[ "${OF_TAG:-}" ]]; then
    git fetch --tags
fi
#Pull store template if needed
if [[ -n "${PLUGIN_TEMPLATE:-}" ]]; then
    /usr/bin/faas-cli template store pull "${TEMPLATE}"
fi 
#Generate Step
if [[ ! "${PLUGIN_DEPLOY:-}" ]]; then
    /usr/bin/faas-cli build ${OF_YAML:-} --shrinkwrap 
#Deploy Step
else
    #Login to OpenFaaS Gateway
    ${PLUGIN_PASSWORD} | /usr/bin/faas-cli login ${OF_USERNAME:-} --password-stdin ${OF_URL:-} ${TLS_NO_VERIFY:-}
    #Deploy the function
    /usr/bin/faas-cli deploy ${OF_YAML:-} ${OF_URL:-} ${IMAGE:-} ${TAG:-}
fi