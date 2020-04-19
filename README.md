# drone-openfaas

An OpenFaaS Plugin for Drone.io.

This plugin is based on openfaas-cli and is intended to use only for generation (Dockerfile and stuffs) and deploy (Create/Update Function to OpenFaaS), because this image don't have support for docker in docker, and does wan't to have it in the future.  Use a diferent step to build and publish docker image, like kaniko or a docker in docker plugin.

Example .drone for Drone <1.0 (pushing OpenFaas Function to Private Docker Registry)

```yaml
  pipeline:
    generate:
      image: knovus/drone-openfaas
      yaml: my_function.yml #If you use stack.yml, you can omit this parameter
    build:
    #
    #Build docker image and publish, using you favorite plugin
    #
    deploy:
      image: knovus/drone-openfaas
      secrets:
      - source: openfaas_password
        target: plugin_password
      deploy: true
      yaml: my_function.yml #Optional, If you use stack.yml, you can omit this parameter
      image_name: private_registry/image_name #Optional, Use only if you want override config from .yml
      tag: latest #Optional, If you want to use OpenFaaS tag, accepts 'latest', 'sha', 'branch', or 'describe'
      url: my.openfaas.com #OpenFaaS Gateway URL
      tls_no_verify: true #Optional
      username: myopenfaas #Only needed if you use a different 'Admin' username
```

Example .drone for Drone >=1.0 (pushing OpenFaas Function to Private Docker Registry)

```yaml
kind: pipeline
name: default

steps:
- name: generate
  image: knovus/drone-openfaas
  settings:
    yaml: my_function.yml #If you use stack.yml, you can omit this parameter
- name: build
  #
  #Build docker image and publish, using you favorite plugin
  #
- name: deploy
  image: knovus/drone-openfaas
  settings:
    deploy: true
    yaml: my_function.yml #Optional, If you use stack.yml, you can omit this parameter
    image: private_registry/image_name #Optional, Use only if you want override config from .yml
    tag: latest #Optional, If you want to use OpenFaaS tag, accepts 'latest', 'sha', 'branch', or 'describe'
    url: my.openfaas.com #OpenFaaS Gateway URL
    tls_no_verify: true #Optional
    username: myopenfaas #Only needed if you use a different 'Admin' username
    password:
      from_secret: openfaas_password
```