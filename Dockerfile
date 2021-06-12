FROM r-base:4.0.3
WORKDIR /workdir
COPY . /workdir
RUN apt-get update && apt-get install --yes \
    git \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    r-cran-rjags \
    texlive
RUN R -e "install.packages(c('covr', 'devtools', 'jsonify', 'lintr', 'optparse', 'roxygen', 'styler', 'testthat', 'tidyverse'), repos='http://cran.rstudio.com')" \
      -e "devtools::document()" && \
    R CMD build . && \
    R CMD check geci.rjags_0.1.1.tar.gz && \
    R CMD INSTALL geci.rjags_0.1.1.tar.gz
CMD ["make"]
