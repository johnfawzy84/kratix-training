## Prerequisites

This guide will help you set up your environment for the Kratix workshop, following the instructions described [here](https://docs.kratix.io/workshop/part-0/intro). Each step below includes context and reasoning to help you understand why it is necessary.

0. **Ensure `kratixuser` is in the `docker` group**

    Docker requires users to have the appropriate permissions to run containers. By adding `kratixuser` to the `docker` group, you ensure that Docker commands can be executed without needing `sudo`.

    `newgrp docker`{{exec}}

1. **Install required kratix environment**

    The Kratix repository contains all the configuration files, scripts, and resources required for the workshop. Cloning it locally allows you to access and modify these files as needed.

    ```sh 
    git clone https://github.com/syntasso/kratix
    cd kratix
    ./scripts/quick-start.sh
    ```{{exec}}

2. install jenksin promise

    ```sh
    kubectl --context $PLATFORM apply --filename https://raw.githubusercontent.com/syntasso/kratix-marketplace/main/jenkins/promise.yaml
    ```{{exec}}