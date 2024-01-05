#===================================================================================================
# HRUC Info Script Developed by Rhys Saddul - Original script template created by Jai Mehta ©2017
#===================================================================================================

Add-Type -AssemblyName PresentationFramework, System.Drawing, System.Windows.Forms
[void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework')
[xml]$XAML = @'
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        xmlns:local="clr-namespace:WpfApp3"
        Name="window" WindowStyle="None" Width="420" Height="350" Opacity="0.92" AllowsTransparency="True">
        <Window.Resources>
        <Style TargetType="GridViewColumnHeader">
            <Setter Property="Background" Value="Transparent" />
            <Setter Property="Foreground" Value="Transparent"/>
            <Setter Property="BorderBrush" Value="Transparent"/>
            <Setter Property="FontWeight" Value="Bold"/>
            <Setter Property="Opacity" Value="0.5"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="GridViewColumnHeader">
                    <Border Background="Transparent">
                    <ContentPresenter></ContentPresenter>
                    </Border>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>
        </Window.Resources>
    <Grid Name="grid" Height="350" HorizontalAlignment="Left" VerticalAlignment="Top">
        <Label Name="Title" Content="HRUC IT Support Info" HorizontalAlignment="Left" VerticalAlignment="Top" Width="420" Background="#639ed5" Foreground="White" FontWeight="Bold" FontSize="14.5" Height="29"/>
        <Label Content="Email: ithelpdesk@hruc.ac.uk   Tel: 01895 853443" HorizontalAlignment="Left" Margin="0,29,0,0" VerticalAlignment="Top" Width="420" Background="#639ed5" Foreground="White" FontWeight="Bold" FontSize="12.5" Height="26"/>
        <Label Content="08:30 - 17:00 Monday to Friday" HorizontalAlignment="Left" Margin="0,55,0,0" VerticalAlignment="Top" Width="420" Background="#639ed5" Foreground="White" FontSize="11" Height="25"/>
        <Label Content="Current User" HorizontalAlignment="Left" Margin="0,80,0,0" VerticalAlignment="Top" Height="30" Width="170" Background="#474644" Foreground="White" FontWeight="Bold"/>
        <Label Content="Email Address" HorizontalAlignment="Left" Margin="0,110,0,0" VerticalAlignment="Top" Height="30" Width="170" Background="#474644" Foreground="White" FontWeight="Bold"/>
        <Label Content="Printer PIN" HorizontalAlignment="Left" Margin="0,140,0,0" VerticalAlignment="Top" Height="30" Width="170" Background="#474644" Foreground="White" FontWeight="Bold"/>
        <Label Content="Computer Name" HorizontalAlignment="Left" Margin="0,170,0,0" VerticalAlignment="Top" Height="30" Width="170" Background="#474644" Foreground="White" FontWeight="Bold"/>
        <Label Content="IP Address" HorizontalAlignment="Left" Margin="0,200,0,0" VerticalAlignment="Top" Height="30" Width="170" Background="#474644" Foreground="White" FontWeight="Bold"/>
        <Label Content="Computer Domain Name" HorizontalAlignment="Left" Margin="0,230,0,0" VerticalAlignment="Top" Height="30" Width="170" Background="#474644" Foreground="White" FontWeight="Bold"/>
        <Label Content="OS Name" HorizontalAlignment="Left" Margin="0,260,0,0" VerticalAlignment="Top" Height="30" Width="170" Background="#474644" Foreground="White" FontWeight="Bold"/>
        <Label Content="OS Version" HorizontalAlignment="Left" Margin="0,290,0,0" VerticalAlignment="Top" Height="30" Width="170" Background="#474644" Foreground="White" FontWeight="Bold"/>
        <Label Content="Last Boot Time" HorizontalAlignment="Left" Margin="0,320,0,0" VerticalAlignment="Top" Height="30" Width="170" Background="#474644" Foreground="White" FontWeight="Bold"/>
        <TextBox Name="txtUserName" HorizontalAlignment="Left" Height="30" Margin="170,80,0,0" TextWrapping="Wrap" Text="" VerticalAlignment="Top" Width="250" IsEnabled="True" BorderThickness="0.5"/>
        <TextBox Name="txtEmailAddress" HorizontalAlignment="Left" Height="30" Margin="170,110,0,0" TextWrapping="Wrap" Text="" VerticalAlignment="Top" Width="250" IsEnabled="True" BorderThickness="0.5"/>
        <TextBox Name="txtPrinterPIN" HorizontalAlignment="Left" Height="30" Margin="170,140,0,0" TextWrapping="Wrap" Text="" VerticalAlignment="Top" Width="250" IsEnabled="True" BorderThickness="0.5"/>
        <TextBox Name="txtHostName" Height="30" Margin="170,170,0,0" TextWrapping="Wrap" Text="" VerticalAlignment="Top" IsEnabled="True" AllowDrop="True" BorderThickness="0.5" HorizontalAlignment="Left" Width="250"/>
        <TextBox Name="txtWindowsIP" HorizontalAlignment="Left" Height="30" Margin="170,200,0,0" TextWrapping="Wrap" Text="" VerticalAlignment="Top" Width="250" IsEnabled="True" BorderThickness="0.5"/>
        <TextBox Name="txtDomainName" HorizontalAlignment="Left" Height="30" Margin="170,230,0,0" TextWrapping="Wrap" Text="" VerticalAlignment="Top" Width="250" IsEnabled="True" BorderThickness="0.5"/>
        <TextBox Name="txtOSReleaseInfo" HorizontalAlignment="Left" Height="30" Margin="170,260,0,0" TextWrapping="Wrap" Text="" VerticalAlignment="Top" Width="250" IsEnabled="True" BorderThickness="0.5"/>
        <TextBox Name="txtOSVersion" HorizontalAlignment="Left" Height="30" Margin="170,290,0,0" TextWrapping="Wrap" Text="" VerticalAlignment="Top" Width="250" IsEnabled="True" BorderThickness="0.5"/>
        <TextBox Name="txtBootTime" HorizontalAlignment="Left" Height="30" Margin="170,320,0,0" TextWrapping="Wrap" Text="" VerticalAlignment="Top" Width="250" IsEnabled="True" BorderThickness="0.5"/>
            <ListView Name="listview" SelectionMode="Single" Foreground="White" Background="Transparent" BorderBrush="Transparent" IsHitTestVisible="False">
                <ListView.ItemContainerStyle>
                    <Style>
                        <Setter Property="Control.HorizontalContentAlignment" Value="Stretch"/>
                        <Setter Property="Control.VerticalContentAlignment" Value="Stretch"/>
                    </Style>
                </ListView.ItemContainerStyle>
            </ListView>
    </Grid>
</Window>
'@

#Read XAML
$reader=(New-Object System.Xml.XmlNodeReader $xaml) 
try{$Form=[Windows.Markup.XamlReader]::Load( $reader )}
catch{Write-Host "Unable to load Windows.Markup.XamlReader. Some possible causes for this problem include: .NET Framework is missing PowerShell must be launched with PowerShell -sta, invalid XAML code was encountered."; exit}

#===========================================================================
# Store Form Objects In PowerShell
#===========================================================================
$xaml.SelectNodes("//*[@Name]") | %{Set-Variable -Name ($_.Name) -Value $Form.FindName($_.Name)}

Function RefreshData{
#===========================================================================
# Stores WMI values in WMI Object from System Classes
#===========================================================================
$oWMIOS = @()
$usrCurrent = @()
$oWMINIC = @()
$oWMICPU = @()
$OSVersion = @()
$CurrentBuild = @()
$winRelease = @()
$ProductName = @()
$LastBoot = @()
$oWMIOS = Get-WmiObject win32_OperatingSystem
$usrCurrent = ([adsisearcher]"(&(objectCategory=User)(samaccountname=$env:USERNAME))").findall().properties
$ProductName = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion' -Name ProductName).ProductName
$winRelease = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion' -Name ReleaseID -ErrorAction Stop).ReleaseID
$CurrentBuild = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion' -Name CurrentBuild).CurrentBuild
$UBR = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion' -Name UBR).UBR
$OSVersion = $CurrentBuild + "." + $UBR
$oWMINIC = Get-WmiObject Win32_NetworkAdapterConfiguration | Where { $_.IPAddress } | Select -Expand IPAddress | Where { $_ -like '1*' }
$LastBoot = Get-CimInstance -ClassName win32_operatingsystem
$IsDomainMember = (Get-WmiObject -Class Win32_ComputerSystem).PartOfDomain
$WGName = (Get-WmiObject -Class Win32_ComputerSystem).Workgroup
$WGEmail = cmd /c "whoami /upn"

#===========================================================================
# Links WMI Object Values to XAML Form Fields
#===========================================================================
$txtHostName.Text = $oWMIOS.PSComputerName

#Formats and displays OS name
$txtOSReleaseInfo.Text = "$($ProductName) - $($oWMIOS.OSArchitecture)"

#Displays Printer PIN
$txtPrinterPIN.Text = $usrCurrent.pager

#Displays OS Architecture
$txtOSVersion.Text = "Release: $($winRelease)   Build: $($OSVersion)"

#Display Domain Name
If ($IsDomainMember -eq $true) {
$txtDomainName.Text = $env:USERDNSDOMAIN
}
else {
$txtDomainName.Text = $WGName
}

#Displays Current User
If ($IsDomainMember -eq $true) {
$txtUserName.Text = $usrCurrent.name
}
else {
$txtUserName.Text = $env:username
}

#Displays IP Address
$txtWindowsIP.Text = $oWMINIC

#Displays Email Address
If ($IsDomainMember -eq $true) {
$txtEmailAddress.Text = $($usrCurrent.mail).ToLower()
}
else {
$txtEmailAddress.Text = $WGEmail.ToLower()
}

#Display Last Boot Time
$txtBootTime.Text = $($LastBoot.LastBootUpTime).ToString('dd/MM/yyyy HH:mm:ss')
}

#===========================================================================
# Build Tray Icon
#===========================================================================
$scriptDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
$icon = [System.Drawing.Icon]::ExtractAssociatedIcon("$scriptDir\HRUC-Icon.ico")

# Populate ListView with PS Object data and set width 
$listview.ItemsSource = $disks
$listview.Width = $grid.width*.9 

# Create GridView object to add to ListView 
$gridview = New-Object System.Windows.Controls.GridView 
 
# Dynamically add columns to GridView, then bind data to columns 
foreach ($column in $columnorder) { 
    $gridcolumn = New-Object System.Windows.Controls.GridViewColumn 
    $gridcolumn.Header = $column 
    $gridcolumn.Width = $grid.width*.20 
    $gridbinding = New-Object System.Windows.Data.Binding $column 
    $gridcolumn.DisplayMemberBinding = $gridbinding 
    $gridview.AddChild($gridcolumn) 
} 
 
# Add GridView to ListView 
$listview.View = $gridview 
 
# Create notifyicon, and right-click -> Exit menu 
$notifyicon = New-Object System.Windows.Forms.NotifyIcon 
$notifyicon.Text = "HRUC IT Support Info" 
$notifyicon.Icon = $icon 
$notifyicon.Visible = $true 
 
$menuitem = New-Object System.Windows.Forms.MenuItem 
$menuitem.Text = "Exit" 

$contextmenu = New-Object System.Windows.Forms.ContextMenu 
$notifyicon.ContextMenu = $contextmenu 
$notifyicon.contextMenu.MenuItems.AddRange($menuitem) 
 
# Add a left click that makes the Window appear in the lower right part of the screen, above the notify icon. 
$notifyicon.add_Click({ 
    if ($_.Button -eq [Windows.Forms.MouseButtons]::Left) { 
            # reposition each time, in case the resolution or monitor changes 
	    $window.Left = $([System.Windows.SystemParameters]::WorkArea.Width-$window.Width) 
            $window.Top = $([System.Windows.SystemParameters]::WorkArea.Height-$window.Height) 
            $window.Show() 
            $window.Activate()
    	    RefreshData
    } 
}) 
 
# Close the window if it's double clicked 
$window.Add_MouseDoubleClick({ 
    RefreshData
}) 
 
#Close the window if it loses focus 
$window.Add_Deactivated({ 
    $window.Hide()
}) 
 
# When Exit is clicked, close everything and kill the PowerShell process 
$menuitem.add_Click({ 
   $notifyicon.Visible = $false 
   $window.close() 
   Stop-Process $pid 
}) 
 
# Make PowerShell Disappear 
$windowcode = '[DllImport("user32.dll")] public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);' 
$asyncwindow = Add-Type -MemberDefinition $windowcode -name Win32ShowWindowAsync -namespace Win32Functions -PassThru
$null = $asyncwindow::ShowWindowAsync((Get-Process -PID $pid).MainWindowHandle, 0) 
 
# Force garbage collection just to start slightly lower RAM usage. 
[System.GC]::Collect() 
 
# Create an application context for it to all run within. 
# This helps with responsiveness, especially when clicking Exit. 
$appContext = New-Object System.Windows.Forms.ApplicationContext 
[void][System.Windows.Forms.Application]::Run($appContext)