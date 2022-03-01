
$location = 'C:\Users\nconnelly002\Downloads\test'
$files
$falseFiles 
$daysback = -2555
$CurrentDate = Get-Date
$DatetoDelete = $CurrentDate.AddDays($DaysBack)



$falseFiles = Get-ChildItem $location -Recurse | Where-Object {$_.lastwritetime -like '*1979*'}
foreach($falseFile in $falseFiles){ $falseFile.LastWriteTime = (get-date)}
$files = Get-ChildItem $location -Recurse
$deleted =Get-ChildItem $location -Recurse { $_.LastWriteTIme -is $DatetoDelete}
write-host "Deleted items" 
write-host $deleted
$files | Where-Object { $_.LastWriteTIme -lt $DatetoDelete} | Remove-Item -Recurse -ErrorAction Ignore

