//
//  AddressesCell.swift
//  FuelSrv
//
//  Created by PBS9 on 24/06/19.
//  Copyright © 2019 Dinesh. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
class AddressesCell: UITableViewCell,CLLocationManagerDelegate {

    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var addressTitleLbl: UILabel!
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var cellMenuBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        mapView.dropShadow(view: mapView, opacity: 0.3)
        mapView.layer.cornerRadius = 10
        mapView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func selectedLocation(lat: Double, long: Double)  {

        let camera = GMSCameraPosition.camera(withLatitude: lat , longitude: long , zoom: 14.0)
        let MapView = GMSMapView.map(withFrame: CGRect.init(x: 0, y: 0, width: self.mapView.bounds.size.width, height: self.mapView.bounds.size.height), camera: camera)
        mapView.addSubview(MapView)

        let marker = GMSMarker()
        marker.icon = self.imageWithImage(image: UIImage(named: "Location-icon")!, scaledToSize: CGSize(width: 35.0, height: 35.0))
        marker.position = CLLocationCoordinate2D(latitude: lat , longitude: long )
        //marker.title = name
        marker.map = MapView

    }
    func imageWithImage(image: UIImage,scaledToSize newSize: CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }

    
}
