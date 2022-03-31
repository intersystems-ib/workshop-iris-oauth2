Class auth.Installer Extends %RegisteredObject
{

XData Setup [ XMLNamespace = INSTALLER ]
{
<Manifest> 
    <Log Text="Creating namespaces..." Level="0"/> 
    <Namespace Name="AUTHSERVER" Create="yes" Ensemble=""> 
        <Configuration> 
            <Database Name="AUTHSERVER-DATA" Dir="/usr/irissys/mgr/auth-server-data" Create="yes" MountRequired="true" Resource="%DB_DEFAULT" PublicPermissions="RW" MountAtStartup="true"/> 
            <Database Name="AUTHSERVER-CODE" Dir="/usr/irissys/mgr/auth-server-code" Create="yes" MountRequired="true" Resource="%DB_DEFAULT" PublicPermissions="RW" MountAtStartup="true"/> 
        </Configuration>
    </Namespace>
    <Namespace Name="%SYS" Create="no">
        <Invoke Class="Security.SSLConfigs" Method="Import" CheckStatus="true">
            <Arg Value="/opt/irisapp/install/ssl.xml"/>
        </Invoke>
    </Namespace>
    <Namespace Name="%SYS" Create="no">
        <Invoke Class="Security.Users" Method="Import" CheckStatus="true">
            <Arg Value="/opt/irisapp/install/user-developer.xml"/>
        </Invoke>
    </Namespace>
</Manifest>
}

/// Setup method
ClassMethod RunManifest(ByRef pVars, pLogLevel As %Integer = 0, pInstaller As %Installer.Installer) As %Status [ CodeMode = objectgenerator, Internal ]
{
    Quit ##class(%Installer.Manifest).%Generate(%compiledclass, %code, "Setup")
}

/// Setup environment: create namespaces, system configuration, etc.    
ClassMethod SetupEnvironment(ByRef vars) As %Status
{
    set ns = $namespace
    try { 
        $$$ThrowOnError(..RunManifest(.vars)) 

    } catch ex { 
        set sc = ex.AsStatus() 
        write $system.Status.GetErrorText(sc),!
        do $system.Process.Terminate($job,1) 
    }
    set $namespace = ns
    quit sc
}

/// Setup AUTHSERVER
ClassMethod SetupAUTHSERVER() As %Status
{
    set ns = $namespace
    set ret = $$$OK
    try {
        zn "AUTHSERVER"

        // load src
        $$$ThrowOnError($SYSTEM.OBJ.LoadDir("/opt/irisapp/src/", "ck", .errorlog, 1))

    } catch ex {
        set ret = ex.AsStatus() 
        write $system.Status.GetErrorText(ret),! 
        do $system.Process.Terminate($job,1) 
    }
    set $namespace = ns
    quit ret
}

}
