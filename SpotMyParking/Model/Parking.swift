//
//  Parking.swift
//  SpotMyParking
//
//  Created by Amandeep Bhavra on 2022-01-24.
//
import Foundation
import MapKit
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Parking : Codable {
    
    private let db = Firestore.firestore()
    
//    @DocumentID var id:String?
    var email = Constants.CurrentUserEmail
    var buildingCode:String
    var parkingHours:Double
    var carPlateNumber:String
    var suitNumber:String
    var streetAddress:String
    var coordinate:CLLocationCoordinate2D
    var latitude:String
    var longitude:String
    var dateTime:Timestamp
    
    init() {
        self.buildingCode = ""
        self.parkingHours = 0.0
        self.carPlateNumber = ""
        self.suitNumber = ""
        self.streetAddress = ""
        self.coordinate = CLLocationCoordinate2D()
        self.latitude = ""
        self.longitude = ""
        self.dateTime = Timestamp()
    }
    
    enum CodingKeys : String, CodingKey {
        case buildingCode = "buildingCode"
        case parkingHours = "parkingHours"
        case carPlateNumber = "carPlateNumber"
        case suitNumber = "suitNumber"
        case streetAddress = "streetAddress"
        case coordinate = "coordinate"
        case latitude = "latitude"
        case longitude = "longitude"
        case dateTime = "dateTime"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.buildingCode, forKey: .buildingCode)
        try container.encode(self.parkingHours, forKey: .parkingHours)
        try container.encode(self.carPlateNumber, forKey: .carPlateNumber)
        try container.encode(self.suitNumber, forKey: .suitNumber)
        try container.encode(self.streetAddress, forKey: .streetAddress)
        try container.encode(GeoPoint.init(latitude: self.coordinate.latitude, longitude: self.coordinate.longitude), forKey: .coordinate)
        try container.encode(self.latitude, forKey: .latitude)
        try container.encode(self.longitude, forKey: .longitude)
        try container.encode(self.dateTime, forKey: .dateTime)
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
//        self._id = try values.decode(DocumentID<String>.self, forKey: .id)
        self.buildingCode = try values.decode(String.self, forKey: .buildingCode)
        self.parkingHours = try values.decode(Double.self, forKey: .parkingHours)
        self.carPlateNumber = try values.decode(String.self, forKey: .carPlateNumber)
        self.suitNumber = try values.decode(String.self, forKey: .suitNumber)
        self.streetAddress = try values.decode(String.self, forKey: .streetAddress)
        let geoPoint = try values.decode(GeoPoint.self, forKey: .coordinate)
        self.coordinate = CLLocationCoordinate2D(latitude: geoPoint.latitude, longitude: geoPoint.longitude)
        self.latitude = String(geoPoint.latitude)
        self.longitude = String(geoPoint.longitude)
        self.dateTime = try values.decode(Timestamp.self, forKey: .dateTime)
    }
    
    func addParking(email:String, parking:Parking, completion: @escaping (String?) -> Void ){
        let today = Date()
        let formatter3 = DateFormatter()
        formatter3.dateFormat = "MMM d, yyyy, hh:mm a"
        formatter3.amSymbol = "AM"
        formatter3.pmSymbol = "PM"
        
        let timeStamp = formatter3.string(from: today)
        
        let objParking = [
            "buildingCode"  :self.buildingCode,
            "parkingHours"  :self.parkingHours,
            "carPlateNumber":self.carPlateNumber,
            "suitNumber"    :self.suitNumber,
            "streetAddress" :self.streetAddress,
            "coordinate"    :"coordinate",
            "latitude"      :self.coordinate.latitude,
            "longitude"     :self.coordinate.longitude,
            "Date"          :self.dateTime,
            "ParkingOn"     :timeStamp
        ] as [String : Any]
        
        self.db.collection("parkingSpot").getDocuments { [self]
            (queryResults, error) in
            if let err = error {
                print("Error getting documents from parkingSPot collection -> \(err)")
                return
            } else {
                let coll = "parkingSpot/parking/" + email
                self.db.collection(coll).document(streetAddress).setData(objParking as [String : Any]) { (error) in
                    if let err = error {
                        print("Error when saving document -> \(err)")
                        return
                    } else {
                        print("document saved successfully");
//                        showSuccessAlert()
                        }
                    }
                }
            }
        
        /*do {
            let coll = "parkingSpot/users/" + email + "/parking"
          //  var coll = "users" + userID + "parkings"
             try self.db.collection(coll).addDocument(from : parking){
                 (error) in  
                if let error = error {
                    completion("Unable to add parking. Please Try again. Error: \(error)")
                } else {
                    completion(nil)
                }
            }
        } catch {
            print(error)
        }*/
    }
    
    func getParkingByDocumentID(_ documentID:String, completion: @escaping (Parking) -> Void) {
        self.db.collection("parkings").document(documentID).getDocument{
            (queryResult, error) in
            
            if let error = error {
                print("Error occured when fetching parking from firestore. Error: \(error)")
                return
            } else {
                do {
                    if let parking = try queryResult?.data(as : Parking.self) {
                        completion(parking)
                    } else {
                        print("No parking found")
                    }
                } catch {
                    print(error)
                }
            }
        }
    }
    
    func getUserParkings(email:String, completion: @escaping ([Parking]?, String?) -> Void) {
        let path = "parkingSpot/parking/" + Constants.CurrentUserEmail
        self.db.collection(path).order(by: "Date", descending: true).getDocuments(){
            (queryResults, error) in
            
            if error != nil {
                completion(nil,"An internal error occured")
            } else if queryResults!.documents.count == 0 {
                completion(nil, "No parkings added")
            } else {
                do {
                    var parkingList:[Parking] = [Parking]()
                    print("queryResults!.documents queryResults!.documents queryResults!.documents")
                    print(queryResults!.documents)
                    for result in queryResults!.documents {
                        print("result result result result result ")
                        print(result.data())
                        /*if let parking = try result.data(as : Parking.self) {
                            parkingList.append(parking)
                        }*/
                    }
                    completion(parkingList, nil)
                } catch {
                    print(error)
                }
            }
        }
    }
}

//import Foundation
//import FirebaseFirestore
//
//protocol DocumentSerializable{
//    init?(dictionary:[String:Any])
//}
//
//struct Parking {
//    var buildingCode:String
//    var hours:String
//    var licencePlateNo:String
//    var suitNo: String
//    var parkingLoc:String
//
//
//    var dictionary:[String:Any]{
//        return[
//           "buildingCode":buildingCode,
//            "hours": hours,
//            "licencePlateNo":licencePlateNo,
//            "suitNo": suitNo,
//           "parkingLoc": parkingLoc
//
//        ]
//    }
//}
//
//extension Parking : DocumentSerializable{
//    init?(dictionary:[String:Any]) {
//        guard let buildingCode = dictionary["buildingCode"] as? String,
//              let hours = dictionary["hours"] as? String,
//              let licencePlateNo = dictionary["licencePlateNo"] as? String,
//              let suitNo = dictionary["suitNo"] as? String,
//              let suitNo = dictionary["suitNo"] as? String,
//              let parkingLoc = dictionary["parkingLoc"] as? String
//        else {return nil}
//        self.init(buildingCode: buildingCode,hours: hours,licencePlateNo: licencePlateNo, suitNo: suitNo, parkingLoc: parkingLoc)
//    }
//}
//

