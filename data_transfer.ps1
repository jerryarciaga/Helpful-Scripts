<#
    FileName:       data_transfer.ps1
    Author:         Jerry Arciaga
    Contact:        jerryarciaga11@gmail.com
    Created:        09 Mar 24
    Description:
        This script copies multiple folders from one drive to another using a series of robocopy commands.
#>


#################################################################################
# VARIABLES - Specify the source, destination and a location to store log files #
#################################################################################
$PROFILE = "jerry.arciaga"
$SOURCE = "C:\Users\Jerry"
$DEST = "D:\jerry.bk"
$LOGFOLDER = "D:\logs"

# Folders to copy
$FOLDERS = `
    "Contacts",`
    "Desktop",`
    "Documents",`
    "Downloads",`
    "Favorites",`
    "Links",`
    "Music",`
    "OneDrive",`
    "Pictures"

########################## END VARIABLES ########################################

# Create log folders if they don't exist yet.
if (!(Test-Path $LOGFOLDER)) {
    New-Item -ItemType Directory $LOGFOLDER
}
if (!(Test-Path $LOGFOLDER\$PROFILE)) {
    New-Item -ItemType Directory $LOGFOLDER\$PROFILE
}

# Give opportunity to check on specified files.
Write-Host "The following files are ready for transfer:"
foreach ($FOLDER in $FOLDERS) {
    if (Test-Path $FOLDER) {
        Write-Host "$FOLDER"
    }
    else {
        Write-Host "$FOLDER does not exist. Exiting..."
        return 1
    }
}
pause

# Perform robocopy script for each specified folder.
foreach ($FOLDER in $FOLDERS) {
    robocopy $SOURCE\$FOLDER $DEST\$FOLDER `
        /mt /v /e /zb /xa:e /xx /r:2 /w:2 /tee `
        /copyall `
        /log:$LOGFOLDER\$PROFILE\$FOLDER.copy.log
}
