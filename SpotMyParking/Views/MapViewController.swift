//
//  MapViewController.swift
//  SpotMyParking
//
//  Created by Amandeep Bhavra on 2022-01-25.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    private var locationController = LocationController()
    private var userAnnotation = MKPointAnnotation()
    private var parkingCoordinate = CLLocationCoordinate2D()
    private var errorFlag = false
    var data:NSMutableDictionary = [:]
    var parking:Parking?
    override func viewDidLoad() {
        super.viewDidLoad()
        print("MAP VIEW")
        print(parking?.coordinate)
        print(data["latitude"] as! String)

        if let parking = parking {
//            self.parkingCoordinate = data["latitude"] as! CLLocationCoordinate2D + "," + data["longitude"] as! CLLocationCoordinate2D
        }
        
        self.mapView.delegate = self
        self.locationController.delegate = self
        self.locationController.requestLocationAccess(requireContinuousUpdate: true)
        
        let parkingAnnotation = MKPointAnnotation()
        parkingAnnotation.coordinate = parkingCoordinate
        parkingAnnotation.title = "Parking is here"
        
        userAnnotation.title = "You are here"
        self.mapView.addAnnotation(userAnnotation)
        self.mapView.addAnnotation(parkingAnnotation)
    }
    
    private func showAlert(title:String, message:String) {
        let alertController = UIAlertController(title: title, message:
                                                    message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
        self.present(alertController, animated: true, completion: nil)
    }
}

extension MapViewController : CLLocationManagerDelegate, MKMapViewDelegate{
    func mapView(_mapView: MKMapView,rendererFor overlay: MKOverlay) -> MKOverlayRenderer{
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.black
        renderer.lineWidth = 5.0
        return renderer
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locationController.fetchRoute(sourceCoordinate: manager.location!.coordinate, destinationCoordinate: self.parkingCoordinate){
            (response) in
            
            if let response = response{
                
                if let route = response.routes.first{
                    self.errorFlag = false
                    self.mapView.addOverlay(route.polyline)
                    self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsets.init(top: 80.0, left: 45.0, bottom: 100.0, right: 45.0), animated: true)
                    
                    self.userAnnotation.coordinate = manager.location!.coordinate
                }
            } else{
                if !self.errorFlag{
                    self.errorFlag = true
                    self.showAlert(title: "Error", message: "Unable to process Route")
                }
                self.userAnnotation.coordinate = manager.location!.coordinate
                let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
                let region = MKCoordinateRegion(center: self.userAnnotation.coordinate,span:span)
                self.mapView?.setRegion(region, animated: true)
            }
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if manager.authorizationStatus == .denied {
            self.showLocationServicesAlert()
        } else if manager.authorizationStatus == .authorizedWhenInUse ||
                    manager.authorizationStatus == .authorizedAlways {
            self.locationController.requestLocationAccess(requireContinuousUpdate: true)
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        if manager.authorizationStatus == .denied {
            self.showLocationServicesAlert()
        }
    }
    
    func showLocationServicesAlert() {
        showAlert(title: "Attention", message: "Parking App needs location access for locating your address.\n\nPlease enable by visiting Settings > Privacy > Location Services > ParkingApp")
    }
}
