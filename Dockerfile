FROM pegi3s/docker
LABEL maintainer="hlfernandez"

ADD image-files/compi.tar.gz /

COPY resources/scripts/* /opt/scripts/

RUN chmod ugo+x /opt/scripts/*

COPY resources/working_dir/ /opt/working_dir/

ENV PATH=/opt/scripts/:${PATH}

ADD pipeline.xml /pipeline.xml

# ENTRYPOINT ["/compi", "run",  "-p", "/pipeline.xml"]
