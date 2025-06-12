## Prerequisites

This guide will help you set up your environment for the Kratix workshop, following the instructions described [here](https://docs.kratix.io/workshop/part-0/intro). Each step below includes context and reasoning to help you understand why it is necessary.

1. install jenksin promise

    ```sh
    kubectl --context $PLATFORM apply --filename https://raw.githubusercontent.com/syntasso/kratix-marketplace/main/jenkins/promise.yaml
    ```{{exec}}

2. check in `k9s` in the `promises` resources that it is installed