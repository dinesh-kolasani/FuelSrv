//
//  MapView.swift
//  FuelSrv
//
//  Created by Shine New on 14/04/19.
//  Copyright © 2019 Dinesh. All rights reserved.
//

import Foundation
import GoogleMaps

class MapView: GMSMapView,GMSMapViewDelegate{
    
    var cameraPosition : GMSCameraPosition?
    var mapIdleAt : ((CLLocationCoordinate2D) -> Void)?
    
    override func awakeFromNib() {
        self.delegate = self
        
    }
    
    func updateMapCamera(location:CLLocation){
        
        cameraPosition = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: 17.0)
        self.animate(to: cameraPosition!)
    }
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        self.mapIdleAt?(position.target)
    }
    
}
