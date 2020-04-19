FROM openfaas/faas-cli:latest
ENV USER root
COPY drone-plugin.sh /usr/bin
ENTRYPOINT [ "/usr/bin/drone-plugin.sh" ]