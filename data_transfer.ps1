<#
    FileName:       data_transfer.ps1
    Author:         Jerry Arciaga
    Created:        09 Mar 24
    Description:
        This script copies multiple folders from one drive to another using a
        series of robocopy commands.
    Usage:
        Specify the following by entering the following information
            1. $SOURCE - Absolute path
            2. $DEST - The destination folder.
            3. $LOGFOLDER - Generic name to store log profiles.
            4. $LOGPROFILE - Folder to store log files.
                NOTE: Log files will be stored in $LOGFOLDER\$LOGPROFILE
 #>

########################### BEGIN VARIABLES #####################################
$SOURCE = Read-Host "Enter Source Location"
$DEST = Read-Host "Enter Destination Location"
$LOGFOLDER = Read-Host "Enter Log Folder Location"
$LOGPROFILE = Read-Host "Enter Log Profile"
########################## END VARIABLES ########################################

# Give opportunity to check on specified files.
$FOLDERS = Get-ChildItem -Name $SOURCE -Directory -Exclude ".*"
Write-Host "The following files are ready for transfer:"
foreach ($FOLDER in $FOLDERS) {
    if (Test-Path $SOURCE\$FOLDER) {
        Write-Host "$SOURCE\$FOLDER -> $DEST\$FOLDER"
    }
    else {
        Write-Host "$SOURCE\$FOLDER does not exist. Exiting..."
        return
    }
}
Write-Host "Log files will be written in $LOGFOLDER\$LOGPROFILE"
pause

# Create log folders if they don't exist yet.
if (!(Test-Path $LOGFOLDER)) {
    New-Item -ItemType Directory $LOGFOLDER
}
if (!(Test-Path $LOGFOLDER\$LOGPROFILE)) {
    New-Item -ItemType Directory $LOGFOLDER\$LOGPROFILE
}

# Perform robocopy script for each specified folder.
foreach ($FOLDER in $FOLDERS) {
    robocopy $SOURCE\$FOLDER $DEST\$FOLDER `
        /mt /e /zb /xo /xa:e /xx /xj /r:2 /w:2 /tee /np `
        /copy:dat /dcopy:dat `
        /log:$LOGFOLDER\$LOGPROFILE\$FOLDER.log
    Get-Content $LOGFOLDER\$LOGPROFILE\$FOLDER.log >> $LOGFOLDER\$LOGPROFILE\$LOGPROFILE.merged.log
}
Write-Output "Data Transfer complete as of: $(Get-Date)" |
    Tee-Object -Append $LOGFOLDER\$LOGPROFILE\$LOGPROFILE.merged.log
