//
//  AddParkingController.swift
//  SpotMyParking
//
//  Created by Amandeep Bhavra on 2022-01-24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class AddParkingController {
    
    private var parking:Parking
    
    init() {
        self.parking = Parking()
    }
    
    func addParking(email:String,buildingCode:String, parkingHours:Double, carPlateNumber:String, suitNumber:String, address:String, lat:Double, long:Double, completion:@escaping (String?) -> Void) {
        self.parking.email = Constants.CurrentUserEmail
        self.parking.buildingCode = buildingCode
        self.parking.parkingHours = parkingHours
        self.parking.carPlateNumber = carPlateNumber
        self.parking.suitNumber = suitNumber
        self.parking.streetAddress = address
        self.parking.coordinate.latitude = lat
        self.parking.coordinate.longitude = long
        self.parking.dateTime = Timestamp()
        self.parking.addParking(email: Constants.CurrentUserEmail,parking: self.parking){
            (error) in
            completion(error)
        }
    }
}
