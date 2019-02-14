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