#!/bin/bash
function reset() 
{
sudo vboxmanage list -l vms | grep "Name:"
VMNames=$(sudo vboxmanage list -l vms | grep "Name:") 
printf "\nEnter name of Virtual Machine or press CTRL-C to exit:\n"
read inputName 
VMNamesLength=${#VMNames} 
inputNameLength=${#inputName}
found=0
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
reset 
