# escape=`

# Use the latest Windows Server Core image with .NET Framework 4.7.1.
FROM microsoft/dotnet-framework:4.7.1
LABEL MAINTAINER=devops@colibrigroup.com 

# Restore the default Windows shell for correct batch processing below.
SHELL ["cmd", "/S", "/C"]

# Set working directory
WORKDIR C:\Temp

## WebDeploy Installation.
# Register required DLL.
RUN regsvr32.exe %windir%\syswow64\vbscript.dll /s
# Download WebDeploy from Microsoft.
ADD https://download.microsoft.com/download/0/1/D/01DC28EA-638C-4A22-A57B-4CEF97755C6C/WebDeploy_amd64_en-US.msi C:\TEMP\\webdeploy.msi
# Install all webdeploy features
RUN msiexec /i webdeploy.msi LicenseAccepted="0" ADDLOCAL=ALL /quiet /qn /passive /norestart

## Visual Studio Build Tools Installation.
# Download the Build Tools bootstrapper.
ADD https://aka.ms/vs/15/release/vs_buildtools.exe C:\TEMP\vs_buildtools.exe

# Install Build Tools excluding workloads and components with known issues.
RUN vs_buildtools.exe --quiet --wait --norestart --nocache `
    --installPath C:\BuildTools `
    --all `
    --remove Microsoft.VisualStudio.Component.Windows10SDK.10240 `
    --remove Microsoft.VisualStudio.Component.Windows10SDK.10586 `
    --remove Microsoft.VisualStudio.Component.Windows10SDK.14393 `
    --remove Microsoft.VisualStudio.Component.Windows81SDK `
 || IF "%ERRORLEVEL%"=="3010" EXIT 0

## Nuget Installation
# Download Nuget
ADD https://dist.nuget.org/win-x86-commandline/v4.9.2/nuget.exe C:\nuget\nuget.exe
# Add nuget to PATH
RUN ["setx", "path", "%PATH%;C:\\nuget"]

## AWSCLI Installation
# Download AWSCLI
ADD https://s3.amazonaws.com/aws-cli/AWSCLISetup.exe C:\TEMP\AWSCLISetup.exe
RUN C:\TEMP\AWSCLISetup.exe 

# Start Windows container with Powershell
WORKDIR C:\BuildTools
CMD ["powershell.exe", "-NoLogo", "-ExecutionPolicy", "Bypass"]