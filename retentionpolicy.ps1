
$location = 'C:\Users\nconnelly002\Downloads\test'
$files
$falseFiles 
$daysback = -2555
$CurrentDate = Get-Date
$DatetoDelete = $CurrentDate.AddDays($DaysBack)
$oldest = 'Monday, ‎December ‎31, ‎1979, ‏‎11:00:00 PM'

$falseFiles = Get-ChildItem $location -Recurse | Where-Object {$_.lastwritetime -like '*1979*'}
foreach($falseFile in $falseFiles){ $falseFile.LastWriteTime = (get-date)}
$files = Get-ChildItem $location -Recurse
$deleted =Get-ChildItem $location -Recurse { $_.LastWriteTIme -lt $DatetoDelete}
write-host "Deleted items" 
write-host $deleted
$files | Where-Object { $_.LastWriteTIme -lt $DatetoDelete -and $_.LastWriteTime -isnot $oldest} | Remove-Item -Recurse -ErrorAction Ignore

