Class res.Server Extends %CSP.REST
{

Parameter OAUTH2APPNAME = "resserver";

Parameter OAUTH2SCOPES = "openid profile email my/scope";

Parameter UseSession As Integer = 1;

Parameter HandleCorsRequest As %Integer = 1;

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
    <Route Method="GET" Url = "/" Call = "ResServer" />
</Routes>
}

/// This is the CORS request handler. User should override this method.
ClassMethod OnHandleCorsRequest(url As %String) As %Status
{
	set url = %request.GetCgiEnv("HTTP_REFERER")
    set origin = $p(url,"/",1,3) // origin = "http(s)://origin.com:port"

    // here you can check specific origins
    // otherway, it will allow all origins (useful while developing only)

	do %response.SetHeader("Access-Control-Allow-Credentials","true")
	do %response.SetHeader("Access-Control-Allow-Methods","GET,POST,PUT,DELETE,OPTIONS")
	do %response.SetHeader("Access-Control-Allow-Origin",origin)
	do %response.SetHeader("Access-Control-Allow-Headers","Access-Control-Allow-Origin, Origin, X-Requested-With, Content-Type, Accept, Authorization, Cache-Control")
	quit $$$OK
}

ClassMethod ResServer() As %Status
{
    // This is a dummy resource server which just gets the access token from the request
    // and uses the introspection endpoint to ensure that the access token is valid.
    // Normally the response would not be security related, but would contain some interesting
    // data based on the request parameters.
    
    // retrieve access token from HTTP request
    set accessToken = ##class(%SYS.OAuth2.AccessToken).GetAccessTokenFromRequest(.status)
    if $$$ISERR(status) {
        set %response.Status = ..#HTTP401UNAUTHORIZED
        write "[Error] GetAccessTokenFromRequest: "_$system.Status.GetErrorText(status),!
        quit $$$OK
    }

    // validate token
    set isJWTValid = ##class(%SYS.OAuth2.Validation).ValidateJWT(
        "resserver",
        accessToken,
        "", // scope check only of client
        "", // aud
        .jwtPayload,
        .securityParameters,
        .sc,
        .jwtHeader
    )
    if (('isJWTValid) || ($$$ISERR(sc))) {
        set %response.Status = ..#HTTP401UNAUTHORIZED
        write "Error Getting Access Token="_$system.Status.GetErrorText(sc),!
        quit $$$OK
    }

    // introspection
    set sc = ##class(%SYS.OAuth2.AccessToken).GetIntrospection("resserver", accessToken, .jsonObject)
    if $$$ISERR(sc) {
        set %response.Status = ..#HTTP401UNAUTHORIZED
        write "Introspection Error="_..EscapeHTML($system.Status.GetErrorText(sc)),!
        quit $$$OK
    }
    
    write { 
        "message": "OAuth 2.0 access token used to authorize resource server (RFC 6749). Access token validated using introspection endpoint (RFC 7662)",
        "tokenScope": (jsonObject.scope),
        "tokenUsername": (jsonObject.username),
        "irisUsername": ($username),
        "irisRoles": ($roles)
    }.%ToJSON()
    
    quit $$$OK
}

}
