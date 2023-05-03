"use strict";(self.webpackChunkangular_auth_demo=self.webpackChunkangular_auth_demo||[]).push([[884],{884:(x,a,r)=>{r.r(a),r.d(a,{DemoModule:()=>D});var i=r(6895),u=r(8996),e=r(4650),l=r(3790),h=r(529);let m=(()=>{class t{constructor(o){this.http=o,this.urlBase="https://webserver/resserver/protected-resources"}getResource(){return this.http.get(`${this.urlBase}/`)}}return t.\u0275fac=function(o){return new(o||t)(e.LFG(h.eN))},t.\u0275prov=e.Yz7({token:t,factory:t.\u0275fac,providedIn:"root"}),t})();var d=r(4859),g=r(7392),v=r(266);function A(t,n){if(1&t&&(e.TgZ(0,"div",3)(1,"small"),e._uU(2,"User data:"),e.qZA(),e.TgZ(3,"pre"),e._uU(4),e.ALo(5,"json"),e.qZA(),e.TgZ(6,"small"),e._uU(7,"Access Token:"),e.qZA(),e.TgZ(8,"pre"),e._uU(9),e.ALo(10,"json"),e.qZA(),e.TgZ(11,"small"),e._uU(12,"ID Token:"),e.qZA(),e.TgZ(13,"pre"),e._uU(14),e.ALo(15,"json"),e.qZA(),e.TgZ(16,"a",4),e._uU(17," Protected Resources "),e.TgZ(18,"mat-icon"),e._uU(19,"shield"),e.qZA()()()),2&t){const o=e.oxw();e.xp6(4),e.hij("",e.lcZ(5,3,o.userData),"\n  "),e.xp6(5),e.hij("",e.lcZ(10,5,o.accessToken),"\n  "),e.xp6(5),e.hij("",e.lcZ(15,7,o.idToken),"\n  ")}}function f(t,n){if(1&t){const o=e.EpF();e.TgZ(0,"div")(1,"button",5),e.NdJ("click",function(){e.CHM(o);const s=e.oxw();return e.KtG(s.login())}),e._uU(2," Login "),e.TgZ(3,"mat-icon"),e._uU(4,"login"),e.qZA()()()}}let p=(()=>{class t{constructor(o,c){this.oidcSecurityService=o,this.demoService=c,this.isAuthenticated=!1}ngOnInit(){this.oidcSecurityService.isAuthenticated$.subscribe(({isAuthenticated:o})=>{this.isAuthenticated=o}),this.oidcSecurityService.userData$.subscribe(({userData:o})=>{this.userData=o}),this.oidcSecurityService.getAccessToken().subscribe(o=>{this.accessToken=o}),this.oidcSecurityService.getIdToken().subscribe(o=>{this.idToken=o})}login(){this.oidcSecurityService.authorize()}}return t.\u0275fac=function(o){return new(o||t)(e.Y36(l.J_),e.Y36(m))},t.\u0275cmp=e.Xpm({type:t,selectors:[["app-home"]],decls:8,vars:2,consts:[[1,"h5"],["class","section",4,"ngIf","ngIfElse"],["noAuth",""],[1,"section"],["mat-raised-button","","matTooltip","Access Protected Resources","color","primary","routerLink","/demo/protected"],["mat-raised-button","","matTooltip","Login","color","primary",3,"click"]],template:function(o,c){if(1&o&&(e.TgZ(0,"div")(1,"p",0),e._uU(2,"Angular OAuth2 Demo"),e.qZA(),e.TgZ(3,"small"),e._uU(4,"Welcome to home page!"),e.qZA()(),e.YNc(5,A,20,9,"div",1),e.YNc(6,f,5,0,"ng-template",null,2,e.W1O)),2&o){const s=e.MAs(7);e.xp6(5),e.Q6J("ngIf",c.isAuthenticated)("ngIfElse",s)}},dependencies:[i.O5,d.zs,d.lW,g.Hw,v.gM,u.rH,i.Ts],styles:["pre[_ngcontent-%COMP%]{overflow-y:scroll;max-width:80%;border:.5px solid lightgray;padding:5px;white-space:pre-wrap}.section[_ngcontent-%COMP%]{margin-top:10px}"]}),t})(),T=(()=>{class t{constructor(o){this.demoService=o}ngOnInit(){this.demoService.getResource().subscribe(o=>{this.resourceServerResponse=o})}}return t.\u0275fac=function(o){return new(o||t)(e.Y36(m))},t.\u0275cmp=e.Xpm({type:t,selectors:[["app-protected"]],decls:8,vars:3,consts:[[1,"h5"]],template:function(o,c){1&o&&(e.TgZ(0,"div")(1,"p",0),e._uU(2,"Access to Protected Resources"),e.qZA(),e.TgZ(3,"small"),e._uU(4,"Response from resource server:"),e.qZA(),e.TgZ(5,"pre"),e._uU(6),e.ALo(7,"json"),e.qZA()()),2&o&&(e.xp6(6),e.hij("",e.lcZ(7,1,c.resourceServerResponse),"\n    "))},dependencies:[i.Ts]}),t})();var Z=r(5698),S=r(4004);const y=[{path:"",component:p},{path:"home",component:p},{path:"protected",component:T,canActivate:[(()=>{class t{constructor(o,c){this.oidcSecurityService=o,this.router=c}canActivate(o,c){return this.oidcSecurityService.isAuthenticated$.pipe((0,Z.q)(1),(0,S.U)(({isAuthenticated:s})=>!!s||(console.debug("Authentication required. Redirecting."),this.router.parseUrl("/demo"))))}}return t.\u0275fac=function(o){return new(o||t)(e.LFG(l.J_),e.LFG(u.F0))},t.\u0275prov=e.Yz7({token:t,factory:t.\u0275fac,providedIn:"root"}),t})()]}];let U=(()=>{class t{}return t.\u0275fac=function(o){return new(o||t)},t.\u0275mod=e.oAB({type:t}),t.\u0275inj=e.cJS({imports:[u.Bz.forChild(y),u.Bz]}),t})();var C=r(3973);let D=(()=>{class t{}return t.\u0275fac=function(o){return new(o||t)},t.\u0275mod=e.oAB({type:t}),t.\u0275inj=e.cJS({imports:[i.ez,C.m.forRoot(),U]}),t})()}}]);