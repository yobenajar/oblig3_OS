

for ($i=0; $i -lt $args.Count; $i++) {

		$filnavn = "$args-{0:yyyyMMdd-HHmmss}.meminfo" -f (Get-Date)
		#$minne = (Get-Process -id $args[$i]).VirtualMemorySize / 1MB
		#$workingSet = (Get-Process -id $args[$i]).WorkingSet

		New-item Path . -Itemype File -Name $filnavn -Force
	{
		Write-Output("************** Minne info om prosess med PID" + $args[$i] + "**************")
		Write-Host "Total bruk av virtuelt minne: $minne"
		Write-Host "Størrelse på Working Set: $workingset"

	} > $filnavn
}
