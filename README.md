# BitLocker-Key-Retrieval-from-Active-Directory

Interactive PowerShell script that will recover BitLocker keys from Active Directory.


The script will ask for a system name and if the system has a BitLocker key associated with it, the key will be returned in the terminal window.

If the system has more than one key associated with it, the script will return all of the keys in a list format with the most recent one at the top of the list.

If the system does not have a BitLocker key associated with it, the script will return with a message saying there is no key found for that system.

If the system is not found in Active Directory, the script will return a message saying that the system was not found in Active Directory.
