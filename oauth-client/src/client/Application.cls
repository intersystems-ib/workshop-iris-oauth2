Class client.Application Extends %CSP.REST
{

Parameter OAUTH2APPNAME = "client-app";

Parameter OAUTH2CLIENTREDIRECTURI = "https://webserver/client/application/";

Parameter OAUTH2SCOPES = "scope1";

Parameter UseSession As Integer = 1;

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
    <Route Method="GET" Url = "/" Call = "ClientApp" />
</Routes>
}

ClassMethod ClientApp() As %Status
{
	write "<html>"

	// check if user is already authorized
	set isAuthorized = ##class(%SYS.OAuth2.AccessToken).IsAuthorized(
		..#OAUTH2APPNAME,
		"",
		..#OAUTH2SCOPES,
		.accessToken,
		.idToken,
		.responseProperties,
		.isAuthorizedError
	)
	if $isobject(isAuthorizedError) {
		write "[Error] IsAuthorized: "_isAuthorizedError.AsString()
		quit $$$OK
	}

	// authorized
    if isAuthorized {

		&html< You are authorized </br> >

		// check if JWT token is valid
   		set isJWTValid = ##class(%SYS.OAuth2.Validation).ValidateJWT(
   			..#OAUTH2APPNAME,
   			accessToken,
   			..#OAUTH2SCOPES,
   			"", // aud
   			.jwtPayload,
   			.securityParameters,
   			.validateJWTStatus,
        	.jwtHeader
   	 	)
		if $$$ISERR(validateJWTStatus) {
			write "[Error] ValidateJWT: "_$system.Status.GetOneErrorText(validateJWTStatus)
			quit $$$OK
		}

		if isJWTValid {
			set formatter = ##class(%JSON.Formatter).%New()
			do formatter.FormatToString(jwtHeader.%ToJSON(), .header)
			do formatter.FormatToString(jwtPayload.%ToJSON(), .payload)
			
			&html< 
				Your JWT token is valid </br>
				<h4>JWT Token</h2>
				<h5>Header</h5>
				<pre>#(header)#</pre>
				<h5>Payload</h5>
				<pre>#(payload)#</pre>
			>
		
			// retrive token introspection information
			set introspectionStatus = ##class(%SYS.OAuth2.AccessToken).GetIntrospection(..#OAUTH2APPNAME, accessToken, .introspectionObj)
			if $$$ISERR(introspectionStatus) {
				write "[Error] GetIntrospection: "_$system.Status.GetOneErrorText(introspectionStatus)
				quit $$$OK
			}
			do formatter.FormatToString(introspectionObj.%ToJSON(), .introspection)
			&html<
				<h4>Introspection</h4>
				<pre>#(introspection)#</pre>
			>

		}
    }

	// user is not authorized
	else {
		
		// get the URL to allow the user retrieve an accessToken using the authorization server
		set url = ##class(%SYS.OAuth2.Authorization).GetAuthorizationCodeEndpoint(
			..#OAUTH2APPNAME,
			..#OAUTH2SCOPES,
			..#OAUTH2CLIENTREDIRECTURI,
			.properties,
			.isAuthorized,
			.getAuthorizationStatus
		)
		if $$$ISERR(getAuthorizationStatus) {
			write "[Error] GetAuthorizationCodeEndpoint: "_$system.Status.GetOneErrorText(getAuthorizationStatus)
			quit $$$OK
		}

		// link to authorization server
		&html<
			You are not authorized </br>
			<h2>OAuth2 Authorization</h2>    
			<a href = "#(url)#">Authorize using <b>AuthServer</b></a>
		>
	}

	write "</html>"

    quit $$$OK
}

}
