Class auth.server.Validate Extends %OAuth2.Server.Validate
{

/// Your custom ValidateUser method must return true (1) only if the username and password refer to a valid user
/// based on whatever criteria you choose to implement.  It must return false in other cases. <p>
/// If password="", then the user is already logged into an existing session and the password
/// does not need to be validated.<p>
/// In addition, this method receives the properties array and can further modify it;
/// this correspond to the Properties property of %OAuth2.Server.Token. 
/// The authorization server will always add the "iss" (URL of authorization server),
/// "sub" (client_id), and "exp" (expiration time in seconds since December 31st, 1840)
/// to ClaimValues and "client_id" (client_id of the requesting client) to CusotmProperties 
/// after return from ValidateUser if they have not already been added.<p>
/// This sample ValidateUser method validates the user based on the users for this instance.
ClassMethod ValidateUser(username As %String, password As %String, scope As %ArrayOfDataTypes, properties As %OAuth2.Server.Properties, Output sc As %Status) As %Boolean
{
	set $namespace = "%SYS"
    set ret = ##super(username, password, scope, properties, .sc)

    set $namespace = "AUTHSERVER"
    quit ret
}

/// The ValidateClient method returns true (1), if the client_id and client_secret refer to a
/// client computer which may use the client credentials grant type based on whatever criteria
/// the method chooses to implement.  This client will already have been verified to be registered 
/// to this authorization server and thus will usually be accepted.
/// ValidateClient populates the properties array argument with any properties needed to generate the access token.
/// This correspond to the Properties arguments of OAuth2.Server.Token.
/// The authorization server will always add the "iss" (URL of authorization server),
/// "sub" (client_id), and "exp" (expiration time in seconds since December 31st, 1840)
/// to ClaimValues and "client_id" (client_id of the requesting client) to CusotmProperties 
/// after return from ValidateUser if they have not already been added.<br>
/// If not valid then false is returned.<br>
/// This default ValidateClient accepts all clients and adds no properties.
ClassMethod ValidateClient(clientId As %String, clientSecret As %String, scope As %ArrayOfDataTypes, Output properties As %OAuth2.Server.Properties, Output sc As %Status) As %Boolean
{
    set $namespace = "%SYS"
    set ret = ##super(clientId, clientSecret, scope, .properties, .sc)
	
    set $namespace = "AUTHSERVER"
    quit ret
}

}
