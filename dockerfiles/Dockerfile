# docker build -t debian-epics .

#FROM debian:bullseye-slim
#FROM linuxcontainers/debian-slim:latest
FROM debian:11-slim
# To do so, the following hack was used:
# https://github.com/docker/buildx/issues/157#issuecomment-538048500
#FROM --platform=linux/amd64  debian:11-slim

LABEL maintainer="Bernardo Carvalho <bernardo.carvalho@tecnico.ulisboa.pt>"

#Setting path for workdir
ARG WORK_PATH=/root/Projects
#Setting workdir
WORKDIR $WORK_PATH
# Installing all the dependencies needed
RUN apt-get update
#RUN apt-get install -y apt-utils
RUN apt-get install  --no-install-recommends -yq \
    git make gcc g++ libc-dev libreadline-dev re2c vim-nox \
    ca-certificates locales curl
RUN apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV TERM=xterm
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
#
#Compiling EPICS
#RUN cd /opt/epics-base-7.0.2 && echo "OP_SYS_CXXFLAGS += -std=c++11" >> configure/os/CONFIG_SITE.linux-x86_64.Common
# We need to set ENV EPICS_HOST_ARCH according to the $TARGETARCH
ENV EPICS_HOST_ARCH=linux-x86_64
#ENV EPICS_HOST_ARCH=linux-x86
#ENV EPICS_HOST_ARCH=linux-arm

ENV EPICS_ROOT=/opt
RUN cd ${EPICS_ROOT} && git clone --recursive https://github.com/epics-base/epics-base \
    && cd epics-base && make -j
ENV EPICS_BASE=${EPICS_ROOT}/epics-base
ENV EPICS_BASE_BIN=${EPICS_BASE}/bin/${EPICS_HOST_ARCH} \
    EPICS_BASE_LIB=${EPICS_BASE}/lib/${EPICS_HOST_ARCH} \
    LD_LIBRARY_PATH=${EPICS_BASE_LIB}:${LD_LIBRARY_PATH}
ENV PATH=${EPICS_BASE_BIN}:${PATH}
ENV SUPPORT=${EPICS_ROOT}/support
COPY RELEASE.local ${SUPPORT}/
#RUN cd ${SUPPORT} && git clone https://github.com/epics-modules/calc.git && cd calc
# && make
#ENV CALC=${SUPPORT}/calc
RUN cd ${SUPPORT} && git clone https://github.com/epics-modules/asyn.git && cd asyn && make -j
# ENV ASYN=${ASYN}/asyn
RUN cd ${SUPPORT} && git clone https://github.com/paulscherrerinstitute/StreamDevice.git stream \
    && cd stream && rm GNUmakefile &&  make -j
RUN cd /root/Projects  && mkdir -p iocs/exampleIoc && cd iocs/exampleIoc && \
    ${EPICS_BASE_BIN}/makeBaseApp.pl -u user0 -t example exampleIoc && \
    ${EPICS_BASE_BIN}/makeBaseApp.pl -u user0 -i -t example -p exampleIoc exampleIoc && \
    make -j && cd iocBoot/iocexampleIoc && chmod +x st.cmd

