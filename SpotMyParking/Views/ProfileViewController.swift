//
//  ProfileViewController.swift
//  SpotMyParking
//
//  Created by Amandeep Bhavra on 2022-01-24.
//

import UIKit
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
import FirebaseFirestoreSwift

class ProfileViewController: UIViewController {
    var emailAddress : String?
    var isEditable: Bool = false
    var userUpdateInfo:[String: Any] = [:]
    
    
    var txtFirstName = MDCOutlinedTextField();
//    var txtEmail = MDCOutlinedTextField();
//    var txtPassword = MDCOutlinedTextField();
    var txtContactNum = MDCOutlinedTextField();
    var txtCarPlateNo = MDCOutlinedTextField();
    var btnSaveUploadProfile = MDCButton();
    var btnChangePassword = MDCButton();
    let btnDeleteAccount = MDCButton()
    
    var singleClicked = true
    var nInitYPos = 250
    var nyPosDiff = 38
    let LRPadding:Int = 40
    var wdtTxtField:Int = 0
    var wdtButton:Int = 0
    var userSignUp:NSMutableDictionary = [:];

    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        wdtTxtField = Int(UIScreen.main.bounds.width) - (LRPadding * 2)
        wdtButton = Int(UIScreen.main.bounds.width) - (LRPadding * 2)
        
        fnAddFirstNameTextField()
//        fnAddEmailTextField()
//        fnAddPasswordTextField()
//
        fnAddContactTextField()
        fnAddPlateNoTextField()
        fnUpdateUserProfile()
        fnChangePasswordButton()
        fnAddDeleteAccountBtn()
        fnEnableDisableFields(color: .lightGray, isEnable: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isEditable = false
        btnSaveUploadProfile.setTitle("UPDATE",for: .normal)
        print("1")
        if(UserDefaults.standard.bool(forKey: "DoRemember")){
            print("11")
            let userEmail = emailAddress!
//            let userPath = "parkingSpot/users/" + userEmail + "/details"
            
            let colName = "parkingSpot/users/" + userEmail
            db.collection(colName).getDocuments() { [self] (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    if(querySnapshot!.count == 0) {
                        print("Error getting documents from parkingSpot collection -> \(err)")
                        return
                    } else{
                        for result in querySnapshot!.documents {
                            let row = result.data()
                            if (row["Email"] as? String) == userEmail {
//
                                if let name = row["First_Name"] as? String{
                                    self.txtFirstName.text = name
                                }
                                
                                if let contact = row["Contact"] as? String{
                                    self.txtContactNum.text = contact
                                }

                                if let carPlateNo = row["Car_Plate_no"] as? String{
                                    self.txtCarPlateNo.text = carPlateNo
                                }
                                
                                break
                        }
                    }
                }
            }
        }
    }
}
    
