<#
    .SYNOPSIS
        Connect to a SQL Server Database Engine and return the server object.

    .PARAMETER ServerName
        String containing the host name of the SQL Server to connect to.
        Default value is the current computer name.

    .PARAMETER InstanceName
        String containing the SQL Server Database Engine instance to connect to.
        Default value is 'MSSQLSERVER'.

    .PARAMETER Credential
        The credentials to use to impersonate a user when connecting to the
        SQL Server Database Engine instance. If this parameter is left out, then
        the current user will be used to connect to the SQL Server Database Engine
        instance using Windows Integrated authentication.

    .PARAMETER LoginType
        Specifies which type of logon credential should be used. The valid types
        are 'WindowsUser' or 'SqlLogin'. Default value is 'WindowsUser'
        If set to 'WindowsUser' then the it will impersonate using the Windows
        login specified in the parameter Credential.
        If set to 'WindowsUser' then the it will impersonate using the native SQL
        login specified in the parameter Credential.

    .PARAMETER StatementTimeout
        Set the query StatementTimeout in seconds. Default 600 seconds (10 minutes).

    .EXAMPLE
        Connect-SqlDscDatabaseEngine

        Connects to the default instance on the local server.

    .EXAMPLE
        Connect-SqlDscDatabaseEngine -InstanceName 'MyInstance'

        Connects to the instance 'MyInstance' on the local server.

    .EXAMPLE
        Connect-SqlDscDatabaseEngine -ServerName 'sql.company.local' -InstanceName 'MyInstance'

        Connects to the instance 'MyInstance' on the server 'sql.company.local'.

    .OUTPUTS
        None.
#>
function Connect-SqlDscDatabaseEngine
{
    [CmdletBinding(DefaultParameterSetName = 'SqlServer')]
    param
    (
        [Parameter(ParameterSetName = 'SqlServer')]
        [Parameter(ParameterSetName = 'SqlServerWithCredential')]
        [ValidateNotNull()]
        [System.String]
        $ServerName = (Get-ComputerName),

        [Parameter(ParameterSetName = 'SqlServer')]
        [Parameter(ParameterSetName = 'SqlServerWithCredential')]
        [ValidateNotNull()]
        [System.String]
        $InstanceName = 'MSSQLSERVER',

        [Parameter(ParameterSetName = 'SqlServerWithCredential', Mandatory = $true)]
        [ValidateNotNull()]
        [Alias('SetupCredential', 'DatabaseCredential')]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter(ParameterSetName = 'SqlServerWithCredential')]
        [ValidateSet('WindowsUser', 'SqlLogin')]
        [System.String]
        $LoginType = 'WindowsUser',

        [Parameter()]
        [ValidateNotNull()]
        [System.Int32]
        $StatementTimeout = 600
    )

    # Call the private function.
    return (Connect-Sql @PSBoundParameters)
}
