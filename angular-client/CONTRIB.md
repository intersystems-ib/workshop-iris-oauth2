

ng new angular-auth-demo --routing=true --style=scss

cd angular-auth-demo
ng generate module demo --routing
ng generate component demo/home
ng generate component demo/protected
ng generate service demo/demo

ng add @angular/material

ng generate module shared
npm install bootstrap

zn "CLIENT"
set ^%ISCLOG=5
zn "%SYS"
do ##class(%OAuth2.Utils).DisplayLog("/app/debug1.log")
kill ^ISCLOG

%SYS>set client=##class(OAuth2.Client.Metadata).%OpenId(3)
%SYS>set client."post_logout_redirect_uris" = $lb("http://localhost:4200/demo", "http://localhost:4200/home")
%SYS>write client.%Save()



