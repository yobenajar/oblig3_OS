

for ($i=0; $i -lt $args.Count; $i++) {

		$filnavn = ""+ $args[$i] + "--{0:yyyy/MM/dd--HH:mm:ss}.meminfo" -f (Get-Date)
		$minne = (Get-Process -id $args[$i]).VirtualMemorySize / 1MB
		$workingSet = (Get-Process -id $args[$i]).WorkingSet

		New-Item -Path . -Itemtype File -Name $filnavn -Force
		Add-Content -Path $filnavn -Value ("
		Minne info om prosess med PID " + $args[$i] +
		"`nTotal bruk av virtuelt minne: " + $minne +
		"`nStorrelse paa Working Set: " + $workingSet
		)
}
