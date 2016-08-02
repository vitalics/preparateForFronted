[string] $scriptDir = Split-Path $script:MyInvocation.MyCommand.Path;
Set-Location $scriptDir;

[string]$programFiles;
[string]$programFilesx86;

if ([environment]::Is64BitOperatingSystem) {
    $programFilesx86 = "Program Files (x86)";
    $programFiles = "Program Files";
}
else
{
    $programFilesx86 ="Program Files";
    $programFiles = "Program Files";
}

[string] $VSInstalled = "C:\$programFilesx86\Microsoft Visual Studio 14.0\Common7\IDE\"
[bool] $isVSInstalled = Test-Path $VSInstalled  -Filter .exe;

if (-not $isVSInstalled) 
{
    $VSInstalled = "C:\$programFilesx86\Microsoft Visual Studio 15.0\Common7\IDE\"
    $isVSInstalled = Test-Path $VSInstalled -Filter .exe;
    Write-host "$isVSInstalled"
}

[string] $NodeInstalled = "C:\$programFiles\nodejs\";
[bool] $isNodeInstalled = Test-Path $NodeInstalled -Filter .exe;



[string] $RubyInstalled = "C:\Ruby22\bin";
[bool] $isRubyInstalled = Test-Path $RubyInstalled;


[string] $PythonInstalled = "C:\Python27";
[bool] $isPythonInstalled = Test-Path $PythonInstalled;

[string] $typescriptFolder = "C:\$programFilesx86\Microsoft SDKs\TypeScript\1.8\";


[bool] $isTypescriptFolder = Test-Path $typescriptFolder;

$arguments= ' /qn /l*v .\installers.txt';


function Check-Install-Programs
{
    [CmdletBinding(SupportsShouldProcess = $true)]
    [Alias()]
    Param
    (
        [Parameter(Mandatory=$true,
                   Position=0)]
        [string]$PathToProgram,

        # Param2 help description
        [Parameter(Mandatory=$true,
                   Position=1)]
        $pathToInstalledProgram,

                [Parameter(Mandatory=$true,
                   Position=2)]
        [string]$NameOfProgram
    )

    Begin
    {
        if (-not((Test-Path $PathToProgram) -and (Test-Path "$scriptDir\$pathToInstalledProgram")))
        {
            return "error with path"  
        }
    }
    Process
    {
        if(-not (test-path $PathToProgram)){
            if ($PSCmdlet.ShouldContinue("You dont have $NameOfProgram, install it?",'Installer manager'))
            {
                try{
                    Start-Process -FilePath $pathToInstalledProgram|Resolve-Path -Relative
                    -arg $arguments
                    -passthru | wait-process;
                }
                catch [System.InvalidOperationException]{
                    Write-Host "You canceled installer";
                } 
            }
            else{
              return "You canceled installer program"  
            }
        }
    }
    End
    {
        Write-host "$NameOfProgram installed"
        Write-host "-------------------------------------"
    }
}

function Path-Checker
{
    [CmdletBinding(SupportsShouldProcess = $true)]
    [Alias()]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        $PathToFolder,

        # Param2 help description
        [string]
        $NameOfProgram
    )

    Begin
    {
    $semicolon = ";";

    $PathToFolder += $semicolon;

    }
    Process
    {
    
        if ($ENV:PATH | Select-String -SimpleMatch $PathToFolder)
        {
            Return "Folder with $NameOfProgram already within PATH";
        }
        else{
            if ($PSCmdlet.ShouldContinue("install $NameOfProgram to PATH?","PATH Manager"))
            {
                [Environment]::SetEnvironmentVariable("Path",$env:Path + $PathToFolder);
            }
            else{
                return "You canceled $NameOfProgram"
            }
        }
    }
    End
    {
        Write-host "-------------------------------------"
    }
}

function Cli-installers
{
    [CmdletBinding(SupportsShouldProcess = $true)]
    Param
    ()

    Process
    {
    if($PSCmdlet.ShouldContinue("Do you want install gulp?","NPM manager")){
            npm install --global gulp-cli
        }

        if($PSCmdlet.ShouldContinue("Do you want install typescript?","NPM manager")){
            npm install typescript -g
        }


        if($PSCmdlet.ShouldContinue("Do you want install sass?","Gem manager")){
            gem install sass
        }
    }
    End
    {
        Write-host "-------------------------------------"
    }
}


function Main
{
    [CmdletBinding(SupportsShouldProcess = $true)]
    [Alias('p1')]
    Param
    (
    )

    Begin
    {
    }
    Process
    {

        if ($PSCmdlet.ShouldContinue("Do you want to start web isntaller", 'web installer'))
        {
            Start-Process .\WebInstaller.ps1 -Wait
        }
        

        Check-Install-Programs -PathToProgram $VSInstalled -pathToInstalledProgram 'VisualStudio community.exe' -NameOfProgram "Visual Studio"

        Check-Install-Programs -PathToProgram $NodeInstalled -pathToInstalledProgram 'node-v4.4.7-x86.msi'-NameOfProgram "Node.js"

        Check-Install-Programs -PathToProgram $PythonInstalled -pathToInstalledProgram 'python-2.7.12.msi'-NameOfProgram "Python"

        Check-Install-Programs -PathToProgram $RubyInstalled -pathToInstalledProgram 'rubyinstaller-2.2.4.exe'-NameOfProgram "Ruby"

        Check-Install-Programs -PathToProgram $typescriptFolder -pathToInstalledProgram 'TypeScript_Dev14Full.exe'-NameOfProgram "Typescript"

        Cli-installers

        Path-Checker -PathToFolder $RubyInstalled -NameOfProgram 'ruby'
        Path-Checker -PathToFolder $typescriptFolder -NameOfProgram 'typescript'
    }
    End
    {
        Write-host "-------------------------------------"
    }
}

Main

Write-Host "Now start next script in your path with project";
read-host "Press any key";
