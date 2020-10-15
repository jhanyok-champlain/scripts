#showlist function gives a numbered list of an array.
function showlist($array){
    for($i=0; $i -lt $array.length; $i++){
        write-host ($i+1)": "$array[$i]
    }
}
#Resets all varibles to null to avoid conflicts. 
$global:basevm=$null
$global:snap=$null
$global:vmhost=$null
$global:dstore=$null
$global:folder=$null

#Function for connecting to the vecnter instnace.
function funconnect(){
    $askVcenter = read-host -prompt "What is the vcenter hostname or IP address"
    Connect-VIServer -Server $askVcenter
}


#Function that colllects and displays a vm folder that will than be used to select a 
#vm to clone. 
function funbase(){
    $askBaseFolder = read-host -prompt "Where is the folder of your base vms located?"
    $storebase = get-vm -location $askBaseFolder
    showlist($storebase)
    $askbase = read-host -Prompt "Pick a base host to copy (type the number)"
    $global:basevm = Get-VM -Name $storebase[$askbase-1]
}

#Function that captures the snapshot going to be used.
function funsnap(){
    $storesnap = get-snapshot -VM $global:basevm
    showlist($storesnap)
    $asksnap = read-host -Prompt "Pick a snaphot to use"
    $global:snap = Get-Snapshot -VM $basevm -name $storesnap[$asksnap-1]
}

#Function to assign the vmware host that will be used. 
function funhost(){
    $storehost = get-vmhost
    showlist($storehost)
    $askhost = read-host "Pick a host for the vm to sit on"
    $global:vmhost = get-vmhost -Name $storehost[$askhost-1]
}

#Function to assign th datastore for the vm
function fundstore(){
    $storedstore = get-datastore -refresh
    showlist($storedstore)
    $askdstore = read-host -Prompt "Input the number for the datastore you want to use"
    $global:dstore = get-datastore -name $storedstore[$askdstore-1]
}

#function to assign the folder.
function funfolder(){
    $storefolder = get-folder -Type VM
    showlist($storefolder)
    $askfolder = read-host -Prompt "Input the folders number you want to use: "
    $global:folder = get-folder -name $storefolder[$askfolder-1]
}

#all the functions running
funconnect
funbase
funsnap
funhost
fundstore
funfolder

#Asks the user for the name of the new server and makes the server. 
$name = read-host -prompt "What would you like to name the host?: "

#create the vm
$newvm = New-VM -Name $name -VM $global:basevm -LinkedClone -ReferenceSnapshot `
$global:snap -VMHost $global:vmhost -Datastore $global:dstore -Location $global:folder

