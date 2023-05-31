Class auth.server.Utils
{

/// do ##class(auth.server.Utils).CreateServerConfig()
ClassMethod CreateServerConfig()
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

    set server.SupportSession = 0
    set server.ReturnRefreshToken = "f"
    set server.AllowPublicClientRefresh = 1
    
    // supported grant types: Authorization Code, Client Credentials
    set server.SupportedGrantTypes = "AC"

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

/// do ##class(auth.server.Utils).CreateAngularAppClient()
ClassMethod CreateAngularAppClient()
{
    set ns = $namespace
    set $namespace = "%SYS"
    
    set client = ##class(OAuth2.Server.Client).%New()
    set client.ClientId = "dQnkkVc-d5GgDY5DQ5heKZ0ePbBlDTE_wGQcNh7KNzM"
    set client.Name = "angular-app"
    set client.ClientType = "public"
    set client.DefaultScope = ""
    set client.Description = ""
    do client.RedirectURL.Insert("http://localhost:8080/demo")
    do client.RedirectURL.Insert("http://localhost:4200/demo")

    Set client.SupportedGrantTypes = "A"
    Set client.Metadata."token_endpoint_auth_method" = "client_secret_post"
    set client.Metadata."response_types" = $lb("code", "id_token", "id_token token", "token") 

    set client.Metadata."access_token_encrypted_response_alg" = "none"
    set client.Metadata."access_token_encrypted_response_enc"="none"
    set client.Metadata."access_token_signed_response_alg"="none"
    set client.Metadata."frontchannel_logout_session_required"=0
    set client.Metadata."id_token_encrypted_response_alg"="none"
    set client.Metadata."id_token_encrypted_response_enc"="none"
    set client.Metadata."request_object_encryption_alg"="none"
    set client.Metadata."request_object_encryption_enc"="none"
    set client.Metadata."request_object_signing_alg"="none"
    set client.Metadata."userinfo_encrypted_response_alg"="none"
    set client.Metadata."userinfo_encrypted_response_enc"="none"
    set client.Metadata."userinfo_signed_response_alg"="none"
    set client.Metadata."post_logout_redirect_uris" = $lb("http://localhost:8080/demo", "http://localhost:4200/demo")

    set sc = client.Save()
    if $$$ISERR(sc) {
        do $system.Status.DisplayError(sc)
    }
    
    set $namespace = ns
}

/// Generate TOTP QR
/// do ##class(auth.server.Utils).GenerateTOTP("user", "/app/qrcode.png", "N4WMW25OA3JME2ZSZ7SVRYMCR373YKBV")
/// - Use this method to generate a QR Code
/// - Scan QR in Google Authenticator
/// - Use TestTOTP method to test TOTP validation with different timestamps
ClassMethod GenerateTOTP(account As %String = "user", qrFilename As %String = "/app/qrcode.png", secretBase32 As %String = "", issuer As %String = {"InterSystemsIRIS-"_##class(%SYS.System).GetNodeName(1)_"-"_##class(%SYS.System).GetInstanceName()}) As %Status
{
    set ret = $$$OK
    try {
        set secret = ""

        if secretBase32 = "" {
            set secret = $system.Encryption.GenCryptRand(20)
            set secretBase32 = $system.Encryption.Base32Encode(secret)
        } else {
            set secret = ##class(%SYSTEM.Encryption).Base32Decode(secretBase32)
        }
        
        set qrString = "otpauth://totp/"_issuer_":"_account_"?secret="_secretBase32_"&issuer="_issuer
        $$$ThrowOnError(##class(%SYS.QRCode).GenerateFile(qrString, qrFilename))

    } catch ex {
        set ret = ex.AsStatus()
    }
    quit ret
}

/// Test TOTP validation with different timestamps
/// do ##class(auth.server.Utils).TestTOTP("N4WMW25OA3JME2ZSZ7SVRYMCR373YKBV", "12345")
ClassMethod TestTOTP(secretBase32 = "", totp As %String = "")
{
    set secret = ##class(%SYSTEM.Encryption).Base32Decode(secretBase32)
	
    // test TOTP validate with different timestamps
    write "No TimeStamp",?40,##class(%SYSTEM.Encryption).TOTPValidate(totp, secret),!
    for i=-60,-30,0,30,60 {
		Set timestamp = $piece($horolog, ",", 1)_","_($piece($horolog, ",", 2)+i)
		Write "Time ",i,"S ",$zdatetime(timestamp,3),?40,##class(%SYSTEM.Encryption).TOTPValidate(totp, secret, , timestamp, 30, 1, 6, 0),!
	}
}

}
