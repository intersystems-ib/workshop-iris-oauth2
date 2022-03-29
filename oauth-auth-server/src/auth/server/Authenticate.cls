/// 
/// You can also customize:
/// - Login page overriding DisplayLogin()
/// - Consent page overriding DisplayPermissions()
/// 
Class auth.server.Authenticate Extends %OAuth2.Server.Authenticate
{

/// The BeforeAuthenticate method of the Authenticate class is called before any authentication takes place
/// to allow the scope or claims associated with the request to be modified based on
/// scope values or request parameters.
ClassMethod BeforeAuthenticate(scope As %ArrayOfDataTypes, properties As %OAuth2.Server.Properties) As %Status
{
    // you can add here some IDToken claims that will be included when creating IDToken
    set claim = ##class(%OAuth2.Server.Claim).%New()
    set claim.Essential = 1
    set claim.Values = ##class(%ListOfDataTypes).%New()
    do claim.Values.Insert("name")
    do properties.IDTokenClaims.SetAt(claim, "name")

	quit $$$OK
}

}
