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
echo "$@" > input.json # set input
./script.R # run script
```

The `script.R` is set as:

```
#!/usr/bin/env Rscript

# get input
input <- jsonlite::fromJSON("input.json", flatten = FALSE)
input <- as.numeric(input)

# function
A <- function(x) x^2

# output (it is important set the output as JSON)
jsonlite::toJSON(list(side = input, area = A(input)), auto_unbox = TRUE)
```

## Deploy

```
zip -r raction.zip exec script.R
ibmcloud fn action create raction raction.zip --native
```

### Test

```
ibmcloud fn action invoke raction --result --param s 8
```

## Web Actions

```
ibmcloud fn action update raction raction.zip --native --web true
```

### Request

```
curl -H "Content-type: application/json" -d '{"s":10}' \
https://${APIHOST}/api/v1/web/${NAMESPACE}/default/raction.json
```

The `${APIHOST}` and `${NAMESPACE}` can be get with:

```
ibmcloud fn action get raction --url
```

## Docker

It is possible to use docker to deploy your function.

You need a Dockerfile, build and push (Docker Hub only)

```
# dockerfile
FROM openwhisk/dockerskeleton
RUN apk update && apk add R R-dev R-doc build-base
RUN R -e "install.packages('jsonlite', repos = 'http://cran.rstudio.com/')"

# build
docker -t th1460/raction .

# push
docker push th1460/raction
```

The `exec` is modified because the step to install R, linux dependencies and R libraries can be changed to execute in the Docker build.

```
#!/bin/bash

# run R script
chmod +x script.R # turn executable
echo "$@" > input.json # set input
./script.R # run script
```

To deploy the functions you need to indicate the repository that is in Docker Hub `--docker th1460/ractions`

```
ibmcloud fn action create raction raction.zip --docker th1460/ractions
```

This approach could be interesting to reduce the time to build in the request of the function

## References

- Preparing apps in Docker images: https://cloud.ibm.com/docs/openwhisk?topic=openwhisk-prep#prep_docker
- Creating web actions: https://cloud.ibm.com/docs/openwhisk?topic=openwhisk-actions_web
- Serverless Functions in your favorite language with Openwhisk: https://medium.com/openwhisk/serverless-functions-in-your-favorite-language-with-openwhisk-f7c447558f42

