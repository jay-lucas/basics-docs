# File path of Migrations
$folder = 'C:\Users\JayLucas\Desktop\Migrations'
$deleteDirectory = 'C:\Users\JayLucas\Desktop\MyDirectory'

#Check to see if Migrations folder has already been created
$IsValidPath = Test-Path -Path $folder

#If Migrations folder check is not equal (-ne) to True, then create Migrations folder
if ($IsValidPath -ne 'True') {
    Write-Host "Path not exists!"
    #Creates the Migrations folder
    New-Item -Path 'C:\Users\JayLucas\Desktop\Migrations' -ItemType Directory 
}  

#get Date format for Migrations Sub-folder
$date = Get-Date -Format "dddd MM_dd_yyyy"

#Check to see if folder for todays migration has already been created
$IsValidFolder = Test-Path -Path $folder"\$date"

#If Migrations sub-folder doesn't exist then create it
if($IsValidFolder -ne 'True') {
    New-Item -Path $folder"\$date" -ItemType Directory 
    Write-Host $date + " - Created in Migrations"
}

#create file name based on time of run and create the csv file from it
$time = Get-Date -Format "HH_mm_ss" 
$deletedReport = "Deleted-$time.csv"
$errorReport = "Errors-$time.csv"

#Adding the header columns (col*) to .csv file
Add-Content -Path $folder"\$date\$errorReport" -Value '"Folder","Error"'
Add-Content -Path $folder"\$date\$deletedReport" -Value '"Folder","Was Deleted"'
<#
    This is the sample data that we are using to append to the .csv. This should be 
    changed to the dynamic data elements later
#>

  $data = @(

  '"Adam","Bertram","abertram"'

  '"Joe","Jones","jjones"'

  '"Mary","Baker","mbaker"'

  )
  
  #This appends the data to the .csv by looping through each record in the variable $data
  $data | foreach { Add-Content -Path $folder"\$date\$errorReport" -Value $_ }
  
  #Import-Csv $Folder"\$date\$csvFile" 

