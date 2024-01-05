$cert = Get-AuthenticodeSignature "C:\Users\EduthingAdmin\AppData\Local\Apps\2.0\M8MXH6PP.86H\DBC6ORCT.2GG\conn..tion_abc359f7820ce320_0006.000b_f1a77bad889f7de0\ConnectChildcare.exe" | Select-Object -ExpandProperty SignerCertificate
Export-Certificate -Cert $cert -FilePath "C:\ConnectChildcare.cer" -Type CERT
