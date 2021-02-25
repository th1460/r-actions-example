# IBM functions with R

## Deploy

```
zip -r run.zip exec script.R
ibmcloud fn action create run run.zip --native
```

### Test

```
ibmcloud fn action invoke run --result --param n 8
```

## Web Actions

```
ibmcloud fn action update run run.zip --native --web true
```

### Request

```
curl -H "Content-type: application/json" -d '{"n":10}' \
https://${APIHOST}/api/v1/web/${NAMESPACE}/default/run.json/run
```

The `${APIHOST}` and `${NAMESPACE}` can be get with:

```
ibmcloud fn action get run --url
```

