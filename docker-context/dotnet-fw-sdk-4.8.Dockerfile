FROM mcr.microsoft.com/dotnet/framework/sdk:4.8

USER ContainerAdministrator

WORKDIR "/"
COPY change-acl.ps1 "/"

RUN powershell -file /change-acl.ps1

CMD ["powershell"]