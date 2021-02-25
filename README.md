# IBM functions with R

## Deploy

```
zip -r run.zip exec script.R
ibmcloud fn action create run run.zip --native
```

## Test

```
ibmcloud fn action invoke run --result --param n 8
```