    func fnAddFirstNameTextField() {
        let yPosition = Int(nInitYPos)
        let estimatedFrame = CGRect(x: LRPadding, y: yPosition, width: wdtTxtField, height: 48)
        txtFirstName = MDCOutlinedTextField(frame: estimatedFrame)
        
        txtFirstName.label.text = "First Name"
        txtFirstName.addTarget(self, action: #selector(tfFirstNamePressed(_:)), for: .editingChanged)
        txtFirstName.autocapitalizationType = UITextAutocapitalizationType.none
        txtFirstName.autocorrectionType = UITextAutocorrectionType.no
        txtFirstName.leadingView = UIImageView(image: UIImage(named: "Account-16"))
        txtFirstName.leadingViewMode = .always
        txtFirstName.sizeToFit()
        
        view.addSubview(txtFirstName)
    }
    //firstname textfield accepting only alphabets
    @IBAction func tfFirstNamePressed(_ sender: Any) {
        let regex = ".*[^A-Za-z ].*"
        let firstNameTest = NSPredicate(format: "SELF MATCHES %@", regex);
        let result = firstNameTest.evaluate(with: txtFirstName.text!);
        var runningNumber = txtFirstName.text;
        if (result) {
            runningNumber = String(txtFirstName.text!.dropLast())
            txtFirstName.text = runningNumber
        }
    }
    
    func fnAddContactTextField() {
        let yPosition = Int(nInitYPos + (nyPosDiff * 2))
        let estimatedFrame = CGRect(x: LRPadding, y: yPosition, width: wdtTxtField, height: 48)
        txtContactNum = MDCOutlinedTextField(frame: estimatedFrame)
        txtContactNum.label.text = "Contact Number"
        txtContactNum.addTarget(self, action: #selector(tfContactNumberPressed(_:)), for: .editingChanged)
        txtContactNum.keyboardType = UIKeyboardType.phonePad
        txtContactNum.autocapitalizationType = UITextAutocapitalizationType.none
        txtContactNum.autocorrectionType = UITextAutocorrectionType.no
        txtContactNum.leadingView = UIImageView(image: UIImage(named: "Phone-16"))
        txtContactNum.leadingViewMode = .always
        txtContactNum.sizeToFit()
        view.addSubview(txtContactNum)
    }
    
    @IBAction func tfContactNumberPressed(_ sender: Any) {
        let regex = "^[0-9]+$"
        let lastNameTest = NSPredicate(format: "SELF MATCHES %@", regex);
        let result = lastNameTest.evaluate(with: txtContactNum.text!);
        var runningNumber = txtContactNum.text;

        if (!result) {
            runningNumber = String(txtContactNum.text!.dropLast())
            txtContactNum.text = runningNumber
        }

        let phoneNumber = txtContactNum.text!
        let range = NSRange(location: 0, length: phoneNumber.count)
        let regexPH = try! NSRegularExpression(pattern: "(\\([0-9]{3}\\) |[0-9]{3}-)[0-9]{3}-[0-9]{4}")
        if regexPH.firstMatch(in: phoneNumber, options: [], range: range) != nil {
            /* print("Phone number is valid") */
        } else {
            /* print("Phone number is not valid") */
        }
    }
    
    func fnAddPlateNoTextField() {
        let yPosition = Int(nInitYPos + (nyPosDiff * 4))
        let estimatedFrame = CGRect(x: LRPadding, y: yPosition, width: wdtTxtField, height: 48)
        txtCarPlateNo = MDCOutlinedTextField(frame: estimatedFrame)
        txtCarPlateNo.label.text = "Car Plate No"
        txtCarPlateNo.keyboardType = UIKeyboardType.phonePad
        txtCarPlateNo.autocapitalizationType = UITextAutocapitalizationType.none
        txtCarPlateNo.autocorrectionType = UITextAutocorrectionType.no
        txtCarPlateNo.leadingView = UIImageView(image: UIImage(named: "Phone-16"))
        txtCarPlateNo.leadingViewMode = .always
        txtCarPlateNo.sizeToFit()
        view.addSubview(txtCarPlateNo)
    }
    
    func fnUpdateUserProfile () {
        btnSaveUploadProfile.setTitle("UPDATE", for: .normal)
        btnSaveUploadProfile.addTarget(self, action: #selector(btnUpdatePressed(_:)), for: .touchUpInside)
        btnSaveUploadProfile.frame = CGRect(x: LRPadding, y: nInitYPos + (nyPosDiff * 7) + 35, width: wdtTxtField, height: 50)
       
        btnSaveUploadProfile.layer.cornerRadius = 25
        btnSaveUploadProfile.setTitleColor(UIColor.white, for: UIControl.State.normal)
        
        btnSaveUploadProfile.setBorderWidth(1.0, for: UIControl.State.normal)
        
        view.addSubview(btnSaveUploadProfile)
    }
    
    func fnChangePasswordButton () {
        btnChangePassword.setTitle("CHANGE PASSWORD", for: .normal)
        btnChangePassword.addTarget(self, action: #selector(btnChangePassword(_:)), for: .touchUpInside)
        btnChangePassword.frame = CGRect(x: LRPadding, y: nInitYPos + (nyPosDiff * 9) + 35, width: wdtTxtField, height: 50)
       
        btnChangePassword.layer.cornerRadius = 25
        btnChangePassword.setTitleColor(UIColor.white, for: UIControl.State.normal)
        
        btnChangePassword.setBorderWidth(1.0, for: UIControl.State.normal)
        
        view.addSubview(btnChangePassword)
    }
    
    func fnEnableDisableFields(color: UIColor, isEnable: Bool) {
        txtFirstName.isUserInteractionEnabled = isEnable
        txtFirstName.setTextColor(color, for: .normal)
        
        txtContactNum.isUserInteractionEnabled = isEnable
        txtContactNum.setTextColor(color, for: .normal)
        
        txtCarPlateNo.isUserInteractionEnabled = isEnable
        txtCarPlateNo.setTextColor(color, for: .normal)
        
        btnDeleteAccount.isHidden = !isEnable;
    }
    
    func fnAddDeleteAccountBtn() {
        btnDeleteAccount.setTitle("DELETE ACCOUNT", for: .normal)
        btnDeleteAccount.addTarget(self, action: #selector(fnDeleteAccount(_:)), for: .touchUpInside)
        btnDeleteAccount.frame = CGRect(x: LRPadding, y: nInitYPos + (nyPosDiff * 12), width: wdtTxtField, height: 50)
        btnDeleteAccount.layer.cornerRadius = 25
        btnDeleteAccount.setTitleColor(UIColor.white, for: UIControl.State.normal)
        btnDeleteAccount.setBorderWidth(1.0, for: UIControl.State.normal)
        view.addSubview(btnDeleteAccount)
    }
    
    @IBAction func fnDeleteAccount(_ sender: Any){
        let title = "Alert"
        let message = "Are you sure you want to delete your account?"
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: "default action"), style: .default, handler: {_ in
            let path = "parkingSpot/users/" + self.emailAddress!
            self.db.collection(path).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        document.reference.delete()
                    }
//                    self.loadData()
//                    DispatchQueue.main.async{
//                        self.CartTableView.reloadData()
//                    }
                }
            }
            
            let parkingsPath = "parkingSpot/parking/" + self.emailAddress!
            self.db.collection(parkingsPath).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        document.reference.delete()
                    }
//                    self.loadData()
//                    DispatchQueue.main.async{
//                        self.CartTableView.reloadData()
//                    }
                }
            }
//            self.db.collection(path).document("1ctcxaalxnWJKcFzNXg4").delete()

