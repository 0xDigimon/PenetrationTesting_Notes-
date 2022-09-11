$strFilter = “(&(objectCategory=User)(userAccountControl:1.2.840.113556.1.4.803:=4194304))”
$objDomain = New-Object System.DirectoryServices.DirectoryEntry
$objSearcher = New-Object System.DirectoryServices.DirectorySearcher
$objSearcher.SearchRoot = $objDomain
$objSearcher.Filter = $strFilter
$objSearcher.SearchScope = “Subtree”
$colProplist = “name”
foreach ($I in $colPropList){$objSearcher.PropertiesToLoad.Add($i)}
$colResults = $objSearcher.FindAll()
$colResults | Format-Table