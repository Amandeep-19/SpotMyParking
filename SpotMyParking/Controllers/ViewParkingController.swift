//
//  ViewParkingController.swift
//  SpotMyParking
//
//  Created by Amandeep Bhavra on 2022-01-25.
//

import Foundation

class ViewParkingController {
    
    private var parking:Parking
    
    init(){
        self.parking = Parking()
    }
    
    func fetchUserParking(email: String, completion: @escaping ([String]?, String?) -> Void) {
//        self.parking.getUserParkings(email:email){
//            (parkingList, error) in
//            completion(parkingList,error)
//        }
    }
}
