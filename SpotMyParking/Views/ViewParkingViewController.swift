//
//  ViewParkingViewController.swift
//  SpotMyParking
//
//  Created by Amandeep Bhavra on 2022-01-24.
//

import UIKit
import MapKit
import FirebaseFirestore
import FirebaseAuth

class ViewParkingViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource {
    
    let db = Firestore.firestore()
    @IBOutlet weak var tblParkingList: UITableView!
    private let formatter = DateFormatter()
    
    private var viewParkingController = ViewParkingController()
//    private var parkingList:[Parking] = [Parking]()
    var emailAddress : String?
    var arrParkingDate = [String]()
    var arrBuildingCode = [String]()
    var arrCarPlateNum = [String]()
    var arrLatitude = [String]()
    var arrLongitude = [String]()
    var arrParkingHours = [Double]()
    var arrStreetAddress = [String]()
    var arrSuitNumber = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblParkingList.delegate = self
        self.tblParkingList.dataSource = self
        
        self.formatter.dateStyle = .medium
        self.formatter.timeStyle = .medium
        
        self.tblParkingList.rowHeight = 150
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        arrParkingDate = []
        loadParking()

    }
    func loadParking() {
        arrParkingDate.removeAll()
        arrBuildingCode.removeAll()
        arrCarPlateNum.removeAll()
        arrLatitude.removeAll()
        arrLongitude.removeAll()
        arrParkingHours.removeAll()
        arrStreetAddress.removeAll()
        arrSuitNumber.removeAll()
        let path = "parkingSpot/parking/" + emailAddress!;
        db.collection(path).getDocuments() { [self] (querySnapshot, err) in
            if let err = err{
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    self.arrParkingDate.append(document["ParkingOn"] as! String)
                    self.arrBuildingCode.append(document["buildingCode"] as! String)
                    self.arrCarPlateNum.append(document["carPlateNumber"] as! String)
                    self.arrLatitude.append("\(String(describing: document["latitude"]))")
                    self.arrLongitude.append("\(String(describing: document["longitude"]))")
                    self.arrParkingHours.append(document["parkingHours"] as! Double)
                    self.arrStreetAddress.append(document["streetAddress"] as! String)
                    self.arrSuitNumber.append("\(String(describing: document["suitNumber"]))")
                }
                DispatchQueue.main.async {
                    self.tblParkingList.reloadData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrParkingDate.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblParkingList.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! ViewParkingTableViewCell
        cell.carPlateNo.text! = self.arrCarPlateNum[indexPath.row]
        cell.dateLabel.text! = "Added on " + self.arrParkingDate[indexPath.row]
        cell.hoursLabel?.text = "Reserved for: " + String(describing: self.arrParkingHours[indexPath.row]) + " Hours"
//        cell.setParkingHour(hour:Int(parking.parkingHours))
        cell.addressLabel.text! = self.arrStreetAddress[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let myIndex = indexPath.row
        let data:NSMutableDictionary = [:];
        data["ParkingOn"]       = self.arrParkingDate[myIndex]
        data["buildingCode"]    = self.arrBuildingCode[myIndex]
        data["carPlateNumber"]  = self.arrCarPlateNum[myIndex]
        data["latitude"]        = self.arrLatitude[myIndex]
        data["longitude"]       = self.arrLongitude[myIndex]
        data["parkingHours"]    = self.arrParkingHours[myIndex]
        data["streetAddress"]   = self.arrStreetAddress[myIndex]
        data["suitNumber"]      = self.arrSuitNumber[myIndex]
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "parkingDetail") as? DetailParkingViewController
        vc?.data = data
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}
