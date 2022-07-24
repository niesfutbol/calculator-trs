FROM islasgeci/base:latest
COPY . /workdir
RUN Rscript -e "install.packages(c('comprehenr', 'ggpubr', 'jsonify', 'optparse', 'plotly'), repos='http://cran.rstudio.com')"
RUN curl -fsSL https://get.deta.dev/cli.sh | sh
CMD ["make"]
