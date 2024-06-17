function SecureDelete-File {
    param (
        [string]$FilePath,
        [int]$Passes = 7
    )

    if (-Not (Test-Path $FilePath)) {
        Write-Error "File not found: $FilePath"
        return
    }

    $fileInfo = Get-Item $FilePath
    $fileSize = $fileInfo.Length

    $random = [System.Security.Cryptography.RandomNumberGenerator]::Create()

    for ($pass = 1; $pass -le $Passes; $pass++) {
        $buffer = New-Object byte[] $fileSize
        $random.GetBytes($buffer)
        Set-Content -Path $FilePath -Value $buffer -Encoding Byte
        Write-Output "Pass $pass completed."
    }

    Remove-Item -Path $FilePath -Force
    Write-Output "File securely deleted: $FilePath"
}