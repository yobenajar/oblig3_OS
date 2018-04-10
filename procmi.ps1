

for ($i=0; $i -lt $pid.Count; $i++) {

		$filnavn = ""+ $pid[$i] + "--{0:yyyyMMdd--HHmmss}.meminfo" -f (Get-Date)
		$minne = (Get-Process -id $pid[$i]).VirtualMemorySize / 1MB
		$workingSet = (Get-Process -id $pid[$i]).WorkingSet

		New-Item -Path . -Itemtype File -Name $filnavn -Force
		Add-Content -Path $filnavn -Value ("
		********* Minne info om prosess med PID ********* " + $pid[$i] +
		"`nTotal bruk av virtuelt minne: " + $minne + "MB" +
		"`nStorrelse paa Working Set: " + $workingSet
		+ "KB")
}
