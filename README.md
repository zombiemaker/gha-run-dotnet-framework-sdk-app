# GitHub Action For Running .NET Framework SDK Apps

This GitHub Action runs programs included in the Docker [container images provided by Microsoft that contains .NET Framework SDKs](https://hub.docker.com/_/microsoft-dotnet-framework-sdk/).  It enables GitHub Runner server machines to run different versions of .NET Framework build programs and libraries without having to install them on the GitHub Runner machines.

.NET Framework versions supported are:

* 4.8
* 4.7.2
* 4.7.1
* 4.7
* 4.6.2
* 3.5
* 3.0
* 2.5

This action should only be executed on GitHub Action Runners that:

* Use Microsoft Windows Server 20H2
* Have PowerShell Core 7+ installed
* Have Docker Engine v20+ installed
* Network connectivity to https://mcr.microsoft.com

## Parameters

* dotnet-framework-version
  * Target version to build .NET Framework artifacts
  * Required
  * Supported options:
    * 4.8
    * 4.7.2
    * 4.7.1
    * 4.7
    * 4.6.2
    * 3.5
    * 3.0
    * 2.5
  * Default: 4.8
* command
  * Command line program and parameters to be executed
  * Required
  * Supported commands:
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
  * Default: ""
* working-directory
  * Working directory on the GitHub Action Runner host where the .NET Framework solution or project file is located after pulling the git repository
  * Required
  * Default: ${{ github.workspace }}