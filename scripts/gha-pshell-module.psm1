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

    .PARAMETER PowerShellHostWorkingDirectory
    Optional parameter to specify the working directory of the PowerShell host where the command should work in

    .PARAMETER CommandString
    In PowerShell here string format, the name of the executable program and its parameters contained in the Docker container image to execute.

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

    .PARAMETER IsHereString
    Switch to indicate CommandString is in here string format
    
    This is used when the command string can contain single and double quotes that make string handling difficult.

    .PARAMETER IsUnicodeBase64Encoded
    Switch to indicate CommandString is in unicode base64 encoding format

    
    .EXAMPLE
    Invoke-ContainerizedDotnetSdkCommand -DotnetFrameworkVersion 4.7 -CommandString "msbuild --help"
    Invoke-ContainerizedDotnetSdkCommand -DotnetFrameworkVersion 4.7 -CommandString "dotnet help"
    Invoke-ContainerizedDotnetSdkCommand -DotnetFrameworkVersion 4.7 -CommandString "nuget help"

    #>


    param (
        [Parameter (Mandatory=$true)][string] $DotnetFrameworkVersion,
        [Parameter (Mandatory=$false)][string] $PowerShellHostWorkingDirectory,
        [Parameter (Mandatory=$true)][string] $CommandString,
        [switch] $IsHereString,
        [switch] $IsUnicodeBase64Encoded
    )

    write-debug "DEBUGGING IS ACTIVE"

    # if ($Debug) { write-debug "DEBUG: .NET Framework version entered: $DotnetFrameworkVersion" }
    # if ($Debug) { write-debug "DEBUG: PowerShell host working directory: $PowerShellHostWorkingDirectory" }
    # if ($Debug) { write-debug "DEBUG: IsHereString: $IsHereString" }
    # if ($Debug) { write-debug "DEBUG: IsUnicodeBase64Encoded: $IsUnicodeBase64Encoded" }
    # if ($Debug) { write-debug "DEBUG: Command: $CommandString" }
    write-debug "DEBUG: .NET Framework version entered: $DotnetFrameworkVersion"
    write-debug "DEBUG: PowerShell host working directory: $PowerShellHostWorkingDirectory"
    write-debug "DEBUG: IsHereString: $IsHereString"
    write-debug "DEBUG: IsUnicodeBase64Encoded: $IsUnicodeBase64Encoded"
    write-debug "DEBUG: Command: $CommandString"

    # Convert here string to an array to extract the first line
    if ($IsHereString) {
        write-host Command string is in here string format
        $CommandString = $CommandString.Split(@(“n", "n`r”), [StringSplitOptions]::None)[0]
        write-host Extracted command string
        write-host $CommandString
    }

    # Decode string 
    if ($IsUnicodeBase64Encoded) {
        write-host Command string is in unicode base64 format
        import module base64 -force
        $CommandString = ConvertFrom-Base64String($CommandString)
        write-host Decoded command string
        write-host $CommandString
    }

    switch ($DotnetFrameworkVersion) {
        {$_ -in "4.8", "4.7.2", "4.7.1", "4.7", "4.6.2"} {
            write-host "Executing the following command:"
            
            # Had to enclose $PowerShellHostWorkingDirectory with an expression because of the multi-level quotes
            if ($PowerShellHostWorkingDirectory -eq $null) {
                write-host "docker run --rm mcr.microsoft.com/dotnet/framework/sdk:4.8 powershell -Command $CommandString"
                # Had issues with quotations in the $CommandString when executing docker program
                #Invoke-Expression "docker run --rm mcr.microsoft.com/dotnet/framework/sdk:4.8 $CommandString"
                & docker run --rm mcr.microsoft.com/dotnet/framework/sdk:4.8 $CommandString
            } else {
                # Had issues with quotations in the $CommandString when executing docker program
                # Invoke-Expression "docker run --rm -v '$($PowerShellHostWorkingDirectory):c:/Users/ContainerAdministrator/Documents' -w 'c:/Users/ContainerAdministrator/Documents' mcr.microsoft.com/dotnet/framework/sdk:3.5 $CommandString"
                
                # Using "docker run ... -v" is different from using "docker run ... --mount"
                # Get error: docker: Error response from daemon: Unrecognised volume spec: invalid volume specification: '/Users/ContainerAdministrator/Documents'
                # write-host "docker run --rm -v $PowerShellHostWorkingDirectory:c:/Users/ContainerAdministrator/Documents -w `"c:\Users\ContainerAdministrator\Documents`" mcr.microsoft.com/dotnet/framework/sdk:4.8 $CommandString"
                # & docker run --rm -v $PowerShellHostWorkingDirectory:c:/Users/ContainerAdministrator/Documents -w "c:\Users\ContainerAdministrator\Documents" mcr.microsoft.com/dotnet/framework/sdk:4.8 $CommandString
                
                # Bind mounts directory contents are not accessible to programs within the container image if called directly
                # Example of incorrect way
                # write-host "docker run --rm --mount type=bind,source=`"$PowerShellHostWorkingDirectory`",target=`"c:/users/containeradministrator/documents`" -w `"c:\Users\ContainerAdministrator\Documents`" mcr.microsoft.com/dotnet/framework/sdk:4.8 $CommandString"
                # & docker run --rm --mount type=bind,source="$PowerShellHostWorkingDirectory",target="c:/users/containeradministrator/documents" -w "c:\Users\ContainerAdministrator\Documents" mcr.microsoft.com/dotnet/framework/sdk:4.8 $CommandString
                
                # Tried using powershell shell
                # Seem to need to call the command using "powershell -Command <command>" format in order for the bind mount to be available
                # write-host "docker run --rm --mount type=bind,source=`"$PowerShellHostWorkingDirectory`",target=`"c:\Users\ContainerAdministrator\Documents`" -w `"c:\Users\ContainerAdministrator\Documents`" mcr.microsoft.com/dotnet/framework/sdk:4.8 powershell -Command { & $CommandString }"
                # & docker run --rm --mount type=bind,source="$PowerShellHostWorkingDirectory",target="c:\users\containeradministrator\documents" -w "c:\Users\ContainerAdministrator\Documents" mcr.microsoft.com/dotnet/framework/sdk:4.8 powershell -Command { & $CommandString}
                
                # Tried using CMD shell
                # Got error when $CommandString contained single quotes
                # write-host "docker run --rm --mount type=bind,source=`"$PowerShellHostWorkingDirectory`",target=`"c:\Users\ContainerAdministrator\Documents`" -w `"c:\Users\ContainerAdministrator\Documents`" mcr.microsoft.com/dotnet/framework/sdk:4.8 cmd /s /c $CommandString"
                & docker run --rm --mount type=bind,source=`"$PowerShellHostWorkingDirectory`",target=`"c:\users\containeradministrator\documents`" -w `"c:\Users\ContainerAdministrator\Documents`" mcr.microsoft.com/dotnet/framework/sdk:4.8 cmd /s /c $CommandString
                
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
                write-host "docker run --rm -v `"$PowerShellHostWorkingDirectory:c:/Users/ContainerAdministrator/Documents`" -w `"c:\Users\ContainerAdministrator\Documents`" mcr.microsoft.com/dotnet/framework/sdk:3.5 $CommandString"
                # Had issues with quotations in the $CommandString when executing docker program
                #Invoke-Expression "docker run --rm -v '$($PowerShellHostWorkingDirectory):c:/Users/ContainerAdministrator/Documents' -w 'c:/Users/ContainerAdministrator/Documents' mcr.microsoft.com/dotnet/framework/sdk:3.5 $CommandString"
                & docker run --rm -v "$PowerShellHostWorkingDirectory:c:/Users/ContainerAdministrator/Documents" -w "c:\Users\ContainerAdministrator\Documents" mcr.microsoft.com/dotnet/framework/sdk:3.5 $CommandString
            }
            continue
        }

        default {
            write-error "Not supported .NET Framework version: $DotnetFrameworkVersion"
        }
    }

} # function Invoke-ContainerizedDotnetSdkCommand 

Export-ModuleMember -Function Invoke-ContainerizedDotnetSdkCommand
