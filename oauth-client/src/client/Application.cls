Class client.Application Extends %CSP.REST
{

Parameter OAUTH2APPNAME = "client-app";

Parameter OAUTH2CLIENTREDIRECTURI = "https://webserver/client/application/";

Parameter OAUTH2SCOPES = "openid profile email my/scope";

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

	&html< <h1>Authorization</h1> >

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
				<h4>Access Token</h4>
				<pre>#(accessToken)#</pre>
				<h4>JWT</h4>
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

			// validate IDToken
			set valid = ##class(%SYS.OAuth2.Validation).ValidateIDToken(..#OAUTH2APPNAME, idToken, accessToken, ..#OAUTH2SCOPES, "" /*aud*/, .idTokenObj, .secParam, .sc) 
			if $$$ISERR(sc) {
				write "[Error] ValidateIDToken: "_$system.Status.GetOneErrorText(sc)
				quit $$$OK
			}

			// get user info
			set sc = ##class(%SYS.OAuth2.AccessToken).GetUserinfo(..#OAUTH2APPNAME, accessToken, "", .userInfoObj, .secParam)
			if $$$ISERR(introspectionStatus) {
				write "[Error] GetUserinfo: "_$system.Status.GetOneErrorText(sc)
				quit $$$OK
			}

			do formatter.FormatToString(idTokenObj.%ToJSON(), .idTokenObjFormatted)
			do formatter.FormatToString(userInfoObj.%ToJSON(), .userInfoObjFormatted)
			&html<
				<h4>IDToken</h4>
				<pre>#(idToken)#</pre>
				<pre>#(idTokenObjFormatted)#</pre>
				<h4>UserInfo</h4>
				<pre>#(userInfoObjFormatted)#</pre>
			>

			// access protected resources from resource server
			set httpRequest = ##class(%Net.HttpRequest).%New()
			set httpRequest.Server = "webserver"
			set httpRequest.Https = 1
			set httpRequest.SSLConfiguration = "ssl"

			set addTokenStatus = ##class(%SYS.OAuth2.AccessToken).AddAccessToken(httpRequest, "header", "ssl", ..#OAUTH2APPNAME)
			if $$$ISERR(addTokenStatus) {
				write "[Error] AddAccessToken: "_$system.Status.GetOneErrorText(addTokenStatus)
				quit $$$OK
			}

			do httpRequest.Get("/resserver/protected-resources/")
			set response = httpRequest.HttpResponse
			&html<
				<h1>Access to resource server</h1>
				Using token provided by authorization server to access https://webserver/resserver/protected-resources/ ...
				<h4>Response</h4>
				<pre>#(httpRequest.HttpResponse.StatusCode)#</pre>
				<pre>#(httpRequest.HttpResponse.Data.Read())#</pre> 
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
