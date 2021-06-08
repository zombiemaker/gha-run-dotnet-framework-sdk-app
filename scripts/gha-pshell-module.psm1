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
    Specifies the working directory of the PowerShell host where the commands should start in

    The value of this parameter will be used to create a Docker bind mount

    .PARAMETER CommandString
    Specifies executable program name and its parameters contained in the Docker container image to execute.

    If the CommandString has single or double quotes, it should be in PowerShell here-string format and the IsHereString switch should be used.

    If multiple commands should be executed in sequence, the CommandString should be in PowerShell here-string format where each line is a separate command and its parameters AND the IsHereString switch is used.

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
    Indicates the CommandString is in here-string format
    
    This is used in the following situations:
    
    - when the command string contains single and double quotes that make string handling difficult
    - when multiple programs should be executed in sequence

    .PARAMETER IsUnicodeBase64Encoded
    Switch to indicate CommandString is in unicode base64 encoding format

    .PARAMETER Debug
    Switch to activate debug messages

    .PARAMETER Verbose
    Switch to activate verbose messages


    .EXAMPLE
    Invoke-ContainerizedDotnetSdkCommand -DotnetFrameworkVersion 4.8 -CommandString "msbuild --help"
    
    Invoke-ContainerizedDotnetSdkCommand -DotnetFrameworkVersion 4.7 -CommandString "dotnet help"
    
    Invoke-ContainerizedDotnetSdkCommand -DotnetFrameworkVersion 4.7 -CommandString "nuget help"

    .EXAMPLE
    For commands with quotes:

    $commands = @'
    msbuild -p:DemoProperty1="This is a wonderful parameter" sample-solution.sln
    '@
    Invoke-ContainerizedDotnetSdkCommand -DotnetFrameworkVersion 4.8 -CommandString $commands -IsHereString

    .EXAMPLE
    For multiple commands:

    $commands = @'
    nuget restore
    msbuild -p:DemoProperty1="This is a wonderful parameter" sample-solution.sln
    '@
    Invoke-ContainerizedDotnetSdkCommand -DotnetFrameworkVersion 4.8 -CommandString $commands -IsHereString


    #>


    param (
        [Parameter (Mandatory=$true)][string] $DotnetFrameworkVersion,
        [Parameter (Mandatory=$false)][string] $PowerShellHostWorkingDirectory = ".\",
        [Parameter (Mandatory=$true)][string] $CommandString,
        [switch] $IsHereString,
        [switch] $IsUnicodeBase64Encoded
    )

    write-debug "DEBUGGING IS ACTIVE"
    write-debug "DEBUG: .NET Framework version entered: $DotnetFrameworkVersion"
    write-debug "DEBUG: PowerShell host working directory: $PowerShellHostWorkingDirectory"
    write-debug "DEBUG: IsHereString: $IsHereString"
    write-debug "DEBUG: IsUnicodeBase64Encoded: $IsUnicodeBase64Encoded"
    write-debug "DEBUG: Command: $CommandString"

    # Convert here-string to an array to extract commands
    if ($IsHereString) {
        write-verbose "Command string is in here string format"
        
        # Not working
        # $CommandStringArray = $CommandString.Split("\r?\n",[System.StringSplitOptions]::RemoveEmptyEntries)
        $CommandStringArray = $CommandString -split '\r?\n'

        write-verbose "Number of command lines: $($CommandStringArray.Count)" 
        for ($i = 0; $i -lt $CommandStringArray.Count; $i++) {
            write-verbose "Command line [$i]: $($CommandStringArray[$i])"
        }
    }

    # Decode string 
    if ($IsUnicodeBase64Encoded) {
        write-verbose "Command string is in unicode base64 format"
        import module base64 -force
        $CommandString = ConvertFrom-Base64String($CommandString)
        write-verbose "Decoded command string"
        write-verbose $CommandString
    }

    switch ($DotnetFrameworkVersion) {
        {$_ -in "4.8", "4.7.2", "4.7.1", "4.7", "4.6.2"} {
            write-verbose "Executing the following command:"
            
            # Had to enclose $PowerShellHostWorkingDirectory with an expression because of the multi-level quotes
            if ($PowerShellHostWorkingDirectory -eq $null) {
                write-verbose "docker run --rm mcr.microsoft.com/dotnet/framework/sdk:4.8 powershell -Command $CommandString"
                docker run --rm mcr.microsoft.com/dotnet/framework/sdk:4.8 $CommandString
            } else {
                
                # Using "docker run ... -v" is different from using "docker run ... --mount"
                # Get error: docker: Error response from daemon: Unrecognised volume spec: invalid volume specification: '/Users/ContainerAdministrator/Documents'
                # write-host "docker run --rm -v $PowerShellHostWorkingDirectory:c:/Users/ContainerAdministrator/Documents -w `"c:\Users\ContainerAdministrator\Documents`" mcr.microsoft.com/dotnet/framework/sdk:4.8 $CommandString"
                # & docker run --rm -v $PowerShellHostWorkingDirectory:c:/Users/ContainerAdministrator/Documents -w "c:\Users\ContainerAdministrator\Documents" mcr.microsoft.com/dotnet/framework/sdk:4.8 $CommandString
                
                # Bind mounts directory contents are not accessible to programs within the container image if called directly
                # Example of incorrect way
                # write-host "docker run --rm --mount type=bind,source=`"$PowerShellHostWorkingDirectory`",target=`"c:/users/containeradministrator/documents`" -w `"c:\Users\ContainerAdministrator\Documents`" mcr.microsoft.com/dotnet/framework/sdk:4.8 $CommandString"
                # & docker run --rm --mount type=bind,source="$PowerShellHostWorkingDirectory",target="c:/users/containeradministrator/documents" -w "c:\Users\ContainerAdministrator\Documents" mcr.microsoft.com/dotnet/framework/sdk:4.8 $CommandString
                
                # Tried using powershell shell in the containerized process
                # Seem to need to call the command using "powershell -Command <command>" format in order for the bind mount to be available
                # write-host "docker run --rm --mount type=bind,source=`"$PowerShellHostWorkingDirectory`",target=`"c:\Users\ContainerAdministrator\Documents`" -w `"c:\Users\ContainerAdministrator\Documents`" mcr.microsoft.com/dotnet/framework/sdk:4.8 powershell -Command { & $CommandString }"
                # & docker run --rm --mount type=bind,source="$PowerShellHostWorkingDirectory",target="c:\users\containeradministrator\documents" -w "c:\Users\ContainerAdministrator\Documents" mcr.microsoft.com/dotnet/framework/sdk:4.8 powershell -Command { & $CommandString}
                
                # Used CMD shell in containerized process instead
                # CMD shell avoids complication of powershell parsing and quote handling
                # Seems to be no difference in using the call operator (&)
                # write-host "& docker run --rm --mount type=bind,source=`"$PowerShellHostWorkingDirectory`",target=`"c:\users\containeradministrator\documents`" -w `"c:\Users\ContainerAdministrator\Documents`" mcr.microsoft.com/dotnet/framework/sdk:4.8 cmd /s /c $CommandString"
                # & docker run --rm --mount type=bind,source=`"$PowerShellHostWorkingDirectory`",target=`"c:\users\containeradministrator\documents`" -w `"c:\Users\ContainerAdministrator\Documents`" mcr.microsoft.com/dotnet/framework/sdk:4.8 cmd /s /c $CommandString
                # write-host "docker run --rm --mount type=bind,source=`"$PowerShellHostWorkingDirectory`",target=`"c:\users\containeradministrator\documents`" -w `"c:\Users\ContainerAdministrator\Documents`" mcr.microsoft.com/dotnet/framework/sdk:4.8 cmd /s /c $CommandString"
                # docker run --rm --mount type=bind,source=`"$PowerShellHostWorkingDirectory`",target=`"c:\users\containeradministrator\documents`" -w `"c:\Users\ContainerAdministrator\Documents`" mcr.microsoft.com/dotnet/framework/sdk:4.8 cmd /s /c $CommandString

                # Multi-command
                for ($i = 0; $i -lt $CommandStringArray.Count; $i++) {
                    write-verbose "Command line [$i]: $($CommandStringArray[$i])"
                    $CommandString=$CommandStringArray[$i]

                    # If first command line, create the container
                    if ($i -eq 0) {
                        # Start container
                        # the -t and -d options are to keep the container running
                        write-host "Starting container"
                        write-verbose "docker run -t -d --cidfile .\cid.txt --mount type=bind,source=`"$PowerShellHostWorkingDirectory`",target=`"c:\users\containeradministrator\documents`" -w `"c:\Users\ContainerAdministrator\Documents`" mcr.microsoft.com/dotnet/framework/sdk:4.8 cmd /s /c" 
                        docker run -t -d --cidfile .\cid.txt --mount type=bind,source=`"$PowerShellHostWorkingDirectory`",target=`"c:\users\containeradministrator\documents`" -w `"c:\Users\ContainerAdministrator\Documents`" mcr.microsoft.com/dotnet/framework/sdk:4.8 cmd
                        $ContainerId = (get-content -Path .\cid.txt -TotalCount 1)
                        write-host "Container ID: $ContainerId"

                        # Run first command
                        write-host "Executing command line [$i]"
                        write-verbose "docker exec -t -w `"c:\Users\ContainerAdministrator\Documents`" $ContainerId cmd /s /c $CommandString"
                        docker exec -t -w `"c:\Users\ContainerAdministrator\Documents`" $ContainerId cmd /s /c $CommandString
                    } else {
                        # Run any commands after the first command
                        write-host "Executing command line [$i]"
                        write-verbose "docker exec -t -w `"c:\Users\ContainerAdministrator\Documents`" $ContainerId cmd /s /c $CommandString"
                        docker exec -t -w `"c:\Users\ContainerAdministrator\Documents`" $ContainerId cmd /s /c $CommandString
                    }
                }

                # Remove container
                write-host "Removing container $ContainerId"
                docker rm --force $ContainerId
                del .\cid.txt
            }
            
            continue
        }

        {$_ -in "3.5", "3.0", "2.5"} { 
            write-verbose "Executing the following command:"

            # Had to enclose $PowerShellHostWorkingDirectory with an expression because of the multi-level quotes
            if ($PowerShellHostWorkingDirectory -eq $null) {
                write-verbose "docker run --rm mcr.microsoft.com/dotnet/framework/sdk:3.5 $CommandString"
                docker run --rm mcr.microsoft.com/dotnet/framework/sdk:3.5 $CommandString
            } else {
                # Multi-command
                for ($i = 0; $i -lt $CommandStringArray.Count; $i++) {
                    write-verbose "Command line [$i]: $($CommandStringArray[$i])"
                    $CommandString=$CommandStringArray[$i]

                    # If first command line, create the container
                    if ($i -eq 0) {
                        # Start container
                        # the -t and -d options are to keep the container running
                        write-host "Starting container"
                        write-verbose "docker run -t -d --cidfile .\cid.txt --mount type=bind,source=`"$PowerShellHostWorkingDirectory`",target=`"c:\users\containeradministrator\documents`" -w `"c:\Users\ContainerAdministrator\Documents`" mcr.microsoft.com/dotnet/framework/sdk:3.5 cmd /s /c" 
                        docker run -t -d --cidfile .\cid.txt --mount type=bind,source=`"$PowerShellHostWorkingDirectory`",target=`"c:\users\containeradministrator\documents`" -w `"c:\Users\ContainerAdministrator\Documents`" mcr.microsoft.com/dotnet/framework/sdk:3.5 cmd
                        $ContainerId = (get-content -Path .\cid.txt -TotalCount 1)
                        write-host "Container ID: $ContainerId"

                        # Run first command
                        write-host "Executing command line [$i]"
                        write-verbose "docker exec -t -w `"c:\Users\ContainerAdministrator\Documents`" $ContainerId cmd /s /c $CommandString"
                        docker exec -t -w `"c:\Users\ContainerAdministrator\Documents`" $ContainerId cmd /s /c $CommandString
                    } else {
                        # Run any commands after the first command
                        write-host "Executing command line [$i]"
                        write-verbose "docker exec -t -w `"c:\Users\ContainerAdministrator\Documents`" $ContainerId cmd /s /c $CommandString"
                        docker exec -t -w `"c:\Users\ContainerAdministrator\Documents`" $ContainerId cmd /s /c $CommandString
                    }
                }

                # Change file permissions so that operations outside of the container can access files / artifacts
                # Files created inside a container uses the user ID ContainerAdministrator
                write-host "Changing file and directory permissions of all content in working directory"
                icacls *.* /grant *:F /t

                # Remove container
                write-host "Removing container $ContainerId"
                docker rm --force $ContainerId
                del .\cid.txt
            }
            continue
        }

        default {
            write-error "Not supported .NET Framework version: $DotnetFrameworkVersion"
        }
    }

} # function Invoke-ContainerizedDotnetSdkCommand 

Export-ModuleMember -Function Invoke-ContainerizedDotnetSdkCommand
