FROM rocker/tidyverse:4.1.0
WORKDIR /workdir
COPY . /workdir
RUN apt-get update && apt-get install --yes git
RUN R -e "install.packages(c('covr', 'lintr', 'styler', 'testthat'), repos='http://cran.rstudio.com')"
RUN R -e "install.packages(c('jsonify', 'optparse', 'tidyverse'), repos='http://cran.rstudio.com')"
CMD ["make"]
