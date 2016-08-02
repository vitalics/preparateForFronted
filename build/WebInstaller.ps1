[string] $scriptDir = Split-Path $script:MyInvocation.MyCommand.Path;

function Web-Installer
{
    [CmdletBinding(SupportsShouldProcess = $true)]
    [Alias()]

    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$false,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        $downloadURI,

        # Param2 help description
        [Parameter(Mandatory=$false,
                   ValueFromPipelineByPropertyName=$true,
                   Position=1)]
        [string]$NameOfProgram,

        [switch] $isVSInstall,
        [switch] $isVScode,

        [switch] $full
    )

    Begin
    {
        $start_time = Get-Date;
        if ([string]::IsNullOrEmpty($downloadURI))
        {
            $downloadURI = $visualStudioURI;
        }
        if (-not (test-path "$scriptDir"))
        {
            New-Item -Path "$scriptDir" -Name downloads -ItemType Directory;
        }

        $visualStudioURI = 'http://download.microsoft.com/download/D/2/3/D23F4D0F-BA2D-4600-8725-6CCECEA05196/vs_community_ENU.exe';
        $VsCode = 'https://az764295.vo.msecnd.net/stable/e6b4afa53e9c0f54edef1673de9001e9f0f547ae/VSCodeSetup-stable.exe';
        $ruby = 'http://dl.bintray.com/oneclick/rubyinstaller/rubyinstaller-2.3.1.exe';
        $node = 'https://nodejs.org/dist/v4.4.7/node-v4.4.7-x86.msi';
        $python = 'https://www.python.org/ftp/python/2.7.12/python-2.7.12.msi';
        $typescript = 'https://download.microsoft.com/download/6/D/8/6D8381B0-03C1-4BD2-AE65-30FF0A4C62DA/TS1.8.6-TS-release-1.8-nightly.20160229.1/TypeScript_Dev14Full.exe';
    }
    Process
    {
        if ($isVSInstall)
        {
            if ($PSCmdlet.ShouldContinue("Install $NameOfProgram ?","Web install manager"))
            {
                Invoke-WebRequest -Uri $visualStudioURI -OutFile "$scriptDir\downloads\$NameOfProgram";
            }
        }

        if ($isVScode)
        {
            if ($PSCmdlet.ShouldContinue("Install $NameOfProgram ?","Web install manager"))
            {
                Invoke-WebRequest -Uri $VsCode -OutFile "$scriptDir\downloads\$NameOfProgram";
            }
        }

        
        if ($full)
        {
            if ($PSCmdlet.ShouldContinue("Install full progams?","Web install manager"))
            {
                Invoke-WebRequest -Uri $visualStudioURI -OutFile "$scriptDir\VisualStudio community.exe";
                Invoke-WebRequest -Uri $VsCode -OutFile "$scriptDir\vscode-stable.exe";
                Invoke-WebRequest -Uri $ruby -OutFile "$scriptDir\rubyinstaller-2.2.4.exe";
                Invoke-WebRequest -Uri $Node -OutFile "$scriptDir\node-v4.4.7-x86.msi";
                Invoke-WebRequest -Uri $Python -OutFile "$scriptDir\python-2.7.11.msi"
                Invoke-WebRequest -Uri $Python -OutFile "$scriptDir\TypeScript_Dev14Full.exe";;
            }
        }

        else
        {
            Invoke-WebRequest -Uri $downloadURI -OutFile "$scriptDir\downloads\$NameOfProgram"
        }
         
    }
    End
    {
        Write-Output "Time taken: $((Get-Date).Subtract($start_time).Seconds) second(s) for install programs";
        
    }
}
Web-Installer -full
read-host "Press any key"
