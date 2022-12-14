#Directory of text files that will have users paths that will be deleted
$deleteFileDirectory = 'C:\Users\JayLucas\Desktop\DeleteBatchFiles'

#Directory where results of Batch Deletes information
$batchDeleteResults = 'C:\Users\JayLucas\Desktop\BatchDeleteResults'

#Check to see if batchDeleteResults folder exist, if not create it
$IsBatchDeleteResultsCreated = Test-Path -Path $batchDeleteResults
if ($IsBatchDeleteResultsCreated -ne 'True') {
    New-Item -Path $batchDeleteResults -ItemType Directory 
}

#Get list of batch files to be deleted
$batchFiles = Get-ChildItem -Path $deleteFileDirectory

foreach($file in $batchFiles)
{
    #Get file name from file
    $txtfile = Get-Item $deleteFileDirectory"\"$file
    $folderName = $txtfile.Basename
        
    #Check to see if folder already exist, if not create it
    $IsValidPath = Test-Path -Path $batchDeleteResults"\"$folderName
    if ($IsValidPath -ne 'True') {

        #Create directory based off file name
        New-Item -Path $batchDeleteResults"\"$folderName -ItemType Directory 

        #Create directory for reports
        New-Item -Path $batchDeleteResults"\"$folderName"\Reports" -ItemType Directory 

        #Create directory for purge
        New-Item -Path $batchDeleteResults"\"$folderName"\Purge" -ItemType Directory   
        
        #Create Reports names
        $removedReport = "$batchDeleteResults\$folderName\Reports\$folderName-Removed.csv"
        $errorReport = "$batchDeleteResults\$folderName\Reports\$folderName-Errors.csv"  

        #Adding the header columns to report
        Add-Content -Path $removedReport -Value '"Users Removed","Deleted"'
    }

    #Get all users in file
    $user_paths = Get-Content -Path $deleteFileDirectory"\"$file

    #assign variable to purge directory
    $emptyDir = $batchDeleteResults + "\" + $folderName + "\Purge"

    #Loop through all users and remove their folders
    foreach($path in $user_paths)
    {
        try { 
            #Copy and Update from empty directory to the target, suging the option /purge
            robocopy $emptyDir $path /purge

            #Delete all files from parent
            Remove-Item -LiteralPath $path -Force -Recurse    
            
            #Add to report
            Add-Content -Path $removedReport -Value @("$path,Yes")

            #Move copy of user list file into directory
            Move-Item -Path $txtfile -Destination $batchDeleteResults"\"$folderName -ErrorAction Stop
        }
        catch { 
            #Catch Error code to put into error.csv
            $errorCode = $Error[0].Exception.GetType().FullName

            #Check if Error report exist if not create it
            $HasErrorReport = Test-Path -Path $errorReport
            if ($HasErrorReport -ne 'True') {
                Add-Content -Path $errorReport -Value '"Users Errored","Error"'
            }

            #Add to error report
            Add-Content -Path $errorReport -Value @("$path,$errorCode") 
        } 
    }

    # Delete the empty purge directory
    Remove-Item -LiteralPath $emptyDir -Recurse -Force

}