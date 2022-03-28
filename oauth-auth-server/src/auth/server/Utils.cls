Class auth.server.Utils
{

/// do ##class(auth.server.Utils).CreateServerConfig()
ClassMethod CreateServerConfig() As %Status
{
    set ns = $namespace
    set $namespace = "%SYS"

    set server = ##class(OAuth2.Server.Configuration).%New()
    set server.Description = "OAuth2 Auth Server"

    set endpoint = ##class(OAuth2.Endpoint).%New()
    set endpoint.UseSSL = 1
    set endpoint.Host = "webserver"
    set endpoint.Prefix = "authserver"
    set server.IssuerEndpoint = endpoint
    
    // support: Authorization Code + Resource Owner Password Credentials
    set server.SupportedGrantTypes = "AP"

    set scopes = ##class(%ArrayOfDataTypes).%New()
    do scopes.SetAt("test/*", "scope1")
    set server.SupportedScopes = scopes

    set server.AuthenticateClass = "auth.server.Authenticate"
    set server.ValidateUserClass = "auth.server.Validate"
    set server.CustomizationNamespace = "AUTHSERVER"
    set server.CustomizationRoles = "%DB_IRISSYS,%Manager,%DB_%DEFAULT"
    set server.SSLConfiguration = "ssl"

    // use JWT tokens
    set server.GenerateTokenClass = "%OAuth2.Server.JWT"
    
    write server.Save()

    set $namespace = ns
}

}
