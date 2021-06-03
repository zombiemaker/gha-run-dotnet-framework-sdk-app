# GitHub Action For Running .NET Framework SDK Apps

This is a GitHub Action that uses the Docker container images provided by Microsoft that contains .NET Framework SDK.

This action should only be executed on GitHub Action Runners that:
* Use Microsoft Windows Server 20H2
* Have PowerShell Core 7+ installed
* Have Docker Engine v20+ installed
* Network connectivity to https://mcr.microsoft.com

## Parameters

* dotnet-framework-version: target version to build .NET Framework artifacts
  * Required
  * Options:
    * 4.8
    * 4.7.2
    * 4.7.1
    * 4.7
    * 4.6.2
    * 3.5
    * 3.0
    * 2.5
  * Default: 4.8
* command:  command line program and parameters to be executed
  * Required
  * Command options:
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
  * working-directory: working directory on the GitHub Action Runner host where the .NET Framework solution or project file is located after pulling the git repository
    * Required
    * Default: ${{ github.workspace }}