            DispatchQueue.main.async {
//                let vc = self.storyboard?.instantiateViewController(withIdentifier: "prodCollection")as? ProductCollectionViewController
//                vc?.valEmailAddress = self.valPrdEmailAddress
//                self.navigationController?.popToRootViewController(animated: true)
            }
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {_ in

        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showDelAccountAlert(){
//        let title = "Alert"
//        let message = "Are you sure you want to delete your account?"
//        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: "default action"), style: .default, handler: {_ in
//            let path = "iOS/products/" + self.emailAddress!
//            self.db.collection(path).document(self.productName).delete()
//
//            DispatchQueue.main.async {
//                let vc = self.storyboard?.instantiateViewController(withIdentifier: "prodCollection")as? ProductCollectionViewController
//                vc?.valEmailAddress = self.valPrdEmailAddress
//                self.navigationController?.popToRootViewController(animated: true)
//            }
//        }))
//
//        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {_ in
//
//        }))
//        self.present(alert, animated: true, completion: nil)
//    }
    }
    
    @IBAction func btnUpdatePressed(_ sender: Any) {
        if (!isEditable) {
            isEditable = true
            btnSaveUploadProfile.setTitle("SAVE", for: .normal)
            fnEnableDisableFields(color: .black, isEnable: true)
        } else{
            
            self.userUpdateInfo = [
                "First_Name"    : self.txtFirstName.text as Any,
                "Contact"       : self.txtContactNum.text as Any,
                "Car_Plate_no"  : self.txtCarPlateNo.text as Any
            ]
            let userPath = "users/" + emailAddress! + "/details"
            
            self.db.collection("parkingSpot").document(userPath).updateData(self.userUpdateInfo as [String : Any]) { (error) in
                if let err = error {
                    print("Error when updating document -> \(err)")
                    
                    let alert = UIAlertController(title: "Error while Updating", message: "Updation Failed", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "default action"), style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return
                } else {
                    print("document saved successfully")
                    let alert = UIAlertController(title: "Profile Updated", message: "Successfully Updated Your Profile", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "default action"), style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                    self.isEditable = false
                    self.btnSaveUploadProfile.setTitle("UPDATE", for: .normal)
                    self.fnEnableDisableFields(color: .lightGray, isEnable: false)
                    
                    return
                }
            }
        }
    }
    
    @IBAction func btnChangePassword(_ sender: Any) {
        
    }
}
