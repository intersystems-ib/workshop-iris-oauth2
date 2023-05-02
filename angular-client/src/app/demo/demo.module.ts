import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { DemoRoutingModule } from './demo-routing.module';
import { HomeComponent } from './home/home.component';
import { SharedModule } from '../shared/shared.module';
import { ProtectedComponent } from './protected/protected.component';


@NgModule({
  declarations: [
    HomeComponent,
    ProtectedComponent
  ],
  imports: [
    CommonModule,
    SharedModule.forRoot(),
    DemoRoutingModule
  ]
})
export class DemoModule { }
