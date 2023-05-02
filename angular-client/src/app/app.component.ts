import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { EventTypes, OidcSecurityService, PublicEventsService, UserDataResult } from 'angular-auth-oidc-client';
import { Observable, filter } from 'rxjs';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss']
})
export class AppComponent implements OnInit {
  title = 'angular-auth-demo';
  isAuthenticated = false;
  userData!: any;

  constructor(public oidcSecurityService: OidcSecurityService, private eventService: PublicEventsService, private router: Router) {}

  ngOnInit() {
    this.oidcSecurityService.checkAuth().subscribe(({ isAuthenticated, userData, accessToken, idToken, configId }) => {
      console.log('app authenticated', isAuthenticated);
      console.log(`Current access token is '${accessToken}'`);
    });

    this.oidcSecurityService.isAuthenticated$.subscribe(({ isAuthenticated }) => {
      this.isAuthenticated = isAuthenticated;
    });

    this.oidcSecurityService.userData$.subscribe(({ userData }) => {
      this.userData = userData;
    });

    this.eventService
      .registerForEvents()
      .pipe(filter((notification) => notification.type === EventTypes.CheckSessionReceived))
      .subscribe((value) => console.log('CheckSessionReceived with value from app', value));
  }

  login() {
    this.oidcSecurityService.authorize();
  }

  refreshSession() {
    this.oidcSecurityService.forceRefreshSession().subscribe((result) => console.log(result));
  }

  logout() {
    this.oidcSecurityService.logoff().subscribe((result) => console.log(result));
  }

  logoffLocal() {
    this.oidcSecurityService.logoffLocal();
    this.router.navigate(['/demo'])
  }
  
}
