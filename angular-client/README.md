# Angular Aut hDemo

This project was generated with [Angular CLI](https://github.com/angular/angular-cli) version 15.0.4.

# Development Environment
* Install Node

* Install local Angular
```
mkdir angular-15
cd angular-15
npm install npm@latest
npm install @angular/cli@15.0.4
```

* Clone project
```
git clone https://github.com/intersystems-ib/workshop-iris-oauth2
cd workshop-iris-oauth2/angular-client
```

* Install dependencies
```
npm install
```

* Run development server
```
ng serve
```

Check http://localhost:4200

# Distribution
```
ng build ---configuration production
```

# Util: angular cli commands used during development

```
ng new angular-auth-demo --routing=true --style=scss
cd angular-auth-demo

ng add @angular/material
npm install bootstrap

ng generate module demo --routing
ng generate component demo/home
ng add angular-auth-oidc-client
ng generate component demo/protected
ng generate service demo/demo
ng generate module shared
```