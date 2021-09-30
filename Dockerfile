FROM rocker/geospatial:latest

MAINTAINER Weecology "https://github.com/weecology/rdataretriever"

# Write enviromental options to config files
RUN echo "options(repos='https://cloud.r-project.org/')" >> ~/.Rprofile
RUN echo "options(repos='https://cloud.r-project.org/')" >> ~/.Renviron
RUN echo "R_LIBS=\"/usr/lib/R/library\"">> ~/.Rprofile
RUN echo "R_LIBS=\"/usr/lib/R/library\"">> ~/.Renviron
RUN echo "R_LIBS_USER=\"/usr/lib/R/library\"">> ~/.Renviron

# Set encoding
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

RUN apt-get update && \
    apt-get install -y software-properties-common && \
    rm -rf /var/lib/apt/lists/*
RUN apt-add-repository ppa:ubuntugis/ubuntugis-unstable
RUN apt-get update && sudo apt-get install -y --no-install-recommends apt-utils
RUN apt-get install -y --force-yes tzdata
RUN apt-get install -y --force-yes build-essential wget git locales locales-all > /dev/null
RUN apt-get install -y --force-yes postgresql-client mariadb-client > /dev/null
RUN apt-get install -y --force-yes libpq-dev
RUN apt-get install -y --force-yes libgdal-dev
RUN apt-get install -y --force-yes gdal-bin

RUN export CPLUS_INCLUDE_PATH=/usr/include/gdal
RUN export C_INCLUDE_PATH=/usr/include/gdal

# Remove python2 and install python3
RUN apt-get remove -y python && apt-get install -y python3  python3-pip curl
RUN rm -f /usr/bin/python && ln -s /usr/bin/python3 /usr/bin/python
RUN rm -f /usr/bin/pip && ln -s /usr/bin/pip3 /usr/bin/pip
RUN pip install GDAL==3.2.3 
RUN apt-get install -y --force-yes postgis
RUN echo "export PATH="/usr/bin/python:$PATH"" >> ~/.profile
RUN echo "export PYTHONPATH="/usr/bin/python:$PYTHONPATH"" >> ~/.profile
RUN echo "export PGPASSFILE="~/.pgpass"" >> ~/.profile

# Add permissions to config files
RUN chmod 0644 ~/.Renviron
RUN chmod 0644 ~/.Rprofile
RUN chmod 0644 ~/.profile

# Install retriever python package
RUN pip install h5py
RUN pip install pillow
Run pip install kaggle
# h5py, pillow, kaggle fail to install from the requirement file.
RUN pip install git+https://git@github.com/weecology/retriever.git
#RUN retriever ls > /dev/null
RUN pip install  psycopg2-binary pymysql > /dev/null
RUN R_RETICULATE_PYTHON="/usr/bin/python" | echo $R_RETICULATE_PYTHON >>  ~/.Renviron

COPY . ./rdataretriever
# Use entrypoint to run more configurations.
# set permissions.
# entrypoint.sh will set out config files
RUN chmod 0755 /rdataretriever/cli_tools/entrypoint.sh
ENTRYPOINT ["/rdataretriever/cli_tools/entrypoint.sh"]


WORKDIR ./rdataretriever

# Change permissions to config files
# Do not run these cmds before Entrypoint.
RUN chmod 600 cli_tools/.pgpass
RUN chmod 600 cli_tools/.my.cnf

CMD ["bash", "-c", "retriever -v"]
