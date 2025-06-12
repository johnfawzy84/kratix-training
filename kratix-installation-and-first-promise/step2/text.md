## Kratix installtion 

this is the installation described [here](https://docs.kratix.io/workshop/installing-kratix)

11. install kratix 

    ```sh
    kubectl --context $PLATFORM apply --filename https://github.com/syntasso/kratix/releases/latest/download/kratix.yaml
    ```{{exec}}

    you can check the crds of kratix platform with the following command: 

    ```sh
    kubectl --context $PLATFORM get crds | grep kratix
    ```{{copy}}

    you can check the deployment of kratix platform with the following command: 

    ```sh
    kubectl --context $PLATFORM get deployments --namespace kratix-platform-system
    ```{{copy}}

12. create state store 

    ```sh
    cat << EOF | kubectl --context $PLATFORM apply -f -
    apiVersion: platform.kratix.io/v1alpha1
    kind: BucketStateStore
    metadata:
        name: default
    spec:
        endpoint: minio.kratix-platform-system.svc.cluster.local
        insecure: true
        bucketName: kratix
        secretRef:
            name: minio-credentials
            namespace: default
    EOF
    ```{{exec}}

13. create a destination

    ```sh
    cat <<EOF | kubectl --context $PLATFORM apply --filename -
    apiVersion: platform.kratix.io/v1alpha1
    kind: Destination
    metadata:
        name: worker-cluster
        labels:
            environment: dev
    spec:
        path: worker-cluster
        stateStoreRef:
            name: default
            kind: BucketStateStore
    EOF
    ```{{exec}}


14. check

    ```sh
    kubectl --context $WORKER get namespace kratix-worker-system
    ```{{exec}}


15. Extra checks : 
    
    - open `k9s` in the console
    - check the health/logs of `source-control` deployment in `flux-system` namespace
    - check the health/logs of `kustomization` deployment in `flux-system` namespace
    - check the health/logs of `buckets` resources
    - check the health/logs of `kustomization` resources


    !!!INFO!!!
    CONGRATULATIONS! now you have Kratix up and running, let's install some promises!