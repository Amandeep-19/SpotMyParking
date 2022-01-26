//
//  AddParkingViewController.swift
//  SpotMyParking
//
//  Created by Amandeep Bhavra on 2022-01-24.
//

import UIKit
import MapKit
import FirebaseFirestore
import MaterialComponents.MaterialTextControls_FilledTextAreas
import MaterialComponents.MaterialTextControls_FilledTextFields
import MaterialComponents.MaterialTextControls_OutlinedTextAreas
import MaterialComponents.MaterialTextControls_OutlinedTextFields
import MaterialComponents.MaterialButtons
import MaterialComponents.MaterialButtons_Theming
import MaterialComponents.MaterialTextFields_Theming
import MaterialComponents.MDCContainerScheme
import MaterialComponents.MaterialColorScheme
import FirebaseAuth

class AddParkingViewController: UIViewController {
    var txtBuildingCode = MDCOutlinedTextField();
    var txtParkingHours = MDCOutlinedTextField();
    var txtLicencePlateNo = MDCOutlinedTextField();
    var txtSuitNumber = MDCOutlinedTextField();
    var txtParkingLoc = MDCOutlinedTextField();
    
    var myButton = MDCButton();
    var emailAddress : String?
    
    var nInitYPos = 180
    var nyPosDiff = 38
    let LRPadding:Int = 40
    var wdtTxtField:Int = 0
    var hgtTxtField:Int = 48
    var wdtButton:Int = 0
    
    private var locationController = LocationController()
    private var addParkingController = AddParkingController()
    
    

    let db = Firestore.firestore()
    @IBOutlet weak var segHourController: UISegmentedControl!
    @IBOutlet weak var btnLocation: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wdtTxtField = Int(UIScreen.main.bounds.width) - (LRPadding * 2)
        wdtButton = Int(UIScreen.main.bounds.width) - (LRPadding * 2)
        
