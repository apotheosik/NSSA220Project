#Chris Sequeira 
#spawn, network, kill 

#spawn APM processes
function spawn () {
	for i in APM{1..6};do
		./executables/${i} 8.8.8.8 &
		echo "[+] Started ${i}"
	done
}

#HARD DRIVE UTILIZATION 

#NETWORK rx AND TX of ens INTERFACE 
ifstat | grep ens | awk '{print $7, $9}'

#PROCESS STATISTICS 

#KILL PROCESSES FUNCTION 
function cleanup {
	pkill APM
	echo "[+] Killed all processes"
}

spawn
cleanup