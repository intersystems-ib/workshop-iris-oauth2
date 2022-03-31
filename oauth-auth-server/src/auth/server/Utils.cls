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
    
    // supported grant types: Authorization Code
    set server.SupportedGrantTypes = "A"

    // use JWT tokens
    set server.GenerateTokenClass = "%OAuth2.Server.JWT"

    // support some specific scopes we can define
    set scopes = ##class(%ArrayOfDataTypes).%New()
    do scopes.SetAt("My own scope", "my/scope")
    set server.SupportedScopes = scopes

    // customize auth server as needed
    set server.AuthenticateClass = "auth.server.Authenticate"
    set server.ValidateUserClass = "auth.server.Validate"
    set server.CustomizationNamespace = "AUTHSERVER"
    set server.CustomizationRoles = "%DB_IRISSYS,%Manager,%DB_%DEFAULT"
    set server.SSLConfiguration = "ssl"

    write server.Save()

    set $namespace = ns
}

}