        fnAddBuildingCodeTextField()
        fnAddHourSegmentTextField()
        fnAddLicencePlateNoTextField()
        fnAddSuitNumberTextField()
        fnAddParkingLocationTextField()
        fnAddParkingButton()
        self.locationController.delegate = self
        
    }
    
    @IBAction func btnLocateMe(_ sender: UIButton) {
        self.locationController.requestLocationAccess(requireContinuousUpdate: false)
    }
    
    
    func fnAddBuildingCodeTextField() {
        let yPosition = Int(nInitYPos)
        let estimatedFrame = CGRect(x: LRPadding, y: yPosition, width: wdtTxtField, height: hgtTxtField)
        txtBuildingCode = MDCOutlinedTextField(frame: estimatedFrame)
        txtBuildingCode.label.text = "Building Code"
//        txtBuildingCode.addTarget(self, action: #selector(tfFirstNamePressed(_:)), for: .editingChanged)
        txtBuildingCode.autocapitalizationType = UITextAutocapitalizationType.none
        txtBuildingCode.autocorrectionType = UITextAutocorrectionType.no
        
        txtBuildingCode.leadingViewMode = .always
        txtBuildingCode.sizeToFit()
        view.addSubview(txtBuildingCode)
    }
    
    func fnAddHourSegmentTextField() {
        let yPosition = Int(nInitYPos + (nyPosDiff * 2))
        let estimatedFrame = CGRect(x: LRPadding, y: yPosition, width: wdtTxtField, height: hgtTxtField)
        txtParkingHours = MDCOutlinedTextField(frame: estimatedFrame)
        txtParkingHours.label.text = "Parking Hours"
        txtParkingHours.text = " "
        
        txtParkingHours.autocapitalizationType = UITextAutocapitalizationType.none
        txtParkingHours.autocorrectionType = UITextAutocorrectionType.no
        txtParkingHours.isUserInteractionEnabled = false
        
        txtParkingHours.leadingViewMode = .always
        txtParkingHours.sizeToFit()
        view.addSubview(txtParkingHours)
        
        let segYPosition = Int(nInitYPos + (nyPosDiff * 2))
        segHourController.frame = CGRect(x: LRPadding, y: segYPosition, width: wdtTxtField, height: 60)
    }
    
    func fnAddLicencePlateNoTextField() {
        let yPosition = Int(nInitYPos + (nyPosDiff * 4))
        let estimatedFrame = CGRect(x: LRPadding, y: yPosition, width: wdtTxtField, height: hgtTxtField)
        txtLicencePlateNo = MDCOutlinedTextField(frame: estimatedFrame)
        txtLicencePlateNo.label.text = "Licence Plate Number"
        
        txtLicencePlateNo.autocapitalizationType = UITextAutocapitalizationType.none
        txtLicencePlateNo.autocorrectionType = UITextAutocorrectionType.no
        
        txtLicencePlateNo.leadingViewMode = .always
        txtLicencePlateNo.sizeToFit()
        view.addSubview(txtLicencePlateNo)
    }

    func fnAddSuitNumberTextField() {
        let yPosition = Int(nInitYPos + (nyPosDiff * 6))
        let estimatedFrame = CGRect(x: LRPadding, y: yPosition, width: wdtTxtField, height: hgtTxtField)
        txtSuitNumber = MDCOutlinedTextField(frame: estimatedFrame)
        txtSuitNumber.label.text = "Suit Number"
       
        txtSuitNumber.autocapitalizationType = UITextAutocapitalizationType.none
        txtSuitNumber.autocorrectionType = UITextAutocorrectionType.no
        
        txtSuitNumber.leadingViewMode = .always
        txtSuitNumber.sizeToFit()
        view.addSubview(txtSuitNumber)
    }
    
    func fnAddParkingLocationTextField() {
        let yPosition = Int(nInitYPos + (nyPosDiff * 8))
        let estimatedFrame = CGRect(x: LRPadding, y: yPosition, width: wdtTxtField, height: hgtTxtField)
        txtParkingLoc = MDCOutlinedTextField(frame: estimatedFrame)
        txtParkingLoc.label.text = "Parking Location"
       
        txtParkingLoc.autocapitalizationType = UITextAutocapitalizationType.none
        txtParkingLoc.autocorrectionType = UITextAutocorrectionType.no
        
        txtParkingLoc.leadingViewMode = .always
        txtParkingLoc.sizeToFit()
        view.addSubview(txtParkingLoc)
    }
    
    func fnAddParkingButton () {
        myButton.setTitle("Add Parking", for: .normal)
        myButton.addTarget(self, action: #selector(btnSaveParking(_:)), for: .touchUpInside)
        let btnXPosition = Int(UIScreen.main.bounds.width * 0.5) - Int(Double(wdtButton) * 0.5)
        myButton.frame = CGRect(x: btnXPosition, y: nInitYPos + (nyPosDiff * 13), width: wdtButton, height: 50)
        myButton.layer.cornerRadius = 25
        myButton.setBorderWidth(1.0, for: UIControl.State.normal)
        
        view.addSubview(myButton)
    }
    @IBAction func btnSaveParking(_ sender: Any){
//
        let errorMsg = validateParking()
        
        if errorMsg.isEmpty{
            self.locationController.fetchLocationCoord(address: self.txtParkingLoc.text!){
                (errorMsg) in
                if let error = errorMsg {
                    self.showAlert(title: "Error", message: error)
                }else {
                    self.addParking(lat: self.locationController.lat,
                                    long: self.locationController.long)
                }
            }
        } else {
            showAlert(title: "Error", message: errorMsg)
        }
    }
    
    private func addParking(lat:Double,long:Double) {
        
           self.addParkingController.addParking(
            email:Constants.CurrentUserEmail,
            buildingCode : txtBuildingCode.text!,
            parkingHours : self.getHourFromSegmentIndex(segmentIndex:self.segHourController.selectedSegmentIndex),
            carPlateNumber : txtLicencePlateNo.text!,
            suitNumber : txtSuitNumber.text!,
            address : txtParkingLoc.text!,
            lat: lat,long:long){
            (error) in
                if let error = error {
                    self.showAlert(title: "Error", message: error)
                } else {
                    self.self.showAlert(title: "Success", message: "Parking added succesfully")
                    self.clearInputs()
                    }
                }
    }
    
    private func clearInputs() {
        txtBuildingCode.text = ""
        txtParkingHours.text = " "
//        txtLicencePlateNo.text = user.carPlateNumber
        txtSuitNumber.text = ""
        txtParkingLoc.text = ""
    }
    
//
//        let parking = [
//            "buildingCode":buildingCode,
//            "hours":parkingHours,
//            "plateno":licencePlateNo,
//            "suitNo":suitNo,
//            "parkingLoc":parkLoc
//        ] as [String : Any]
//
//        self.db.collection("parkingSpot").getDocuments { [self]
//            (queryResults, error) in
//            if let err = error {
//                print("Error getting documents from parkingSPot collection -> \(err)")
//                return
//            } else {
//                let coll = "parkingSpot/users/" + emailAddress!;
//                self.db.collection(coll).document("parking").setData(parking as [String : Any]) { (error) in
//                    if let err = error {
//                        print("Error when saving document -> \(err)")
//                        return
//                    } else {
//                        print("document saved successfully");
////                        showSuccessAlert()
//                        }
//                    }
//                }
//            }
//        self.txtBuildingCode.text = ""
//        self.txtParkingHours.text = " "
//        self.txtLicencePlateNo.text = ""
//        self.txtSuitNumber.text = ""
//        self.txtParkingLoc.text = ""
//    }
    
    private func validateParking() -> String {
        
//        if self.txtBuildingCode.text!.isEmpty {
//            return "Building code is empty"
//        } else if self.txtBuildingCode.text!.count != 5 {
//            return "Building Code must have 5 alphanumeric characters"
//        } else if !self.txtBuildingCode.text!.isAlphanumeric {
//            return "Building must be an alphanumeric character"
//        } else if hoursSegment.selectedSegmentIndex < 0 {
//            return "Please select parking hours"
//        } else if self.plateNumberTextField.text!.isEmpty {
//            return "Car plate number is empty"
//        } else if self.plateNumberTextField.text!.count > 8 {
//            return "Maximum 8 alphanumeric characters allowed for Car Plate Number"
//        } else if self.plateNumberTextField.text!.count < 2 {
//            return "Minimum 2 alphanumeric characters required for Car Plate Number"
//        } else if !self.plateNumberTextField.text!.isAlphanumeric {
//            return "Car Plate Number must be an alphanumeric character"
//        } else if self.suitNumberTextField.text!.isEmpty {
//            return "Suit number is empty"
//        } else if self.suitNumberTextField.text!.count > 5 {
//            return "Maximum 5 alphanumeric characters allowed for Suit Number"
//        } else if self.suitNumberTextField.text!.count < 2 {
//            return "Minimum 2 alphanumeric characters required for Suit Number"
//        } else if !self.suitNumberTextField.text!.isAlphanumeric {
//            return "Suit Number must be an alphanumeric character"
//        } else if self.locationTextField.text!.isEmpty {
//            return "Please provide parking location"
//        } else {
//            return ""
//        }
        return ""
    }
    
    private func showAlert(title:String, message:String) {
        let alertController = UIAlertController(title: title, message:
                                                    message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func getHourFromSegmentIndex(segmentIndex:Int) -> Double {
        switch segmentIndex {
        case 0:
            return 1.0
        case 1:
            return 4.0
        case 2:
            return 12.0
        case 3:
            return 24.0
        default:
            return -0.0
        }
    }
}


extension AddParkingViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = manager.location?.coordinate {
            locationController.fetchAddress(
                location:CLLocation(latitude: location.latitude,
                                    longitude: location.longitude)){
                (errorMsg) in
//                self.setLocateMeActive(isActive: false)
                
                if let error = errorMsg {
                    self.showAlert(title: "Error", message: error)
                }else {
                    self.txtParkingLoc.text = self.locationController.address.country
                }
            }
        } else {
            if manager.authorizationStatus == .authorizedWhenInUse ||
                    manager.authorizationStatus == .authorizedAlways {
                showAlert(title: "Error", message: "Unable to get location, Try again")
            } else {
                self.locationController.requestLocationAccess(requireContinuousUpdate: false)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if manager.authorizationStatus == .denied {
            self.showLocationServicesAlert()
        } else if manager.authorizationStatus == .authorizedWhenInUse ||
                    manager.authorizationStatus == .authorizedAlways {
            self.locationController.requestLocationAccess(requireContinuousUpdate: false)
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        if manager.authorizationStatus == .denied {
            self.showLocationServicesAlert()
        }
    }
    
    private func showLocationServicesAlert() {
        
        showAlert(title: "Attention", message: "Parking App needs location access for locating your address.\n\nPlease enable by visiting Settings > Privacy > Location Services > ParkingApp")
        
    }
}
