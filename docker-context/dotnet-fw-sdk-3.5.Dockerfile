FROM mcr.microsoft.com/dotnet/framework/sdk:3.5

USER ContainerAdministrator

WORKDIR "c:\"
COPY change-acl.ps1 .

RUN powershell -file c:\change-acl.ps1

CMD ["powershell"]