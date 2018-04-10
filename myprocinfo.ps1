function meny {
	Write-Output "
	 1 - Hvem er jeg og hva er navnet paa dette scriptet?
	 2 - Hvor lenge er det siden siste boot?
	 3 - Hvor mange prosesser og tr ̊ader finnes?
	 4 - Hvor mange context switch'er fant sted siste sekund?
	 5 - Hvor stor andel av CPU-tiden ble benyttet i kernelmode og i usermode siste sekund?
	 6 - Hvor mange interrupts fant sted siste sekund?
	 9 - Avslutt dette scriptet"
}

meny

while ($ans -ne 9) {
	Write-Output "Skriv inn et tall: "
	$ans=Read-Host


	switch ($ans) {
		1 { Write-Output "Jeg er $(whoami), og scriptet heter $($MyInvocation.MyCommand.Name)" }

		2 {
			$uptime = (Get-Date) - (Get-CimInstance -ClassName win32_operatingsystem).LastBootUpTime
            Write-Output "Tid siden boot: $uptime.Hours h, $uptime.Minutes m"
		}

		3 {
			$trader = (Get-CimInstance -ClassName win32_Thread | Get-Unique | Measure-Object).Count
            $prosesser = (Get-Process | Sort-Object name| Get-Unique | Measure-Object).count
            Write-Output "Det finnes $trader tråder"
            Write-Output "Det finnes $prosesser prosesser"
		}

		4 {
			$contextSwitch = (Get-CimInstance -ClassName Win32_PerfFormattedData_PerfOS_System).ContextSwitchesPersec
			Write-Output "Antall context switch i det siste sekundet: $contextSwitch"
		}

		5 {
			$prosesser = (Get-Process -ComputerName .)
			foreach ($prosess in $prosesser) {
				$usermode1 = $userMode1 + $prosess.PrivilegedProcessorTime.TotalMilliseconds
				$kernelmode1 = $kernelmode1 + $prosess.PrivilegedProcessorTime.TotalMilliseconds
			}

			Start-Sleep(1)

			foreach ($proc in $procs) {
				$usermode2 = $userMode2 + $prosess.PrivilegedProcessorTime.TotalMilliseconds
				$kernelmode2 = $kernelmode2 + $prosess.PrivilegedProcessorTime.TotalMilliseconds
			}

			$user = $usermode2 - $usermode1
			$kernel = $kernelmode2 - $kernelmode1

			$sum = $user + $kernel

			$prosent = 100 / $sum

			$usermode = $user * $prosent
			$kernelmode = $kernel * $prosent

			Write-Output "$usermode % av det siste sekundet til usermode"
			Write-Output "$kernelmode % av det siste sekundet til kernelmode"
		}

		6 {
			$interrupts = (Get-CimInstance -ClassName Win32_PerfFormattedData_Counters_ProcessorInformation).InterruptsPersec
			Write-Output "Antall interrups i det siste sekundet: $interrupts[0]"
		}

		9 { Write-Output "Programmet er avsluttet" }

	}
}
