# BitLocker Recovery Key Rotation using Microsoft Intune & Graph

## Overview

This repository contains a PowerShell script that **automates BitLocker recovery key rotation** for Windows devices managed by **Microsoft Intune**. The script uses **Microsoft Graph PowerShell** to trigger BitLocker key rotation on-demand for selected devices, ensuring recovery keys are refreshed and securely backed up to **Microsoft Entra ID (Azure AD)**.

This automation is designed for **Endpoint Security**, **IT Operations**, and **Compliance** teams to enforce BitLocker key hygiene and reduce the risk associated with stale or exposed recovery keys.

---

## Why BitLocker Key Rotation Matters

Regular BitLocker recovery key rotation is a security best practice because:

* It limits the impact of compromised or exposed recovery keys
* It strengthens insider threat and incident response controls
* It supports regulatory and audit compliance requirements
* It ensures recovery keys stored in Entra ID remain current

This script enables **bulk and repeatable rotation** across Intune-managed devices.

---

## Script Summary

**Script Name:** `Rotate-BitLockerKeys-Intune.ps1`

The script performs the following actions:

1. Authenticates to Microsoft Graph
2. Reads Intune managed device IDs from a CSV file
3. Triggers BitLocker recovery key rotation per device
4. Ensures the new recovery key is backed up to Entra ID
5. Logs success and failure results

---

## Prerequisites

### PowerShell Requirements

* Windows PowerShell 5.1 or PowerShell 7+
* Microsoft.Graph PowerShell module installed

```powershell
Install-Module Microsoft.Graph -Scope CurrentUser
```

### Required Microsoft Graph Permissions

The signed-in account must have the following **delegated permission**:

* `DeviceManagementManagedDevices.ReadWrite.All`

> **Note:** Admin consent is required to trigger BitLocker key rotation actions.

---

## Input CSV Format

The script expects a CSV file containing **Intune Managed Device IDs**.

### RotateKeysIntuneDeviceID.csv

```csv
DeviceId
3f1c2e4a-9c8d-4f1b-8e2b-123456789abc
b72d9e10-45f3-4b1a-a2f9-abcdef123456
```

### CSV Guidelines

* Header must be exactly `DeviceId`
* Values must be **Intune Managed Device IDs**
* One device per row
* No additional columns

---

## Authentication Flow

The script authenticates to Microsoft Graph using:

```powershell
Connect-MgGraph -Scopes "DeviceManagementManagedDevices.ReadWrite.All"
```

This allows the script to invoke Intune device management actions.

---

## Code Walkthrough

### 1. Importing Device IDs

The script reads Intune-managed device IDs from the CSV file. These IDs uniquely identify devices within Microsoft Intune.

---

### 2. Processing Each Device

Each device ID is processed sequentially:

* The script validates the device ID
* A Graph API POST request is sent to Intune
* BitLocker recovery key rotation is triggered

The script continues processing remaining devices even if individual failures occur.

---

### 3. BitLocker Key Rotation Action

```powershell
Invoke-MgGraphRequest -Method POST \
-Uri "https://graph.microsoft.com/beta/deviceManagement/managedDevices/{deviceId}/rotateBitLockerKeys"
```

This action:

* Generates a new BitLocker recovery key
* Automatically backs up the new key to Entra ID
* Invalidates the previous recovery key

> **Note:** This operation currently requires the Microsoft Graph **beta** endpoint.

---

## Output and Logging

By default, the script writes status messages to the console. Optionally, logging can be enabled to:

* Track successful rotations
* Capture failed operations
* Support audit and troubleshooting scenarios

---

## Security Considerations

* Recovery key values are **never exposed**
* Script requires high-privilege Intune permissions
* Access should be restricted to authorized administrators
* Use least-privilege principles when assigning Graph roles

---

## Limitations

* Uses Microsoft Graph beta endpoint
* Requires delegated authentication (interactive sign-in)
* Device must be Intune-managed and BitLocker-enabled

---

## Ideal Use Cases

* Post-incident BitLocker key rotation
* Insider risk mitigation
* Periodic compliance enforcement
* Device lifecycle events (role change, device handover)

---

## Ideal Audience

* Endpoint Security Engineers
* Intune Administrators
* SOC Analysts
* IT Compliance Teams

---

## Author

**Mohamed Umar Farook S**
---
