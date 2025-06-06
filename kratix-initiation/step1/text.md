verify the following installation of kratix 
1. Minio 

```sh
kubectl --context $PLATFORM get deployments --namespace kratix-platform-system
```

2. forward the output of the last command for verification

```sh
kubectl --context $PLATFORM get deployments --namespace kratix-platform-system > /tmp/minio_output
```