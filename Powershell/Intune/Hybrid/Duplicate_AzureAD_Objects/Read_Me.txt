These scripts are used for:

1) 1st Script looks at a dynamic group where Objects were duplicated during the hybrid conversion. It will export these into a CSV for a quick manual review.
2) 2nd Script will look at the CSV exported in the 1st Script then delete each object using the custom object ID
3) Repeat these on all dynamic groups

The Dynamic rule used for the group is:

(device.displayName -startsWith "HCUC-") and (device.deviceTrustType -ne "ServerAd") and (device.deviceTrustType -eq "Workplace")


 # Note we are using -ne in our query
Dynamic Query for Hybrid AAD joined devices = (device.deviceTrustType -eq “ServerAd”)

# Note we are using -eq in our query
Dynamic Query for Azure AD Registered (device.deviceTrustType -eq "Workplace")
