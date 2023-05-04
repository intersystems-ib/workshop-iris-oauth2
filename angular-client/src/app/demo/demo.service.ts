import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class DemoService {

  constructor(
    private http:HttpClient,
  ) { }

  private urlBase = 'https://webserver/resserver';

  /**
   * Retrieve protected resources from Resource Server (delegated authentication)
   */
  getResource():  Observable<Object> {
    return this.http.get<Object>(
      `${this.urlBase}/protected-resources/`
    );
  }

  /**
   * Retrieve protected resources from Resource Server (delegated authentication)
   */
  getResourceDelegated():  Observable<Object> {
    return this.http.get<Object>(
      `${this.urlBase}/protected-resources-delegated/`
    );
  }

}
