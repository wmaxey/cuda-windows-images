ARG ROOT_IMAGE="mcr.microsoft.com/windows/servercore:ltsc2022"

FROM $ROOT_IMAGE as prebuildenv

ARG MSVC_VER="17"

SHELL ["powershell.exe"]
ENTRYPOINT [ "powershell.exe" ]

RUN Set-ExecutionPolicy Unrestricted -Scope CurrentUser
ADD ./ /tools

RUN /tools/configure.ps1 -msvcVersion "17"

ADD scripts/CCCLenv.psm1  /Users/ContainerAdministrator/Documents/WindowsPowerShell/Modules/CCCLenv/CCCLenv.psm1
ADD scripts/profile.ps1  /Users/ContainerAdministrator/Documents/WindowsPowerShell/Microsoft.PowerShell_profile.ps1

# Discard history to cleanup image
FROM prebuildenv as buildenv

# Add the environment hack script into the module load path
# Exports Get-VsDevPrompt into powershell, allowing users to easily swap which version is loaded into the environment
