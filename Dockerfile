FROM islasgeci/base:latest
COPY . /workdir
RUN apt-get install libnlopt-dev --yes
RUN Rscript -e "install.packages(c('comprehenr', 'ggpubr', 'jsonify', 'optparse', 'plotly'), repos='http://cran.rstudio.com')"
RUN make setup