import { NgModule } from '@angular/core';
import { AuthModule, LogLevel } from 'angular-auth-oidc-client';
import { environment } from '../../environments/environment';


@NgModule({
    imports: [AuthModule.forRoot({
        config: {
            authority: 'https://webserver/authserver/oauth2/.well-known/openid-configuration',
            redirectUrl: environment.urlRedirect,
            postLogoutRedirectUri: environment.urlRedirect,
            clientId: 'dQnkkVc-d5GgDY5DQ5heKZ0ePbBlDTE_wGQcNh7KNzM',
            scope: 'openid profile email offline_access my/scope', // 'openid profile ' + your scopes
            responseType: 'code',
            logLevel: LogLevel.Debug,
            renewTimeBeforeTokenExpiresInSeconds: 10,
            secureRoutes: ['https://webserver/resserver/protected-resources/'],
        
            /** token refresh */
            silentRenew: true,
            useRefreshToken: true,
            ignoreNonceAfterRefresh: true, // this is required if the id_token is not returned
            triggerRefreshWhenIdTokenExpired: false, // required when refreshing the browser if id_token is not updated after the first authentication
        }
      })],
    exports: [AuthModule],
})
export class AuthConfigModule {}
