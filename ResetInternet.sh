#!/bin/bash
# Function to reset VM internet connnection
function reset() 
{
# Grab list of VM names
sudo vboxmanage list -l vms | grep "Name:"
# Store list into variable
VMNames=$(sudo vboxmanage list -l vms | grep "Name:")
# Prompt user
printf "\nEnter name of Virtual Machine or press CTRL-C to exit:\n"
# Read user input
read inputName 
# Get length of list of VMs
VMNamesLength=${#VMNames} 
inputNameLength=${#inputName}
# Variable to check for existence of VM 
found=0
# Loop through names, and if it exists, reset network connection of VM
for (( i=0 ; i <= $VMNamesLength-$inputNameLength; i++ )) 
do 
	if [ "$inputName" == "${VMNames:i:$inputNameLength}" ]
        then	
                found=1
		printf "\nVM Name has been found!\n"
		sleep 5 
		if (( $found == 1 )) 
		then
			echo "VM is saving state..."
			sleep 2
			sudo vboxmanage controlvm $inputName poweroff
			echo "VM network cable is disconnecting: "
			sleep 5
			sudo vboxmanage modifyvm $inputName --nic1 none
			echo "VM network cable is re-connecting: "
			sleep 5 
			sudo vboxmanage modifyvm $inputName --nic1 natnetwork
			sleep 5
			sudo vboxmanage startvm $inputName
		fi 
	else
		found=0
	fi
done
}
# Call reset method
reset 
