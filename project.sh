#Chris Sequeira 
#spawn, network, kill 

#spawn APM processes
function spawn () {
	for i in APM{1..6};do
		./executables/${i} 8.8.8.8 &
		echo "[+] Started ${i}"
	done
}

#set up csv for getting stats
function setup () {
	echo "time,APM1 CPU,APM2 CPU,APM3 CPU,APM4 CPU,APM5 CPU,APM6 CPU,APM1 Memory,APM2 Memory,APM3 Memory,APM4 Memory,APM5 Memory,APM6 Memory" > process_metrics.csv
	echo "time,RX Data Rate,TX Data Rate,Disk Writes,Disk Capacity" > system_metrics.csv
}

#hard drive metrics
function disk () {
	drive="nvme0n1"
	kbwps=$(iostat | grep "$drive" | awk '{FS="\t"; print $4}')
	kbw=$(df | grep "\/$" | awk '{print $3 * 0.001024}' | bc)
	echo "${kbwps},${$kbw}"
}

#process metrics
function process () {
	cpu_apm1=$(ps -aux | grep APM1 | head -n -1 | awk '{print $3}' | tr '\n' '' )
	cpu_apm2=$(ps -aux | grep APM2 | head -n -1 | awk '{print $3}' | tr '\n' '' )
	cpu_apm3=$(ps -aux | grep APM3 | head -n -1 | awk '{print $3}' | tr '\n' '' )
	cpu_apm4=$(ps -aux | grep APM4 | head -n -1 | awk '{print $3}' | tr '\n' '' )
	cpu_apm5=$(ps -aux | grep APM5 | head -n -1 | awk '{print $3}' | tr '\n' '' )
	cpu_apm6=$(ps -aux | grep APM6 | head -n -1 | awk '{print $3}' | tr '\n' '' )
	mem_apm1=$(ps -aux | grep APM1 | head -n -1 | awk '{print $4}' | tr '\n' '' )
	mem_apm2=$(ps -aux | grep APM2 | head -n -1 | awk '{print $4}' | tr '\n' '' )
	mem_apm3=$(ps -aux | grep APM3 | head -n -1 | awk '{print $4}' | tr '\n' '' )
	mem_apm4=$(ps -aux | grep APM4 | head -n -1 | awk '{print $4}' | tr '\n' '' )
	mem_apm5=$(ps -aux | grep APM5 | head -n -1 | awk '{print $4}' | tr '\n' '' )
	mem_apm6=$(ps -aux | grep APM6 | head -n -1 | awk '{print $4}' | tr '\n' '' )

	echo "${runtime},${cpu_apm1},${cpu_apm2},${cpu_apm3},${cpu_apm4},${cpu_apm5},${cpu_apm6},${mem_apm1},${cpu_apm2},${cpu_apm3},${cpu_apm4},${cpu_apm5},${cpu_apm6}" >> process_metrics.csv
}

#collect system metrics
function system () {
	network=$(ifstat | grep wlp0s20f3 | awk '{print $7,$9}' | tr ' ' ',')
	
	drive="nvme0n1"
    kbwps=$(iostat | grep "$drive" | awk '{FS="\t"; print $4}')
    kbw=$(df | grep "\/$" | awk '{print $3 * 0.001024}' | bc)
        
	echo "${runtime},${network},${kbwps},${kbw}" >> system_metrics.csv
}

#main loop
function main_loop() {
	runtime=0
	max_runtime=900
	sleep 1
	while true; do
		echo $runtime 
		if [ $runtime -ge $max_runtime ]
		then
			break
		fi
		if (( $runtime % 5 == 0 ))
		then
			system &
		fi
		process &
		runtime=$(( $runtime + 1))
		sleep 1
	done	
}

#kill all APM processes 
function cleanup {
	pkill APM
	echo "[+] Killed all processes"
}

spawn
setup
main_loop
cleanup
