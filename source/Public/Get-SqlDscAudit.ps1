<#
    .SYNOPSIS
        Get server audit.

    .PARAMETER ServerObject
        Specifies current server connection object.

    .PARAMETER Name
        Specifies the name of the server audit to get.

    .PARAMETER Refresh
        Specifies that the **ServerObject**'s audits should be refreshed before
        trying get the audit object. This is helpful when audits could have been
        modified outside of the **ServerObject**, for example through T-SQL. But
        on instances with a large amount of audits it might be better to make
        sure the **ServerObject** is recent enough, or pass in **AuditObject**.

    .EXAMPLE
        $serverObject = Connect-SqlDscDatabaseEngine -InstanceName 'MyInstance'
        $sqlServerObject | Get-SqlDscAudit -Name 'MyFileAudit'

        Get the audit named **MyFileAudit**.

    .OUTPUTS
        `[Microsoft.SqlServer.Management.Smo.Audit]`.
#>
function Get-SqlDscAudit
{
    [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('UseSyntacticallyCorrectExamples', '', Justification = 'Because the rule does not yet support parsing the code when a parameter type is not available. The ScriptAnalyzer rule UseSyntacticallyCorrectExamples will always error in the editor due to https://github.com/indented-automation/Indented.ScriptAnalyzerRules/issues/8.')]
    [OutputType([Microsoft.SqlServer.Management.Smo.Audit])]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [Microsoft.SqlServer.Management.Smo.Server]
        $ServerObject,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Refresh
    )

    if ($Refresh.IsPresent)
    {
        # Make sure the audits are up-to-date to get any newly created audits.
        $ServerObject.Audits.Refresh()
    }

    $auditObject = $ServerObject.Audits[$Name]

    if (-not $AuditObject)
    {
        $missingAuditMessage = $script:localizedData.Audit_Missing -f $Name

        $writeErrorParameters = @{
            Message = $missingAuditMessage
            Category = 'InvalidOperation'
            ErrorId = 'GSDA0001' # cspell: disable-line
            TargetObject = $Name
        }

        Write-Error @writeErrorParameters
    }

    return $auditObject
}
