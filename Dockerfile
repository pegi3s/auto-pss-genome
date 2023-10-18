FROM pegi3s/docker
LABEL maintainer="hlfernandez"

ADD image-files/compi.tar.gz /

RUN apt-get update && apt-get -y upgrade && \
    apt-get install -y bc tar gzip

COPY resources/scripts/* /opt/scripts/
COPY resources/bpositive/*.sh /opt/scripts/bpositive/

RUN chmod ugo+x /opt/scripts/* /opt/scripts/bpositive/*

COPY resources/working_dir/ /opt/working_dir/

ENV PATH=/opt/scripts/:/opt/scripts/bpositive/:${PATH}

ADD pipeline.xml /pipeline.xml
