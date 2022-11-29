FROM rocker/rstudio:4

COPY init.sql ./
COPY mytable.csv ./

RUN apt-get update \
  && apt-get install sqlite3 -y \
  && sqlite3 -init init.sql mydb

COPY packages.R ./

EXPOSE 8787

RUN Rscript packages.R