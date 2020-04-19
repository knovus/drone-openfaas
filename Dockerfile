FROM openfaas/faas-cli:latest

COPY drone-plugin.sh /usr/bin
ENTRYPOINT [ "/usr/bin/drone-plugin.sh" ]