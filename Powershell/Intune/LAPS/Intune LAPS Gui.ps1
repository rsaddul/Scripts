#leanLAPS GUI, provided AS IS as companion to the leanLAPS script
#Originally written by Colton Lacy https://www.linkedin.com/in/colton-lacy-826599114/

$remediationScriptID = "1904ce4e-deb9-492c-9704-808a0d9ec2ce" #To get this ID, go to graph explorer https://developer.microsoft.com/en-us/graph/graph-explorer and use this query https://graph.microsoft.com/beta/deviceManagement/deviceHealthScripts to get all remediation scripts in your tenant and select your script id
$ErrorActionPreference = "Stop"
$privateKey = "7,2,0,0,0,164,0,0,82,83,65,50,0,8,0,0,1,0,1,0,105,87,187,236,238,172,210,20,99,111,254,19,5,220,72,164,253,36,118,1,174,117,32,24,71,199,60,86,229,104,185,177,136,199,69,221,48,11,218,157,230,179,119,242,30,198,190,32,21,206,51,110,118,3,0,104,71,168,5,59,4,99,77,174,21,124,29,72,249,58,77,224,235,35,79,161,122,64,187,162,44,151,152,146,214,188,250,151,83,239,97,121,63,45,191,79,162,183,133,197,69,228,124,209,212,18,124,32,1,132,228,87,194,173,161,3,122,226,211,45,102,160,34,134,46,247,13,66,63,5,241,118,155,205,19,171,41,192,223,9,59,17,61,97,17,73,85,119,224,244,220,252,70,139,127,186,59,164,52,65,205,77,34,57,221,25,41,36,33,154,94,30,148,2,83,131,19,196,122,236,103,158,128,104,238,196,137,21,162,233,124,241,151,245,57,62,72,74,70,41,56,105,87,122,218,115,238,94,108,110,187,180,83,241,168,253,54,203,174,106,203,177,159,234,200,58,236,197,141,120,230,59,133,149,164,253,51,25,246,162,151,244,255,219,242,212,50,64,164,19,111,223,183,141,124,205,55,150,139,149,68,225,192,137,19,10,222,181,12,5,37,189,136,4,91,56,106,63,121,7,111,82,235,107,255,241,142,92,142,139,220,97,199,187,225,241,226,228,16,6,101,151,108,178,217,130,194,243,74,102,201,80,232,21,123,112,87,253,16,96,102,139,170,161,240,137,205,59,188,108,48,108,29,134,101,114,179,35,83,41,245,227,249,178,150,52,104,6,34,90,110,116,200,85,92,31,23,243,175,253,73,144,76,207,23,197,15,120,133,152,22,85,130,206,170,214,134,81,153,149,110,91,177,212,95,175,57,240,239,148,96,149,133,35,168,39,243,82,157,13,8,208,18,117,159,45,126,24,48,60,33,163,197,10,176,111,32,209,146,241,41,160,205,207,181,124,5,87,20,248,19,57,8,28,128,36,141,192,157,202,173,93,109,45,147,10,233,64,19,75,121,46,67,197,230,248,215,116,126,180,79,222,193,95,246,255,136,219,207,48,221,50,84,9,229,50,88,250,17,63,139,233,34,58,123,151,121,126,14,226,91,9,24,205,139,40,190,45,241,206,247,233,187,210,241,249,78,148,162,145,83,247,159,130,47,52,8,138,233,132,194,205,94,53,225,194,78,221,57,104,89,107,57,54,112,194,181,105,211,159,79,8,233,247,215,88,38,124,43,161,150,210,24,242,132,191,94,138,51,108,125,161,47,169,29,187,230,232,79,140,157,226,132,106,249,3,207,131,243,83,36,248,46,98,182,146,22,51,17,145,198,0,162,6,230,88,252,168,92,38,188,196,111,194,195,17,73,39,40,98,107,114,98,157,207,13,11,43,190,149,80,18,76,137,235,11,233,97,41,108,114,74,182,155,161,54,222,135,153,94,99,66,243,59,128,238,19,146,99,102,219,15,77,23,139,52,9,113,213,38,220,254,167,200,215,7,231,125,13,200,60,184,22,162,75,138,109,175,191,215,165,147,120,10,142,212,135,145,78,112,40,149,185,102,163,45,252,14,252,176,228,215,29,195,78,39,226,195,70,81,74,119,74,160,49,77,142,104,187,170,192,106,205,255,155,87,93,151,235,124,115,182,88,65,152,6,168,42,200,49,246,58,0,167,215,35,144,14,3,8,202,77,198,71,199,14,208,176,139,203,212,88,32,186,220,107,21,229,42,200,48,169,190,82,142,222,28,197,12,106,73,187,189,178,191,161,23,118,97,48,246,105,19,165,37,65,82,112,249,164,186,13,237,58,213,241,69,27,47,233,72,212,222,205,173,38,164,30,187,229,67,196,146,62,255,229,151,120,250,14,66,2,115,236,250,20,191,219,155,193,125,37,143,246,237,62,72,241,23,96,106,3,78,108,46,114,140,240,224,34,205,22,216,109,64,123,234,60,239,160,48,114,219,76,212,71,18,19,136,239,9,200,17,129,37,85,203,252,8,199,72,224,155,60,129,130,17,129,94,168,27,49,199,182,251,70,29,215,211,27,217,253,200,27,242,43,145,193,124,177,110,20,205,26,144,173,12,139,137,177,186,63,45,118,241,87,246,89,101,246,135,87,126,141,194,213,237,62,106,150,60,218,56,90,140,205,36,218,153,120,111,161,250,147,173,211,94,105,75,74,241,231,144,34,142,252,79,76,230,198,195,206,62,72,139,233,41,161,7,105,61,236,177,130,172,152,3,174,177,68,186,124,213,249,255,244,244,159,111,29,52,182,242,208,202,218,80,109,176,201,29,3,122,49,129,238,21,89,3,221,186,227,147,51,64,252,125,131,217,73,166,126,7,105,152,7,129,241,85,166,155,120,194,103,26,173,190,214,50,35,176,59,209,39,85,254,203,147,15,181,93,147,110,191,123,103,33,105,4,21,16,249,107,102,12,172,65,13,61,49,69,235,251,0,46,170,70,162,166,111,213,36,139,49,225,252,126,123,152,41,217,38,195,5,231,21,160,177,211,4,241,5,137,173,201,104,22,28,255,36,59,14,69,226,91,119,20,17,159,158,75,205,111,135,142,33,1,147,132,97,97,5" #if you supply a private key, this will be used to decrypt the password (assuming it was encrypting using your public key, as configured in leanLAPS.ps1

