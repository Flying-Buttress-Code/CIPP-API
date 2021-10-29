param($tenant)

try {
    $upn = "notRequired@required.com"
    $tokenvalue = ConvertTo-SecureString (Get-GraphToken -AppID 'a0c73c16-a7e3-4564-9a95-2bdf47383716' -RefreshToken $ENV:ExchangeRefreshToken -Scope 'https://outlook.office365.com/.default' -Tenantid $tenant).Authorization -AsPlainText -Force
    $credential = New-Object System.Management.Automation.PSCredential($upn, $tokenValue)
    $session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri "https://ps.outlook.com/powershell-liveid?DelegatedOrg=$($tenant)&BasicAuthToOAuthConversion=true" -Credential $credential -Authentication Basic -AllowRedirection -ErrorAction Continue
    Import-PSSession $session -ea Silentlycontinue -AllowClobber -CommandName "Set-OrganizationConfig",
    Set-OrganizationConfig -AutoExpandingArchive
    Get-PSSession | Remove-PSSession
    Log-request -API "Standards" -tenant $tenant -message "Added Auto Expanding Archive." -sev Info

}
catch {
    Log-request -API "Standards" -tenant $tenant -message "Failed to apply Auto Expanding Archives Error: $($_.exception.message)" -sev Error
}