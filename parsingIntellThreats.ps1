# Array of websites containing threat intell
$drop_urls = @('https://rules.emergingthreats.net/blockrules/emerging-botcc.rules','https://rules.emergingthreats.net/blockrules/compromised-ips.txt')

# Loop through the URLs for the rules list
foreach ($u in $drop_urls){

    # Extract the filename
    $temp = $u.split("/")

    $temp

   
   # The last element in the array plucked off is the filename
   $file_name = "./" + $temp[4]

   # Download the rules list
   #Invoke-WebRequest -Uri $u -OutFile $file_name
}

# Array containing the filename
$input_paths = @(".\compromised-ips.txt",".\emerging-botcc.rules")

# Extract the IP addresses.
# [154.35.4.107,154.35.64.18]
# \d = digit
# \b boundary
$regex_drop = '\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b' 
# Append the IP addresses to the temporary IP list.
Select-string -Path $input_paths -Pattern $regex_drop -AllMatches | ForEach-Object {$_.Matches} | % { $_.Value } | sort | Get-Unique -AsString | Out-File 'ips-bad.txt'

# Get the IP addresses discovered, loop through and replace the beginning of the line with the IPTables syntax
# After the IP address, add the remaining IPTables syntax and save the results to a file.
# (Get-Content -Path ".\ips-bad.txt") | % { $_ -replace "^", "iptables -A INPUT -s " -replace "$"," -j DROP" } `
#| Set-Content -Path ".\ips-bad-iptables.bash"

#Task: Replacethe Iptables syntax above with the cisco rulesets syntax. sample: access-list 1 deny host 1.1.1.2
(Get-Content -Path ".\ips-bad.txt") | % { $_ -replace "^", "access-list 1 deny host " } #
# | Set-Content -Path ".\ips-bad-cisco.txt""