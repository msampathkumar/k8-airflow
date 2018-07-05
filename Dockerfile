# VERSION 2.28
# AUTHOR: Sampath Kumar
# DESCRIPTION: Basic Airflow container
# BUILD: docker build --rm -t msampathkumar/docker-airflow .
# SOURCE: https://github.com/msampathkumar/docker-airflow

FROM continuumio/miniconda
LABEL maintainer="Sampath Kumar M"

# Never prompts the user for choices on installation/configuration of packages
ENV DEBIAN_FRONTEND noninteractive
ENV TERM linux

# Airflow
ARG AIRFLOW_HOME=/usr/local/airflow

# Define en_US.
ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV LC_CTYPE en_US.UTF-8
ENV LC_MESSAGES en_US.UTF-8

RUN set -ex \
    && conda install -c conda-forge airflow-with-celery -y \
    && conda install -c anaconda psycopg2 -y \
    && conda install -c anaconda postgresql -y \
    && conda install -c anaconda cython -y \
    && pip install -U Celery

# Installing Custom Airflow & depencencies
RUN set -ex \
    && pip install git+https://github.com/apache/incubator-airflow.git@v1-10-test \
    && pip install kubernetes psycopg2-binary

RUN set -ex \
    && apt-get update && apt-get install -y procps && apt-get install -y lsof \
    && apt-get install -y vim

ENV AIRFLOW_HOME ${AIRFLOW_HOME}
COPY script/entrypoint.sh /entrypoint.sh
COPY config/airflow.cfg ${AIRFLOW_HOME}/airflow.cfg
COPY dags/* ${AIRFLOW_HOME}/dags/
COPY k8_scripts/pod.yaml ${AIRFLOW_HOME}/k8_scripts/pod.yaml


COPY config/k8_config ${AIRFLOW_HOME}/.kube/config
COPY config/k8_config /root/.kube/config

# RUN chown -R airflow: ${AIRFLOW_HOME}

EXPOSE 8080 5555 8793

# USER airflow
WORKDIR ${AIRFLOW_HOME}
# ENTRYPOINT ["/entrypoint.sh"]
