function meny {
	Write-host
	Write-Host "1 - Hvem er jeg og hva er navnet paa dette scriptet?"
	Write-host "2 - Hvor lenge er det siden siste boot?"
	Write-host "3 - Hvor mange prosesser og tr ̊ader finnes?"
	Write-host "4 - Hvor mange context switch'er fant sted siste sekund?"
	Write-host "5 - Hvor stor andel av CPU-tiden ble benyttet i kernelmode og i usermode siste sekund?"
	Write-host "6 - Hvor mange interrupts fant sted siste sekund?"
	Write-host "9 - Avslutt dette scriptet"
}

meny

while ($ans -ne 9) {
	Write-Host "Skriv inn et tall: "
	$ans=Read-Host


	switch ($ans) {
		1 { Write-host "Jeg er $(whoami), og scriptet heter $($MyInvocation.MyCommand.Name)" }

		2 {
			#Write-Host "Tid siden siste boot: $(Get-Uptime)"

			$uptime = (Get-Date) - (Get-CimInstance -ClassName win32_operatingsystem).LastBootUpTime
            Write-Host("Siste boot: " + $uptime.Hours + "h, " + $uptime.Minutes + "m")
		}

		3 {
			#$count = 0
			#Get-Process | ForEach-Object {$count = $([int]$count + $_.Threads.Count)}
			#Write-Host "Antall prosesser: $([int]@(Get-Process).Count)"
			#Write-Host "Antall tråder: $($count)"

			$trader = (Get-CimInstance -ClassName win32_Thread | Get-Unique | Measure-Object).Count
            $prosesser = (Get-Process | Sort-Object name| Get-Unique | Measure-Object).count
            Write-Output ("Det finnes" + $trader + "tråder")
            Write-Host "Det finnes $prosesser prosesser"
		}

		4 {
			$contextSwitch = (Get-CimInstance -ClassName Win32_PerfFormattedData_PerfOS_System).ContextSwitchesPersec
			Write-Host "Antall context switch i det siste sekundet: $contextSwitch"
		}

		5 {
			$process = (Get-Process -ComputerName)
			foreach ($proc in $procs) {
				$usermode1 = $userMode1 + $proc.PrivilegedProcessorTime.TotalMilliseconds
				$kernelmode1 = $kernelmode1 + $proc.PrivilegedProcessorTime.TotalMilliseconds
			}

			Start-Sleep(1)

			foreach ($proc in $procs) {
				$usermode2 = $userMode2 + $proc.PrivilegedProcessorTime.TotalMilliseconds
				$kernelmode2 = $kernelmode2 + $proc.PrivilegedProcessorTime.TotalMilliseconds
			}

			$user = $usermode2 - $usermode1
			$kernel = $kernelmode2 - $kernelmode1

			$sum = $user + $kernel

			$prosent = 100 / $sum

			Write-Output($user * $prosent + "% av det siste sekundet til usermode")
			Write-host "$kernel * $prosent % av det siste sekundet til kernelmode"
		}

		6 {
			$interrupts = (Get-CimInstance -ClassName Win32_PerfFormattedData_Counters_ProcessorInformation).InterruptsPersec
			Write-Host "Antall interrups i det siste sekundet: $interrupts"
		}

		9 { Write-Host "Programmet er avsluttet" }

	}
}
