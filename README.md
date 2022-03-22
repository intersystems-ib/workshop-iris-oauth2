Using OAuth2 in InterSystems IRIS. A simple example.


# Setup

## Modify your local hosts file 

Add a line to resolve `webserver` to 127.0.0.1
```
127.0.0.1 webserver
```

You can find your hosts file in:
| O.S. | File |
| --------- | ----------- |
| MacOS | `/private/etc/hosts` |
| Windows | `c:\Windows\System32\Drivers\etc\hosts` |

## Certificate
There is already a self-signed certificate generated in webserver/ssl-cert.pem, webserver/ssl-cert.key.
You can use this certificate for test purposes.

The certificate has been generated using:
```
openssl req -x509 -newkey rsa:4096 -keyout ssl-cert.key -out ssl-cert.pem -nodes -sha256 -days 999 -subj "/CN=webserver"
```

# Run
Build images:
```
docker-compose build
```

Run containers:
```
docker-compose up -d
```

You should be able to reach:
| Element       | URL |
| ---------  | ----------- |
| Webgateway | https://webserver/csp/bin/Systems/Module.cxw |
| AuthServer | https://webserver/authserver/csp/sys/UtilHome.csp |
| ResServer  | https://webserver/resserver/csp/sys/UtilHome.csp |
| Client     | https://webserver/client/csp/sys/UtilHome.csp |

# AuthServer
In [AuthServer](https://webserver/authserver/csp/sys/UtilHome.csp), create an OAuth server definition:
```
zn "AUTHSERVER"
do ##class(auth.server.Utils).CreateServerConfig()
```
* You can view the definition in *System Administration > Security > OAuth 2.0 > Server*
* After defining the server, `/oauth2` web application has been created.
* The OpenID URL for the server is available at: https://webserver/authserver/oauth2/.well-known/openid-configuration

# Client
In [Client](https://webserver/client/csp/sys/UtilHome.csp), create a new client definition:

* Go to *System Administration > Security > OAuth 2.0 > Client > Create Server Description*
* Issuer endpoint: `https://webserver/authserver/oauth2`
* SSL/TLS configuration: `ssl`

