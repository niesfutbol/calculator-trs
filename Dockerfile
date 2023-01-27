FROM islasgeci/base:latest
COPY . /workdir
RUN apt-get install libnlopt-dev --yes
RUN Rscript -e "install.packages(c('comprehenr', 'ggpubr', 'jsonify', 'optparse', 'plotly'), repos='http://cran.rstudio.com')"
RUN Rscript -e "install.packages(c('patchwork', 'png', 'RcppRoll'), repos='http://cran.rstudio.com')"
RUN Rscript -e "devtools::install_github('IslasGECI/testtools', build_vignettes=FALSE, upgrade = 'always')"
RUN make setup