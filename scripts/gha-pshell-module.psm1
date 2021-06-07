function Invoke-ContainerizedDotnetSdkCommand {
    <#
    .SYNOPSIS
    Invokes executable commands in a Microsoft .NET Framework SDK Docker container
    .DESCRIPTION
    Intended to be run on Microsoft Windows Server 20H2
    
    This command uses Docker Engine for Microsoft Windows 20H2 to run programs installed in the following
    Micosoft .NET Framework SDK container images:

    - mcr.microsoft.com/dotnet/framework/sdk:4.8
    - mcr.microsoft.com/dotnet/framework/sdk:3.5
    .PARAMETER DotnetFrameworkVersion
    The target .NET Framework version to build.  The supported versions are:

    - 4.8, 4.7.2, 4.7.1, 4.7, and 4.6.2
    - 3.5, 3.0, and 2.5

    .PARAMETER CommandString
    The name of the executable program and its parameters contained in the Docker container image to execute.

    The available executable programs will be different in the different Docker container images used.

    As of 2021-06-02, the Microsoft Framework SDK container image tagged 4.8 for Windows Server Core 20H2
    supports the ability to build projects targeting the following .NET Framework versions: 
    
    - 4.8
    - 4.7.2
    - 4.7.1
    - 4.7
    - 4.6.2

    Available command line programs include:

    - dotnet
    - msbuild
    - nuget
    - al (Assembly linker)
    - aximp (Windows Forms ActiveX Control Importer)
    - clrver (CLR Version Tool)
    - corflags (CorFlags Conversion Tool)
    - gacutil (Global Asseembly Cache Tool)
    - ildasm (IL disassembler)
    - lc (License Compiler)
    - mage (Manifest Generation and Editing Tool)
    - mgmtclassgen (Management Strongly Typed Class Generator)
    - mpgo (Managed Profile Guided Optimization Tool)
    - peverify (PEVerify Tool)
    - resgen (Resource File Generator)
    - secannotate (.NET Security Annotator Tool)
    - signtool (Sign Tool)
    - sn (Strong Name Tool)
    - sqlmetal (Code Generation Tool)
    - storeadm (Isolated Storage Tool)
    - tlbexp (Type Library Exporter)
    - tlbimp (Type Library Importer)
    - winmdexp (Windows Runtime Metadata Export Tool)
    - winres (Windows Forms Resource Editor)
    - vstest.console

    The Microsoft Framework SDK container image tagged 3.5 for Windows Server Core 20H2
    supports the ability to build projects targeting the following .NET Framework versions: 
    
    - 4.8
    - 3.5
    - 3.0
    - 2.5

    Available command line programs include:

    - dotnet
    - msbuild
    - nuget
    - dotnet
    - msbuild
    - nuget
    - al (Assembly linker)
    - aximp (Windows Forms ActiveX Control Importer)
    - clrver (CLR Version Tool)
    - corflags (CorFlags Conversion Tool)
    - gacutil (Global Asseembly Cache Tool)
    - ildasm (IL disassembler)
    - lc (License Compiler)
    - mage (Manifest Generation and Editing Tool)
    - mgmtclassgen (Management Strongly Typed Class Generator)
    - mpgo (Managed Profile Guided Optimization Tool)
    - peverify (PEVerify Tool)
    - resgen (Resource File Generator)
    - secannotate (.NET Security Annotator Tool)
    - signtool (Sign Tool)
    - sn (Strong Name Tool)
    - sqlmetal (Code Generation Tool)
    - storeadm (Isolated Storage Tool)
    - tlbexp (Type Library Exporter)
    - tlbimp (Type Library Importer)
    - winmdexp (Windows Runtime Metadata Export Tool)
    - winres (Windows Forms Resource Editor)
    - vstest.console

    .PARAMETER PowerShellHostWorkingDirectory
    Optional parameter to specify the working directory of the PowerShell host where the command should work in

    .EXAMPLE
    Invoke-ContainerizedDotnetSdkCommand -DotnetFrameworkVersion 4.7 -CommandString "msbuild --help"
    Invoke-ContainerizedDotnetSdkCommand -DotnetFrameworkVersion 4.7 -CommandString "dotnet help"
    Invoke-ContainerizedDotnetSdkCommand -DotnetFrameworkVersion 4.7 -CommandString "nuget help"

    #>


    param (
        [Parameter (Mandatory)][string] $DotnetFrameworkVersion,
        [Parameter (Mandatory)][string] $CommandStringBase64,
        [string] $PowerShellHostWorkingDirectory
    )

    if ($Debug) { write-host "DEBUG: .NET Framework version entered: $DotnetFrameworkVersion" }
    if ($Debug) { write-host "DEBUG: Command: $CommandStringBase64" }
    if ($Debug) { write-host "DEBUG: PowerShell host working directory: $PowerShellHostWorkingDirectory" }

    write-host CommandString in Base64
    write-host $CommandStringBase64
    
    # Decoding Base64
    $CommandString = [System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String($CommandStringBase64))
    write-host CommandString decoded
    write-host $CommandString
    

    write-host CommandString after removing escaped quotes
    write-host $CommandString

    switch ($DotnetFrameworkVersion) {
        {$_ -in "4.8", "4.7.2", "4.7.1", "4.7", "4.6.2"} {
            write-host "Executing the following command:"
            
            # Had to enclose $PowerShellHostWorkingDirectory with an expression because of the multi-level quotes
            if ($PowerShellHostWorkingDirectory -eq $null) {
                write-host "docker run --rm mcr.microsoft.com/dotnet/framework/sdk:4.8 $CommandString"
                # Had issues with quotations in the $CommandString when executing docker program
                #Invoke-Expression "docker run --rm mcr.microsoft.com/dotnet/framework/sdk:4.8 $CommandString"
                & docker run --rm mcr.microsoft.com/dotnet/framework/sdk:4.8 $CommandString
            } else {
                write-host "docker run --rm -v '$($PowerShellHostWorkingDirectory):c:/Users/ContainerAdministrator/Documents' -w 'c:/Users/ContainerAdministrator/Documents' mcr.microsoft.com/dotnet/framework/sdk:4.8 $CommandString"
                # Had issues with quotations in the $CommandString when executing docker program
                #Invoke-Expression "docker run --rm -v '$($PowerShellHostWorkingDirectory):c:/Users/ContainerAdministrator/Documents' -w 'c:/Users/ContainerAdministrator/Documents' mcr.microsoft.com/dotnet/framework/sdk:4.8 $CommandString"
                & docker run --rm -v "$PowerShellHostWorkingDirectory:c:/Users/ContainerAdministrator/Documents" -w "c:/Users/ContainerAdministrator/Documents" mcr.microsoft.com/dotnet/framework/sdk:4.8 $CommandString
            }
            
            continue
        }

        {$_ -in "3.5", "3.0", "2.5"} { 
            write-host "Executing the following command:"

            # Had to enclose $PowerShellHostWorkingDirectory with an expression because of the multi-level quotes
            if ($PowerShellHostWorkingDirectory -eq $null) {
                write-host "docker run --rm mcr.microsoft.com/dotnet/framework/sdk:3.5 $CommandString"
                # Had issues with quotations in the $CommandString when executing docker program
                #Invoke-Expression "docker run --rm mcr.microsoft.com/dotnet/framework/sdk:3.5 $CommandString"
                & docker run --rm mcr.microsoft.com/dotnet/framework/sdk:3.5 $CommandString
            } else {
                write-host "docker run --rm -v '$($PowerShellHostWorkingDirectory):c:/Users/ContainerAdministrator/Documents' -w 'c:/Users/ContainerAdministrator/Documents' mcr.microsoft.com/dotnet/framework/sdk:3.5 $CommandString"
                # Had issues with quotations in the $CommandString when executing docker program
                #Invoke-Expression "docker run --rm -v '$($PowerShellHostWorkingDirectory):c:/Users/ContainerAdministrator/Documents' -w 'c:/Users/ContainerAdministrator/Documents' mcr.microsoft.com/dotnet/framework/sdk:3.5 $CommandString"
                & docker run --rm -v "$PowerShellHostWorkingDirectory:c:/Users/ContainerAdministrator/Documents" -w "c:/Users/ContainerAdministrator/Documents" mcr.microsoft.com/dotnet/framework/sdk:3.5 $CommandString
            }
            continue
        }

        default {
            write-error "Not supported .NET Framework version: $DotnetFrameworkVersion"
        }
    }

} # function Invoke-ContainerizedDotnetSdkCommand 

Export-ModuleMember -Function Invoke-ContainerizedDotnetSdkCommand
