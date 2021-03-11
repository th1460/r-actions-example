# IBM functions with R

>[IBM Cloud™ Functions](https://cloud.ibm.com/functions/) service is an event-driven compute platform, also referred to as Serverless computing, or as Function as a Service (FaaS), that runs code in response to events or direct invocations.

## Configuration

In order to run a function with another language, that is not supported by IBM Cloud Functions, you need indicate a `exec` file with an inicial configuration. In the Cloud, the function will run on Docker container whose image is the `openwhisk/dockerskeleton`. The `apk` is an Alpine Linux package management, because of the linux distribution used in the docker image. 

```
#!/bin/bash

# install R
apk update && apk add R R-dev R-doc build-base jq

# install package
R -e "install.packages('jsonlite', repos = 'http://cran.rstudio.com/')"

# run R script
chmod +x script.R # turn executable
INPUT=`echo "$@" | jq '.s'` # get the input data in s param (see subsection Test)
./script.R $INPUT # input as arg in script
```

The `script.R` is set as:

```
#!/usr/bin/env Rscript

# get input
args <- commandArgs(trailingOnly=TRUE)

# function
A <- function(x) x^2

# input
x <- as.numeric(args[1])

# output (it is important set the output as JSON)
cat(jsonlite::toJSON(list(side = x, area = A(x)), auto_unbox = TRUE)) 
```

## Deploy

```
zip -r run.zip exec script.R
ibmcloud fn action create run run.zip --native
```

### Test

```
ibmcloud fn action invoke run --result --param s 8
```

## Web Actions

```
ibmcloud fn action update run run.zip --native --web true
```

### Request

```
curl -H "Content-type: application/json" -d '{"s":10}' \
https://${APIHOST}/api/v1/web/${NAMESPACE}/default/run.json
```

The `${APIHOST}` and `${NAMESPACE}` can be get with:

```
ibmcloud fn action get run --url
```

## References

- Preparing apps in Docker images: https://cloud.ibm.com/docs/openwhisk?topic=openwhisk-prep#prep_docker
- Creating web actions: https://cloud.ibm.com/docs/openwhisk?topic=openwhisk-actions_web
- Serverless Functions in your favorite language with Openwhisk: https://medium.com/openwhisk/serverless-functions-in-your-favorite-language-with-openwhisk-f7c447558f42

