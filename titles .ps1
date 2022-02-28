$path = "C:\users\nconnelly002\Downloads\UserTitles.csv"
$csv = import-csv $path |foreach-object{

    $user = "$($_.Samaccountname)"
    $title = "$($_.title)"
    Set-ADUser $user -Title $title

}