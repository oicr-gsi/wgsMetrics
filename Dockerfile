FROM modulator:latest

MAINTAINER Fenglin Chen <f73chen@uwaterloo.ca>

# packages should already be set up in modulator:latest
USER root

# move in the yaml to build modulefiles from
COPY recipes/wgs_metrics_recipe.yaml /modulator/code/gsi/recipe.yaml

# build the modules and set folder / file permissions
RUN ./build-local-code /modulator/code/gsi/recipe.yaml --initsh /usr/share/modules/init/sh --output /modules && \
	find /modules -type d -exec chmod 777 {} \; && \
	find /modules -type f -exec chmod 777 {} \;

# add the user
RUN groupadd -r -g 1000 ubuntu && useradd -r -g ubuntu -u 1000 ubuntu
USER ubuntu

# copy the setup file to load the modules at startup
# use different versions of .bashrc depending on gatk version of container
COPY .bashrc /home/ubuntu/.bashrc

# set environment paths for modules
#ENV JAVA_ROOT="/modules/gsi/modulator/sw/Ubuntu18.04/java-8"
#ENV PICARD_ROOT="/modules/gsi/modulator/sw/Ubuntu18.04/picard-2.21.2"

#ENV LD_LIBRARY_PATH="/modules/gsi/modulator/sw/Ubuntu18.04/java-8/lib"
#ENV MANPATH="/modules/gsi/modulator/sw/Ubuntu18.04/java-8/man"
#ENV PATH="/modules/gsi/modulator/sw/Ubuntu18.04/java-8/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" 

CMD /bin/bash
