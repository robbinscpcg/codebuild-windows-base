# escape=`

# Use the latest Windows Server Core image with .NET Framework 4.7.2.
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
ADD https://download.microsoft.com/download/E/E/D/EEDF18A8-4AED-4CE0-BEBE-70A83094FC5A/BuildTools_Full.exe C:\TEMP\BuildTools_Full.exe

# Install Build Tools.
RUN C:\TEMP\BuildTools_Full.exe /Silent /Full

## AWSCLI Installation
# Download AWSCLI
ADD https://s3.amazonaws.com/aws-cli/AWSCLI64PY3.msi C:\TEMP\AWSCLI64PY3.msi
RUN msiexec /i AWSCLI64PY3.msi LicenseAccepted="0" ADDLOCAL=ALL /quiet /qn /passive /norestart

## AWS PowerShell Installation
ADD https://sdk-for-net.amazonwebservices.com/latest/AWSToolsAndSDKForNet.msi C:\TEMP\AWS_PS.msi
RUN msiexec /i AWS_PS.msi LicenseAccepted="0" ADDLOCAL=ALL /quiet /qn /passive /norestart

## Git Installation
ADD https://github.com/git-for-windows/git/releases/download/v2.21.0.windows.1/Git-2.21.0-64-bit.exe C:\TEMP\Git-2.21.0-64-bit.exe
RUN Git-2.21.0-64-bit.exe /SILENT /COMPONENTS="icons,ext\reg\shellhere,assoc,assoc_sh"

## Correct path(s)
RUN setx path "%path%;C:\Program Files (x86)\MSBuild\14.0\Bin;C:\Program Files\Amazon\AWSCLI\bin;C:\Program Files (x86)\IIS\Microsoft Web Deploy V3"

# Start Windows container with Powershell
WORKDIR C:\BuildTools
CMD ["powershell.exe", "-NoLogo", "-ExecutionPolicy", "Bypass"]