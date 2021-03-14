FROM openwhisk/dockerskeleton
RUN apk update && apk add R R-dev R-doc build-base jq
RUN R -e "install.packages('jsonlite', repos = 'http://cran.rstudio.com/')"
