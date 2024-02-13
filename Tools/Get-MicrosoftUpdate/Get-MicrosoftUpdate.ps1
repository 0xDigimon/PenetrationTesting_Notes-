# Gives a list of all Microsoft Updates sorted by KB number/HotfixID
# By Tom Arbuthnot. Lyncdup.com

# http://lyncdup.com/2013/09/list-all-microsoftwindows-updates-with-powershell-sorted-by-kbhotfixid-get-microsoftupdate/

$wu = new-object -com "Microsoft.Update.Searcher"

$totalupdates = $wu.GetTotalHistoryCount()

$all = $wu.QueryHistory(0,$totalupdates)

# Define a new array to gather output
 $OutputCollection=  @()
		
Foreach ($update in $all)
    {
    $string = $update.title

    $Regex = "KB\d*"
    $KB = $string | Select-String -Pattern $regex | Select-Object { $_.Matches }

     $output = New-Object -TypeName PSobject
     $output | add-member NoteProperty "HotFixID" -value $KB.' $_.Matches '.Value
     $output | add-member NoteProperty "Title" -value $string
     $OutputCollection += $output

    }

# Oupput the collection sorted and formatted:
$OutputCollection | Sort-Object HotFixID | Format-Table -AutoSize
Write-Host "$($OutputCollection.Count) Updates Found"

# If you want to output the collection as an object, just remove the two lines above and replace them with "$OutputCollection"

# credit/thanks:
# http://blogs.technet.com/b/tmintner/archive/2006/07/07/440729.aspx
# http://www.gfi.com/blog/windows-powershell-extracting-strings-using-regular-expressions/