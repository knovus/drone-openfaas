FROM openfaas/faas-cli:latest
ENV HOME /root
ENV USER root
COPY drone-plugin.sh /usr/bin
ENTRYPOINT [ "/usr/bin/drone-plugin.sh" ]