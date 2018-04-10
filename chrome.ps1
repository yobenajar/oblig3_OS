$prosess = "chrome"

Get-Process $prosess |
Select-Object Name, ID, @{Name='ThreadCount';Expression ={$_.Threads.Count}} |
Sort-Object -Property ThreadCount -Descending
