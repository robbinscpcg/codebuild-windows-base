# codebuild-windows-base

This repository hosts a Windows container for use with AWS CodeBuild.  Container specs are as follows

* Base Image: microsoft/dotnet-framework:4.7.1

* Included Software:
  * nuget (v4.9.3)
  * WebDeploy (v3.6)
  * Visual Studio Build Tools (2017)

## Local Development/Testing

Perform the following steps to build and run the `codebuild-windows-base` container:

1. Execute `docker build`, specifying a tag of your choice.

    ```language=bash
    docker build -t codebuild-windows-base:latest .
    ```

1. Start the container and test functionality as appropriate.

    ```language=bash
    docker run -it codebuild-windows-base:latest
    ```

## Deployment to ECR

1. Clone the repository, make changes to the Dockerfile as necessary

1. Login to ECR using the following command

   ```powershell
   Invoke-Expression -Command (aws ecr get-login --no-include-email)
   ```

1. Build the container, giving it the `codebuild-windows:latest` tag

   ```bash
   docker build . -t codebuild-windows:latest
   ```

1. Tag the local container with the correct ECR repostiory/tag

   ```bash
   docker image tag codebuild-windows:latest 577839833053.dkr.ecr.us-east-1.amazonaws.com/codebuild-windows
   ```

1. Push the image to ECR

   ```bash
   docker image push 577839833053.dkr.ecr.us-east-1.amazonaws.com/codebuild-windows:latest
   ```