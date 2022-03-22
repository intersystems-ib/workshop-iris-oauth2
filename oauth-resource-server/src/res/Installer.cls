Class res.Installer Extends %RegisteredObject
{

XData Setup [ XMLNamespace = INSTALLER ]
{
<Manifest> 
    <Log Text="Creating namespaces..." Level="0"/> 
    <Namespace Name="RESSERVER" Create="yes" Ensemble=""> 
        <Configuration> 
            <Database Name="RESSERVER-DATA" Dir="/usr/irissys/mgr/resserver-data" Create="yes" MountRequired="true" Resource="%DB_DEFAULT" PublicPermissions="RW" MountAtStartup="true"/> 
            <Database Name="RESSERVER-CODE" Dir="/usr/irissys/mgr/resserver-code" Create="yes" MountRequired="true" Resource="%DB_DEFAULT" PublicPermissions="RW" MountAtStartup="true"/> 
        </Configuration>
    </Namespace>
     <!--
     <Namespace Name="%SYS" Create="no">
        <Invoke Class="Security.Applications" Method="Import" CheckStatus="true">
            <Arg Value="/opt/irisapp/install/webapp.xml"/>
        </Invoke>
    </Namespace>
    -->
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

/// Setup RESSERVER
ClassMethod SetupRESSERVER() As %Status
{
    set ns = $namespace
    set ret = $$$OK
    try {
        zn "RESSERVER"

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
