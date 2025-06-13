## Prerequisites

This guide will help you set up your environment for the Kratix workshop, following the instructions described [here](https://docs.kratix.io/workshop/installing-a-promise). 

1. **Install the Jenkins Promise**

    The Jenkins Promise provides a way to provision Jenkins instances on your clusters using Kratix. To install it, run:

    ```sh
    kubectl --context $PLATFORM apply --filename https://raw.githubusercontent.com/syntasso/kratix-marketplace/main/jenkins/promise.yaml
    ```{{exec}}

    This command applies the Jenkins Promise manifest to your Platform cluster. The `$PLATFORM` environment variable should point to your Platform cluster context.

2. **Verify the Promise Installation**

    Open `k9s` (a terminal UI for managing Kubernetes clusters) and navigate to the `promises` resource in your Platform cluster. Check that the Jenkins Promise appears in the list and its status is `Available`. This confirms that the Promise has been successfully registered.

3. **Check the Jenkins Operator in the Worker Cluster**

    The Jenkins Promise will deploy a Jenkins Operator to your Worker cluster. To verify this, run:

    ```sh
    kubectl --context $WORKER get deployments --watch
    ```{{exec}}

    Watch for a deployment related to Jenkins. This ensures that the operator responsible for managing Jenkins instances is running in your Worker cluster.

4. **Request a Jenkins Resource from the Promise**

    Now, create a Jenkins resource using the Promise. This will trigger the provisioning of a Jenkins instance in your Worker cluster. Run:

    ```sh
    cat <<EOF | kubectl --context $PLATFORM apply --filename -
        apiVersion: marketplace.kratix.io/v1alpha1
        kind: jenkins
        metadata:
            name: example
            namespace: default
        spec:
            env: dev
        EOF
    ```{{exec}}

    This command creates a new Jenkins resource named `example` in the `default` namespace, with the environment set to `dev`.

5. **Check the Started Job in the Platform Cluster**

    After requesting the Jenkins resource, Kratix will start a job in the Platform cluster to process the request. To monitor this, run:

    ```sh
    kubectl --context $PLATFORM get pods
    ```{{exec}}

    Look for pods related to the Jenkins Promise. Their status will indicate if the resource provisioning is in progress or completed.

6. **Check the Started Jenkins Instance in the Worker Cluster**

    Once the job is processed, a Jenkins instance should be running in your Worker cluster. To verify, run:

    ```sh
    kubectl --context $WORKER get pods --watch
    ```{{exec}}

    Watch for a new pod related to Jenkins. When it reaches the `Running` state, your Jenkins instance is ready.

7. **Delete the Jenkins Instance**

    If you want to remove the Jenkins instance, delete the Promise resource from the Platform cluster:

    ```sh
    kubectl --context $PLATFORM delete promise jenkins
    ```{{exec}}

    This will trigger the cleanup process and remove the Jenkins instance from the Worker cluster.

    **Verify Deletion**

    To confirm that the Jenkins pod has been deleted from the Worker cluster, run:

    ```sh
    kubectl --context $WORKER get pods
    ```{{exec}}

    The Jenkins pod should no longer appear in the list.