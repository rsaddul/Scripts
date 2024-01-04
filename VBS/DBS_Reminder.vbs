Set objNetwork = CreateObject("Wscript.Network")

intAnswer = _
    Msgbox("By pressing OK you, users of this computer agree that their DBS check is currently in progress. If this is not the case then you must speak with HR to ensure this process is started. Should you require more information our DBS checks policies, please speak with HR. This policy gives clear guidance on the processes that must be followed for the appointment and ongoing employment of all eligible individuals employed by HCUC in relation to criminal record checks. This policy is based on good practice and complies with the Rehabilitation of Offenders Act 1974 and DBS Code of Practice. Users of this computer agree to abide by the Acceptable Usage policy of HCUC and / or any usage agreements defined by your school. Users also agree that HCUC IT can monitor files, internet pages visited, and emails when necessary. School staff may monitor classes, files and communications via dedicated classroom control applications as per your school's usage agreement. All monitoring will be controlled by the HCUC Acceptable Usage and Data Protection policies.", _
        48+4, "DBS Warning Message!")
If intAnswer = 6 Then
     Msgbox "Please contact IT Support to remove this message for you."
Else
Set Edge=CreateObject("Wscript.shell")
Edge.run "https://app.esafeguarding.co.uk/Account/Login.aspx?ReturnUrl=%2f" 
End If