
Set-ExecutionPolicy Unrestricted;

[string] $scriptDir = Split-Path $script:MyInvocation.MyCommand.Path;
Set-Location $scriptDir;

[string]$programFiles;
if ([environment]::Is64BitOperatingSystem) {
    $programFilesx86 = "Program Files (x86)";
    $programFiles = "Program Files";
}
else
{
    $programFilesx86 ="Program Files";
    $programFiles = "Program Files";
}

[bool] $isVSInstalled = Test-Path "C:\$programFilesx86\Microsoft Visual Studio 14.0\Common7\IDE\" -Filter .exe;

[bool] $isNodeInstalled = Test-Path "C:\$programFiles\nodejs\" -Filter .exe;

[bool] $isRuby32Installed = Test-Path "C:\Ruby22-x64\";

[bool] $isRuby64Installed = Test-Path "C:\Ruby22\";

[bool] $isPythonInstalled = Test-Path "C:\Python27";

[string] $typescriptFolder = "C:\$programFilesx86\Microsoft SDKs\TypeScript\1.8\";

$ENV:PATH | Select-String -SimpleMatch $typescriptFolder;

[bool] $isTypescriptFolder = Test-Path $typescriptFolder;

$arguments= ' /qn /l*v .\installers.txt';

if(-not $isVSInstalled){
    Write-Host "You don't have visual Studio 2015.Do you want install it (Y/N)";
    $installCommand = Read-Host "Y/N";
    if((($installCommand -eq "Y") -or ($installCommand -eq"y" ))){
        try{
            Start-Process -FilePath VS2015.1.exe|Resolve-Path -Relative -WindowStyle Hidden;
        }
        catch [System.InvalidOperationException]{
            Write-Host "You canceled Visual Studio installer";
        }
    }
    else{
        Write-Host "Check me later";
        return;
    }
}

Write-Host "OK VS";

if(-not $isNodeInstalled){
    Write-Host "You don't have Node.js.Do you want install it (Y/N)"
    $installCommand = Read-Host "Y/N";
    if((($installCommand -eq "Y") -or ($installCommand -eq"y" ))){
        try{
            Start-Process -FilePath node-v4.4.7-x86.msi|Resolve-Path -Relative
            -arg $arguments
            -passthru | wait-process;
        }
        catch [System.InvalidOperationException]{
            Write-Host "You canceled node.js installer";
        }
    }
    else{
        Write-Host "Check me later";
        return;
    }
}
Write-Host "OK Node.js";

    
    if(-not $isPythonInstalled){
        Write-Host "You don't have Python. do you want installed Python (Y/N)";
        $installCommand = Read-Host "Y/N";
        if(($installCommand -eq "Y") -or ($installCommand -eq"y" )){
            try{
                Start-Process python-2.7.11.msi|Resolve-Path -Relative
                -arg $arguments
                -passthru | wait-process;
            }
            catch [System.InvalidOperationException]{
                Write-Host "You canceled python installer";
            }
    }
    else{
        Write-Host "Check me later";
        return;
    }
}
Write-Host "OK Python";


if((-not $isRuby32Installed) -and (-not $isRuby64Installed)){
    Write-Host "You don't have Ruby.Do you want install it (Y/N)?";
    $installCommand = Read-Host "Y/N";
    if(($installCommand -eq "Y") -or ($installCommand -eq"y" )){
        try{
            Start-Process -FilePath rubyinstaller-2.2.4.exe|Resolve-Path -Relative -WindowStyle Hidden -ArgumentList "\qn \s";
        }
        catch [System.InvalidOperationException]{
            Write-Host "You canceled ruby installer";
        }
    }
    else{
        Write-Host "Check me later";
        return;
    }
}

Write-Host "OK Ruby";

Write-Host "Do you want install gulp?(Y/N)";
$installCommand = Read-Host "Y/N"
if(($installCommand -eq "Y") -or ($installCommand -eq"y" )){
    npm install --global gulp-cli
}

Write-Host "Do you want install sass?(Y/N)"
$installCommand = Read-Host "Y/N"
if(($installCommand -eq "Y") -or ($installCommand -eq"y" )){
       gem install sass
}

Write-Host "Do you want install typescript?(Y/N)"
$installCommand = Read-Host "Y/N"
if(($installCommand -eq "Y") -or ($installCommand -eq"y" )){
    npm install typescript -g
}
<# Adding typescript and ruby in to the path #>

$semicolon = ";";
$typescriptFolder = "C:\$programFiles\Microsoft SDKs\TypeScript\1.8";

$ruby22Folder = 'C:\Ruby22\bin';
$typescript = $semicolon + $typescriptFolder;
$ruby22 = $ruby22Folder + $semicolon;

IF (!(TEST-PATH $typescriptFolder))
{ 
    write-host ‘Folder Does not Exist, Cannot be added to PATH, do you want install it(Y/N)’
    $installCommand = Read-Host "Y/N"
    if(($installCommand -eq "Y") -or ($installCommand -eq"y" )){
        try
        {
            Start-Process -FilePath TypeScript_Dev14Full.exe|Resolve-Path -Relative
        }
        catch [System.InvalidOperationException]
        {
            Write-Host "You canceled installer"
        }   
    }
}
elseif ($ENV:PATH | Select-String -SimpleMatch $typescript)
{
    Return ‘Folder with typescript already within PATH’ 
}
else{
    Write-Host $env:Path;
    [Environment]::SetEnvironmentVariable("Path",$env:Path + $typescript)
    Write-host $env:Path;
}
#checking ruby

if ($ENV:PATH | Select-String -SimpleMatch $ruby22)
{
    Return ‘Folder with ruby already within PATH’ 
}
else{
    Write-Host $env:Path;
    [Environment]::SetEnvironmentVariable("Path",$env:Path + $ruby22)
    Write-host $env:Path;
}

Write-Host "Now start next script in your path with project";

