//
//  DetailParkingViewController.swift
//  SpotMyParking
//
//  Created by Amandeep Bhavra on 2022-01-26.
//

import UIKit

class DetailParkingViewController: UIViewController {
    
    var data:NSMutableDictionary = [:]
    var parking: Parking?
    private let formatter = DateFormatter()

    @IBOutlet weak var lblBuildingCode: UILabel!
    @IBOutlet weak var lblParkingHours: UILabel!
    @IBOutlet weak var lblSuitNumber: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblCoordinates: UILabel!
    @IBOutlet weak var lblParkedOn: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        lblBuildingCode.text = (data["buildingCode"] as! String)
        lblParkingHours?.text = String(describing: data["parkingHours"])
        lblSuitNumber.text = (data["suitNumber"] as! String)
        lblAddress.text = (data["streetAddress"] as! String)
        lblCoordinates.text = (data["latitude"] as! String) + "° N," + (data["longitude"] as! String) + "° E"
        lblParkedOn.text = (data["ParkingOn"] as! String)
        
    }
    
    @IBAction func btnGetDirection(_ sender: Any) {
        guard let vc = storyboard?.instantiateViewController(identifier: "getDirection") as? MapViewController
        else {
            return
        }
        vc.data = self.data
//        vc.parking = self.parking
        show(vc, sender: self)
    }
}
