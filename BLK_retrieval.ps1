###############################################################
# Bitlocker recovery key lookup in Active Directory           #
# Authored by tincup33                                        #
# v1.6 7/3/2024                                               #
###############################################################


# Bypass execution policy for the current session
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force

# Prompt user for additional searches
$searchAgainPrompt = "Would you like to search for another computer? (Y/N) "

# Ignore red text error for computer not found in Active Directory, there is error handling logic below
$ErrorActionPreference = "SilentlyContinue"

# Function to search for a computer and display its BitLocker recovery keys
function Search-Computer {
    # Get computer name from user and set the name to $ComputerName
    $ComputerName = Read-Host "Enter the computer name"

    # Search for $Computer in Active Directory
    $Computer = Get-ADComputer -Filter { Name -eq $ComputerName }

    if ($Computer) {
        # Get the Distinguished Name of the computer
        $DN = $Computer.DistinguishedName

        # Get the BitLocker recovery key for the computer, if it has one
        $bitkeys = Get-ADObject -Filter { objectclass -eq 'msFVE-RecoveryInformation' } -SearchBase $DN -Properties whenCreated, 'msFVE-RecoveryPassword' | Sort-Object whenCreated -Descending | Select-Object whenCreated, msFVE-RecoveryPassword

        if ($bitkeys) {
            # Initialize a counter for list formatting
            $counter = 1

            # Display the BitLocker recovery keys in a list format
            Write-Host "BitLocker Recovery Keys for $($Computer.Name):" -f Green
            foreach ($key in $bitkeys) {
                Write-Host "$counter. $($key.'msFVE-RecoveryPassword')"
                $counter++
            }
        } else {
            # Display output for computer found in Active Directory but there is no BitLocker key associated with it
            Write-Host "No BitLocker Recovery Key found for $($Computer.Name)" -f Yellow
        }
    } else {
        # Error message for computer not found in Active Directory
        Write-Host "Computer not found in Active Directory!" -f Red
    }
}

# Clear the screen before starting the script
cls

# Initial search
Search-Computer

# Prompt for additional searches
do {
    Write-Host -NoNewline $searchAgainPrompt
    $answer = Read-Host

    if ($answer -eq "Y") {
        Search-Computer
    }
} while ($answer -eq "Y")

# Script exit message
Write-Host ">> EXITING <<" -ForegroundColor Black -BackgroundColor Green

# Pause before returning to command prompt
Start-Sleep -Seconds 1

# Exit script with clear screen command
cls
