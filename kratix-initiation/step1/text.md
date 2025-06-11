## Prerequistes
1. Install the following tools by simply running the following command : 

    `brew install kind kubectl yq minio-mc k9s`{{exec}}

2. clone kratix repo 

    ```sh 
    git clone https://github.com/syntasso/kratix
    cd kratix
    ```{{exec}}

3. create platform cluster in `kind`

    ```sh
    # make sure there are no clusters running
    kind delete clusters --all

    kind create cluster \
        --name platform \
        --image kindest/node:v1.27.3 \
        --config config/samples/kind-platform-config.yaml
    ```{{exec}}

4. create worker cluster in `kind`

    ```sh
    # make sure there are no clusters running
    kind create cluster \
        --name worker \
        --image kindest/node:v1.27.3 \
        --config config/samples/kind-worker-config.yaml
    ```{{exec}}

5. export the needed env. variables

    ```sh
    export PLATFORM="kind-platform"
    export WORKER="kind-worker"
    ```{{exec}}

6. install cert-manager

    ```sh
    kubectl --context $PLATFORM apply --filename https://github.com/cert-manager/cert-manager/releases/download/v1.15.0/cert-manager.yaml
    ```{{exec}}

7. check if cert-manager installed 

    ```sh
    kubectl --context $PLATFORM get pods --namespace cert-manager
    ```

8. install minio repo

    ```sh
    kubectl --context $PLATFORM apply --filename config/samples/minio-install.yaml
    ```{{exec}}

9. install worker pre-requists 

    ```sh
    ./scripts/install-gitops --context $WORKER --path worker-cluster
    ```{{exec}}

10. wait flux to start

    ```sh
    kubectl --context $WORKER get deployments --namespace flux-system --watch
    ```{{exec}}sss