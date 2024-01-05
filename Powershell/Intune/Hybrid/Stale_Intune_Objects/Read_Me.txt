These scripts are used for:

1) Exports current Intune Objects from Active Directory
2) Checks the exported Active Directory Intune Objects used in the 1st script on Endpoint to see if they exits. This will then create another CSV which will have Objects that do not exist on Endpoint
3) The 2nd script will have exported objects that do not exist on Endpoint. You can now use script 3 to delete these objects from Active Directory