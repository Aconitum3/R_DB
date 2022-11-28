FROM rocker/rstudio:4

RUN apt-get update \
  && apt-get install libmysqlclient-dev -y

COPY packages.R ./

EXPOSE 8787

RUN Rscript packages.R