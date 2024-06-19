**SecureDelete-File PowerShell Script**

USAGE:
$FilePath = "$env:[PATH-GOES-HERE]"
SecureDelete-File -FilePath $FilePath -Passes 7

Explanation:

    - When a file is created, its content is stored in a specific disk location (bytearray).
    - The file has a pointer to the actual data blocks on disk where the file content is stored.
    - When overwriting, the file system writes new data to the same blocks.
    - The bytearray used is the same size as the original file.
    - By repeatedly writing random data to the file, the script ensures that the original data blocks are overwritten.
    - Each pass writes new random data to the same data blocks, ensuring that the original content is thoroughly overwritten.

This diagram explains how the PowerShell script works:


+-------------------------------------------+
|             SecureDelete-File             | # Function definition
|               (Function)                  |
+----------------------+--------------------+
                       |
                       |
                       v
+-------------------------------------------+
|            Parameters: FilePath,          | # Parameters for file path and passes
|                 Passes                    |
+----------------------+--------------------+
                       |
                       |
                       v
+-------------------------------------------+
|         Check if FilePath Exists          | # Test if the file exists
|            (Test-Path $FilePath)          |
+----------------------+--------------------+
                       |
            +----------+-----------+
            |                      |
            v                      v
+--------------------+   +--------------------+
|   File Exists      |   |  File Not Found    | # If file exists, proceed; otherwise, show error
|                    |   |                    |
|  Proceed to Next   |   |  Write-Error "File |
|       Steps        |   |   not found"       |
+--------------------+   +--------------------+
                       |
                       v
+-------------------------------------------+
|      Get File Information (Get-Item)      | # Get file info and size
|            Get File Size (.Length)        |
+----------------------+--------------------+
                       |
                       v
+-------------------------------------------+
|       Create Random Number Generator      | # Create random number generator
|   ($random = [System.Security.Cryptography|
|   .RandomNumberGenerator]::Create())       |
+----------------------+--------------------+
                       |
                       v
+-------------------------------------------+
|           Loop Through Passes             | # Loop through specified passes
|          (For Each Pass 1 to N)           |
+----------------------+--------------------+
                       |
                       v
+-------------------------------------------+
|           Create Random Data Buffer       | # Create buffer of random data
|          ($buffer = New-Object byte[]     |
|            $fileSize)                     |
+----------------------+--------------------+
                       |
                       v
+-------------------------------------------+
|     Fill Buffer with Random Data          | # Fill buffer with random bytes
|      ($random.GetBytes($buffer))          |
+----------------------+--------------------+
                       |
                       v
+-------------------------------------------+
|  Overwrite File with Random Data          | # Overwrite file with random data
|      (Set-Content -Path $FilePath         |
|        -Value $buffer -Encoding Byte)     |
+----------------------+--------------------+
                       |
                       v
+-------------------------------------------+
|          Repeat for Each Pass             | # Repeat for each pass
+----------------------+--------------------+
                       |
                       v
+-------------------------------------------+
|        Remove the File (Remove-Item)      | # Delete the file
+----------------------+--------------------+
                       |
                       v
+-------------------------------------------+
|        Write Output "File securely        | # Confirm secure deletion
|          deleted: $FilePath"              |
+-------------------------------------------+