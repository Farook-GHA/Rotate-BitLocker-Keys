# -------------------------------------------------------------------
# Script Name : Rotate-BitLockerKeys-Intune.ps1
# Description : Triggers BitLocker recovery key rotation for Intune-
#               managed devices using Microsoft Graph API.
#
# Prerequisites:
# - Microsoft.Graph PowerShell module installed
# - User must have DeviceManagementManagedDevices.ReadWrite.All permission
# - Device IDs must be Intune Managed Device IDs
#
# Note:
# - This script uses Microsoft Graph BETA endpoint
# - Intended for enterprise endpoint security operations
# -------------------------------------------------------------------

# Connect to Microsoft Graph with required permissions
Connect-MgGraph -Scopes "DeviceManagementManagedDevices.ReadWrite.All"

# Path to CSV file containing Intune Managed Device IDs
$csvPath = "DeviceID.csv"

# Import device list from CSV
$deviceList = Import-Csv -Path $csvPath

# Loop through each device entry in the CSV
foreach ($entry in $deviceList) {

    # Extract and trim the Device ID from CSV
    $deviceId = $entry.DeviceId.Trim()

    # Validate that Device ID is not empty or null
    if (![string]::IsNullOrWhiteSpace($deviceId)) {
        try {
            # Informational message before triggering rotation
            Write-Output "Triggering BitLocker recovery key rotation for Device ID: $deviceId"

            # Invoke Microsoft Graph API to rotate BitLocker recovery keys
            # This action generates a new recovery key and backs it up to Azure AD
            Invoke-MgGraphRequest `
                -Method POST `
                -Uri "https://graph.microsoft.com/beta/deviceManagement/managedDevices/$deviceId/rotateBitLockerKeys"

            # Confirmation message after successful execution
            Write-Output "BitLocker recovery key rotation triggered successfully for Device ID: $deviceId"
        }
        catch {
            # Error handling in case the API call fails
            Write-Warning "Failed to rotate BitLocker recovery key for Device ID: $deviceId. Error: $_"
        }
    }
}
