FROM openfaas/faas-cli:latest
USER root
COPY drone-plugin.sh /usr/bin
ENTRYPOINT [ "/usr/bin/drone-plugin.sh" ]