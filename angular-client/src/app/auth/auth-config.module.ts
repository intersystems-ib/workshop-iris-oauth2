import { NgModule } from '@angular/core';
import { AuthModule, LogLevel } from 'angular-auth-oidc-client';


@NgModule({
    imports: [AuthModule.forRoot({
        config: {
            authority: 'https://webserver/authserver/oauth2/.well-known/openid-configuration',
            redirectUrl: 'http://localhost:8080/demo',
            postLogoutRedirectUri: 'http://localhost:8080/demo',
            clientId: 'dQnkkVc-d5GgDY5DQ5heKZ0ePbBlDTE_wGQcNh7KNzM',
            scope: 'openid profile email offline_access my/scope', // 'openid profile ' + your scopes
            responseType: 'code',
            logLevel: LogLevel.Debug,
            //silentRenewUrl: window.location.origin + '/silent-renew.html',
            renewTimeBeforeTokenExpiresInSeconds: 10,
            secureRoutes: ['https://webserver/resserver/protected-resources/'],
        
            silentRenew: true,
            useRefreshToken: true,
            ignoreNonceAfterRefresh: true, // this is required if the id_token is not returned
            triggerRefreshWhenIdTokenExpired: false, // required when refreshing the browser if id_token is not updated after the first authentication
            // allowUnsafeReuseRefreshToken: true, // this is required if the refresh token is not rotated
            // autoUserInfo: false, // if the user endpoint is not supported
            
        }
      })],
    exports: [AuthModule],
})
export class AuthConfigModule {}
