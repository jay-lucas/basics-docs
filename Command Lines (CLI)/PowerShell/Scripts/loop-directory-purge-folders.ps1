#Directory to delete
$deleteDirectory = 'C:\Users\JayLucas\Desktop\MyDirectory'

$IsValidPath = Test-Path -Path $deleteDirectory

#If folder check is not equal (-eq) to True, then proceed with deleting 
if ($IsValidPath -eq 'True') {
  
    #Delete all elements within directory
    $userdir = Get-ChildItem -Path $deleteDirectory

    #loop through each user directory
    foreach($dir in $userdir)
    {
        $path = $deleteDirectory + "\" + $dir
        
        #Create an empty directory
        $emptyDir = 'C:\Users\JayLucas\Desktop\' + $dir
        mkdir $emptyDir

        #Copy and Update from empty directory to the target, suging the option /purge
        robocopy $emptyDir $path /purge

        # Delete the empty directory
        Remove-Item -LiteralPath $emptyDir -Recurse -Force

        try { 
            #Delete all files from parent
            Remove-Item -LiteralPath $path -Force -Recurse         
        }
        catch { 
            Write-Host "An error occurred: " + $Error[0].Exception.GetType().FullName 
        }   
        
    }
        
    #Delete parent
    Remove-Item -LiteralPath $deleteDirectory -Recurse -Force
    
}
    