Function ConnectMSGraphModule {

	Try { Import-Module -Name Microsoft.Graph.Intune }
	Catch { 
		write-host Setting up the Microsoft Graph InTune Module...
		Install-Module -Name Microsoft.Graph.InTune -scope CurrentUser -Force
		}
	Finally { $ErrorMessage = $_.Exception.Message }

    If ($ErrorMessage) {
        [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
        [Windows.Forms.MessageBox]::Show("There was an issue setting up Microsoft Graph. Please install the MSGraph InTune Module by running this cmdlet in Powershell as an administrator: Install-Module Microsoft.Graph.InTune", "ERROR", [Windows.Forms.MessageBoxButtons]::OK, [Windows.Forms.MessageBoxIcon]::Information)
    }

    Connect-MSGraph
}
        
function getDeviceInfo {
        
    If($inputBox.Text -ne 'Device Name') {
			
            $outputBox.text =  "Gathering leanLAPS and Device Information for " + $inputBox.text + " - Please wait...."  | Out-String
        
            #Connect to GraphAPI and get leanLAPS for a specific device that was supplied through the GUI
            $graphApiVersion = "beta"
			$deviceInfoURL = [uri]::EscapeUriString("https://graph.microsoft.com/$graphApiVersion/deviceManagement/deviceHealthScripts/$remediationScriptID/deviceRunStates?`$select=postRemediationDetectionScriptOutput&`$filter=managedDevice/deviceName eq '" + $inputBox.text + "'&`$expand=managedDevice(`$select=deviceName,operatingSystem,osVersion,emailAddress)")

            #Get information needed from MSGraph call about the Proactive Remediation Device Status
            $device = $Null
            $deviceStatus = $Null
            $deviceStatuses = (Invoke-MSGraphRequest -Url $deviceInfoURL -HttpMethod Get).value
            foreach($device in $deviceStatuses){
                if($deviceStatus){
                    try{
                        if([DateTime]($device.postRemediationDetectionScriptOutput -Replace(".* changed on ","")) -gt [DateTime]($deviceStatus.postRemediationDetectionScriptOutput -Replace(".* changed on ",""))){
                            $deviceStatus = $device
                        }
                    }catch{$Null}
                }else{
                    $deviceStatus = $device
                }
            }

            $LocalAdminUsername = $deviceStatus.postRemediationDetectionScriptOutput -replace ".* for " -replace ", last changed on.*"
            $deviceName = $deviceStatus.managedDevice.deviceName
            $userSignedIn = $deviceStatus.managedDevice.emailAddress
            $deviceOS = $deviceStatus.managedDevice.operatingSystem
            $deviceOSVersion = $deviceStatus.managedDevice.osVersion
            $laps = $deviceStatus.postRemediationDetectionScriptOutput -replace ".*LeanLAPS current password: " -replace " for $LocalAdminUsername, last changed on.*"
			$lastChanged = $deviceStatus.postRemediationDetectionScriptOutput -replace ".* for $LocalAdminUsername, last changed on "
        
            # Adding properties to object
            $deviceInfoDisplay = New-Object PSCustomObject
        
            # Add collected properties to object
            $deviceInfoDisplay | Add-Member -MemberType NoteProperty -Name "Local Username" -Value (".\" + $LocalAdminUsername)
            if($privateKey.Length -lt 5){
                $deviceInfoDisplay | Add-Member -MemberType NoteProperty -Name "Password" -Value $laps
            }else{
                $rsa = New-Object System.Security.Cryptography.RSACryptoServiceProvider
                $rsa.ImportCspBlob([byte[]]($privateKey -split ","))
                $decrypted = $rsa.Decrypt([byte[]]($laps -split " "), $false)
                $deviceInfoDisplay | Add-Member -MemberType NoteProperty -Name "Password" -Value ([System.Text.Encoding]::UTF8.GetString($decrypted))
            }
			$deviceInfoDisplay | Add-Member -MemberType NoteProperty -Name "Password Changed" -Value $lastChanged
            $deviceInfoDisplay | Add-Member -MemberType NoteProperty -Name "Device Name" -Value $deviceName
            $deviceInfoDisplay | Add-Member -MemberType NoteProperty -Name "User" -Value $userSignedIn
            $deviceInfoDisplay | Add-Member -MemberType NoteProperty -Name "Device OS" -Value $deviceOS
            $deviceInfoDisplay | Add-Member -MemberType NoteProperty -Name "OS Version" -Value $deviceOSVersion
        
            If($deviceInfoDisplay.Password) {
                $outputBox.text = ($deviceInfoDisplay | Out-String).Trim()
            } Else {
                $outputBox.text="Failed to gather information. Please check the device name."
            }
        } Else {
            $outputBox.text="Device name has not been provided. Please type a device name and then click `"Device Info`""
    }
}

function Set-WindowStyle {
<#
.SYNOPSIS
    To control the behavior of a window
.DESCRIPTION
    To control the behavior of a window
.PARAMETER Style
    Describe parameter -Style.
.PARAMETER MainWindowHandle
    Describe parameter -MainWindowHandle.
.EXAMPLE
    (Get-Process -Name notepad).MainWindowHandle | foreach { Set-WindowStyle MAXIMIZE $_ }
#>

    [CmdletBinding(ConfirmImpact='Low')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions','')]
    param(
        [ValidateSet('FORCEMINIMIZE', 'HIDE', 'MAXIMIZE', 'MINIMIZE', 'RESTORE',
                    'SHOW', 'SHOWDEFAULT', 'SHOWMAXIMIZED', 'SHOWMINIMIZED',
                    'SHOWMINNOACTIVE', 'SHOWNA', 'SHOWNOACTIVATE', 'SHOWNORMAL')]
        [string] $Style = 'SHOW',

        $MainWindowHandle = (Get-Process -Id $pid).MainWindowHandle
    )

    begin {
        Write-Verbose -Message "Starting [$($MyInvocation.Mycommand)]"

        $WindowStates = @{
            FORCEMINIMIZE   = 11; HIDE            = 0
            MAXIMIZE        = 3;  MINIMIZE        = 6
            RESTORE         = 9;  SHOW            = 5
            SHOWDEFAULT     = 10; SHOWMAXIMIZED   = 3
            SHOWMINIMIZED   = 2;  SHOWMINNOACTIVE = 7
            SHOWNA          = 8;  SHOWNOACTIVATE  = 4
            SHOWNORMAL      = 1
        }
    }

    process {
        Write-Verbose -Message ('Set Window Style {1} on handle {0}' -f $MainWindowHandle, $($WindowStates[$style]))

        $Win32ShowWindowAsync = Add-Type -memberDefinition @'
[DllImport("user32.dll")]
public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);
'@ -name 'Win32ShowWindowAsync' -namespace Win32Functions -passThru

        $Win32ShowWindowAsync::ShowWindowAsync($MainWindowHandle, $WindowStates[$Style]) | Out-Null
    }

    end {
        Write-Verbose -Message "Ending [$($MyInvocation.Mycommand)]"
    }
}

        ###################### CREATING PS GUI TOOL #############################
         
ConnectMSGraphModule
Set-WindowStyle HIDE
        
#### Form settings #################################################################
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")  
        
$Form = New-Object System.Windows.Forms.Form
$Form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedSingle #Modifies the window border
$Form.Text = "leanLAPS"
$Form.Size = New-Object System.Drawing.Size(925,290)  
$Form.StartPosition = "CenterScreen" #Loads the window in the center of the screen
$Form.BackgroundImageLayout = "Zoom"
$Form.MaximizeBox = $False
$Form.WindowState = "Normal"
$Icon = [system.drawing.icon]::ExtractAssociatedIcon($PSHOME + "\powershell.exe")
$Form.Icon = $Icon
$Form.KeyPreview = $True
$Form.Add_KeyDown({if ($_.KeyCode -eq "Enter"){$deviceInformation.PerformClick()}}) #Allow for Enter key to be used as a click
$Form.Add_KeyDown({if ($_.KeyCode -eq "Escape"){$Form.Close()}}) #Allow for Esc key to be used to close the form
        
#### Group boxes for buttons ########################################################
$groupBox = New-Object System.Windows.Forms.GroupBox
$groupBox.Location = New-Object System.Drawing.Size(10,10) 
$groupBox.size = New-Object System.Drawing.Size(180,230)
$groupBox.text = "Input Device Name:" 
$Form.Controls.Add($groupBox) 
        
###################### BUTTONS ##########################################################
        
#### Input Box with "Device name" label ##########################################
$inputBox = New-Object System.Windows.Forms.TextBox 
$inputBox.Font = New-Object System.Drawing.Font("Lucida Console",15)
$inputBox.Location = New-Object System.Drawing.Size(15,30) 
$inputBox.Size = New-Object System.Drawing.Size(150,60) 
$inputBox.ForeColor = "DarkGray"
$inputBox.Text = "Device Name"
$inputBox.Add_GotFocus({
    if ($inputBox.Text -eq 'Device Name') {
        $inputBox.Text = ''
        $inputBox.ForeColor = 'Black'
    }
})
$inputBox.Add_LostFocus({
    if ($inputBox.Text -eq '') {
        $inputBox.Text = 'Device Name'
        $inputBox.ForeColor = 'Darkgray'
    }
})
$inputBox.Add_TextChanged({$deviceInformation.Enabled = $True}) #Enable the Device Info button after the end user typed something into the inputbox
$inputBox.TabIndex = 0
$Form.Controls.Add($inputBox)
$groupBox.Controls.Add($inputBox)
        
#### Device Info Button #################################################################
$deviceInformation = New-Object System.Windows.Forms.Button
$deviceInformation.Font = New-Object System.Drawing.Font("Lucida Console",15)
$deviceInformation.Location = New-Object System.Drawing.Size(15,80)
$deviceInformation.Size = New-Object System.Drawing.Size(150,60)
$deviceInformation.Text = "Device Info"
$deviceInformation.TabIndex = 1
$deviceInformation.Add_Click({getDeviceInfo})
$deviceInformation.Enabled = $False #Disable Device Info button until end user types something into the inputbox
$deviceInformation.Cursor = [System.Windows.Forms.Cursors]::Hand
$groupBox.Controls.Add($deviceInformation)
        
###################### CLOSE Button ######################################################
$closeButton = new-object System.Windows.Forms.Button
$closeButton.Font = New-Object System.Drawing.Font("Lucida Console",15)
$closeButton.Location = New-Object System.Drawing.Size(15,150)
$closeButton.Size = New-object System.Drawing.Size(150,60)
$closeButton.Text = "Close"
$closeButton.TabIndex = 2
$closeButton.Add_Click({$Form.close()})
$closeButton.Cursor = [System.Windows.Forms.Cursors]::Hand
$groupBox.Controls.Add($closeButton)
        
#### Output Box Field ###############################################################
$outputBox = New-Object System.Windows.Forms.RichTextBox
$outputBox.Location = New-Object System.Drawing.Size(200,15) 
$outputBox.Size = New-Object System.Drawing.Size(700,225)
$outputBox.Font = New-Object System.Drawing.Font("Lucida Console",15,[System.Drawing.FontStyle]::Regular)
$outputBox.MultiLine = $True
$outputBox.ScrollBars = "Vertical"
$outputBox.Text = "Type Device name and then click the `"Device Info`" button."
$Form.Controls.Add($outputBox)
        
##############################################
        
$Form.Add_Shown({$Form.Activate()})
[void] $Form.ShowDialog()
