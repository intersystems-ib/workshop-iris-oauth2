import { Component, OnInit } from '@angular/core';
import { OidcClientNotification, OidcSecurityService, OpenIdConfiguration, UserDataResult } from 'angular-auth-oidc-client';
import { DemoService } from '../demo.service';
import { Observable } from 'rxjs';

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.scss']
})
export class HomeComponent implements OnInit {
  userData!: UserDataResult;
  isAuthenticated = false;
  accessToken!: string;
  idToken!: string;
  
  constructor(
    public oidcSecurityService: OidcSecurityService,
    public demoService: DemoService,
  ) {}

  ngOnInit() {
    /*
    this.oidcSecurityService.checkAuth().subscribe(({ isAuthenticated, userData, accessToken, idToken, configId }) => {
      ;
    });
    */

    this.oidcSecurityService.isAuthenticated$.subscribe(({ isAuthenticated }) => {
      this.isAuthenticated = isAuthenticated;
    });

    this.oidcSecurityService.userData$.subscribe(({ userData }) => {
      this.userData = userData;
    });

    this.oidcSecurityService.getAccessToken().subscribe((token) => {
      this.accessToken = token;
    });

    this.oidcSecurityService.getIdToken().subscribe((token) => {
      this.idToken = token;
    });
  }

  login() {
    this.oidcSecurityService.authorize();
  }

}
