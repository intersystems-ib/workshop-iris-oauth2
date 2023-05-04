import { Component, OnInit } from '@angular/core';
import { DemoService } from '../demo.service';

@Component({
  selector: 'app-protected',
  templateUrl: './protected.component.html',
  styleUrls: ['./protected.component.scss']
})
export class ProtectedComponent implements OnInit {

  resourceServerResponse!: any;
  resourceServerResponseDelegated!: any;

  constructor(
    public demoService: DemoService
  ){}

  ngOnInit() {
    this.demoService.getResource().subscribe((data) => {
      this.resourceServerResponse = data;
    });

    this.demoService.getResourceDelegated().subscribe((data) => {
      this.resourceServerResponseDelegated = data;
    });
  }

}
