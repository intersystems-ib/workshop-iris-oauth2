Class auth.server.Authenticate Extends %OAuth2.Server.Authenticate
{

ClassMethod BeforeAuthenticate(scope As %ArrayOfDataTypes, properties As %OAuth2.Server.Properties) As %Status
{
    // IDToken claims
    set claim = ##class(%OAuth2.Server.Claim).%New()
    set claim.Essential = 1
    set claim.Values = ##class(%ListOfDataTypes).%New()
    do claim.Values.Insert("name")
    Do properties.IDTokenClaims.SetAt(claim, "name")

	Quit $$$OK
}

}
