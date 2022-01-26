//
//  SignUpViewController.swift
//  SpotMyParking
//
//  Created by Amandeep Bhavra on 2022-01-18.
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
import FirebaseAuth

class SignUpViewController: UIViewController {
    
    var txtFirstName = MDCOutlinedTextField();
    var txtEmail = MDCOutlinedTextField();
    var txtPassword = MDCOutlinedTextField();
    var txtConfirmPassword = MDCOutlinedTextField();
    var txtContactNum = MDCOutlinedTextField();
    var txtCarPlateNo = MDCOutlinedTextField();
    var myButton = MDCButton();
    
    
    var nInitYPos = 180
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
        fnAddEmailTextField()
        fnAddPasswordTextField()
        fnAddConfirmPasswordTextField()
        fnAddContactTextField()
        fnAddPlateNoTextField()
        fnAddAccountButton()
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
    
    func fnAddEmailTextField() {
        let yPosition = Int(nInitYPos + (nyPosDiff * 2))
        let estimatedFrame = CGRect(x: LRPadding, y: yPosition, width: wdtTxtField, height: 48)
        txtEmail = MDCOutlinedTextField(frame: estimatedFrame)
        txtEmail.label.text = "Email Id"
        txtEmail.keyboardType = UIKeyboardType.emailAddress
        txtEmail.autocapitalizationType = UITextAutocapitalizationType.none
        txtEmail.autocorrectionType = UITextAutocorrectionType.no
        txtEmail.leadingView = UIImageView(image: UIImage(named: "MailIcon-16"))
        txtEmail.leadingViewMode = .always
        txtEmail.sizeToFit()
        view.addSubview(txtEmail)
    }

    func fnAddPasswordTextField() {
        let yPosition = Int(nInitYPos + (nyPosDiff * 4))
        let estimatedFrame = CGRect(x: LRPadding, y: yPosition, width: wdtTxtField, height: 48)
        txtPassword = MDCOutlinedTextField(frame: estimatedFrame)
        txtPassword.label.text = "Password"
        txtPassword.isSecureTextEntry = !txtPassword.isSecureTextEntry
        txtPassword.autocapitalizationType = UITextAutocapitalizationType.none
        txtPassword.autocorrectionType = UITextAutocorrectionType.no
        txtPassword.leadingView = UIImageView(image: UIImage(named: "PasswordLock-16"))
        txtPassword.leadingViewMode = .always
        txtPassword.sizeToFit()
        view.addSubview(txtPassword)
    }
    
    func fnAddConfirmPasswordTextField() {
        let yPosition = Int(nInitYPos + (nyPosDiff * 6))
        let estimatedFrame = CGRect(x: LRPadding, y: yPosition, width: wdtTxtField, height: 48)
        txtConfirmPassword = MDCOutlinedTextField(frame: estimatedFrame)
        txtConfirmPassword.label.text = "Confirm Password"
        txtConfirmPassword.isSecureTextEntry = !txtConfirmPassword.isSecureTextEntry
        txtConfirmPassword.autocapitalizationType = UITextAutocapitalizationType.none
        txtConfirmPassword.autocorrectionType = UITextAutocorrectionType.no
        txtConfirmPassword.leadingView = UIImageView(image: UIImage(named: "PasswordLock-16"))
        txtConfirmPassword.leadingViewMode = .always
        txtConfirmPassword.sizeToFit()
        view.addSubview(txtConfirmPassword)
    }
    
    func fnAddContactTextField() {
        let yPosition = Int(nInitYPos + (nyPosDiff * 8))
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
        let yPosition = Int(nInitYPos + (nyPosDiff * 10))
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
    
    func fnAddAccountButton () {
        myButton.setTitle("CREATE ACCOUNT", for: .normal)
        myButton.addTarget(self, action: #selector(btnSignUp(_:)), for: .touchUpInside)
        let btnXPosition = Int(UIScreen.main.bounds.width * 0.5) - Int(Double(wdtButton) * 0.5)
        myButton.frame = CGRect(x: btnXPosition, y: nInitYPos + (nyPosDiff * 13), width: wdtButton, height: 50)
        myButton.layer.cornerRadius = 25
        myButton.setBorderWidth(1.0, for: UIControl.State.normal)
        
        view.addSubview(myButton)
    }
    
    @IBAction func btnSignUp(_ sender: Any) {
        let email = txtEmail.text!
        let password = txtPassword.text!
        /*if (!validateFields()) {
            return;
        }*/
        //  add it to firebase

            userSignUp = [
                "First_Name": txtFirstName.text!,
                "Email": email,
                "Contact": txtContactNum.text!,
                "Car_Plate_no": txtCarPlateNo.text!
            ]
        fnCheckUserExistance(email: email);
    }
    func fnCheckUserExistance(email: String) {
        var isUserExists:Bool = false;
        let colName = "parkingSpot";
        let group = DispatchGroup();

        group.enter();
        self.db.collection(colName).whereField("Email", isEqualTo: email).getDocuments {
            (queryResults, error) in
            if let err = error {
                print("Error getting documents from iOS collection \(err)")
                return
            } else {
                print("queryResults -> \(String(describing: queryResults!.count))")
                // we were successful in getting the documents
                if (queryResults!.count == 0) {
                    isUserExists = false;
                } else {
                    // we found some results, so let's output it to the screen
                    isUserExists = true;
                }
            }
            group.leave();
        }

        group.notify(queue: .main) {
            if (isUserExists) {
                self.userExistAlert();
            } else {
                self.fnCreateAccount (email: email, password: self.txtPassword.text!)
            }
        }
    }
    
    func fnSaveUserData () {
        let coll = "parkingSpot/users/" + txtEmail.text!;
        self.db.collection(coll).document("details").setData(self.userSignUp as! [String : Any]) { (error) in
            if let err = error {
                print("Error when saving document -> \(err)");
                return
            }else {
                self.fnCreateAccount(email: self.txtEmail.text!, password: self.txtPassword.text!)
//                self.fnSaveUserData();
            }
        }
    }
    func fnCreateAccount(email: String, password: String) {
        print("CREATE ACCOUNT")
        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion: { [weak self] result, error in
            guard let strongSelf = self else {
                return
            }
            print(error as Any)
            guard error == nil else {
                let alert = UIAlertController(
                    title: "Account Creation Failed",
                    message: "\nEmail: " + email + " already exists. \n\nPlease enter another valid email to register with SpotMyParking.",
                    preferredStyle: .alert)

                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                strongSelf.present(alert, animated: true)
                return
            }
            FirebaseAuth.Auth.auth().currentUser?.sendEmailVerification(completion: {error in
                if let error = error {
                    print(error)
                } else {
                    let alert = UIAlertController(title: "Thank you for signing up " + strongSelf.txtFirstName.text! + "!",
                                                  message: "\nA verification link has been sent to your email account.\n\nPlease click on the link that has been sent to your email account to verify your email and continue the registeration process.",
                                                  preferredStyle: .alert)

                    alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: {_ in
//                        strongSelf.fnMoveBackToLogin ()
                    }))
                    strongSelf.present(alert, animated: true)

                    strongSelf.fnSaveUserData();

                    strongSelf.txtFirstName.text = ""
                    strongSelf.txtEmail.text = ""
                    strongSelf.txtPassword.text = ""
                    strongSelf.txtConfirmPassword.text = ""
                    strongSelf.txtContactNum.text = ""
                    strongSelf.txtCarPlateNo.text = ""
                }
            })
        })
    }
    func validateFields() -> Bool {
        if (txtFirstName.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            txtEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            txtPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            txtConfirmPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            txtContactNum.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            txtCarPlateNo.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
            showFailedAlert(title: "Account creation failed", message: "Please fill in all the fields")
            return false;
        }

        //check if the password is secure
        let cleanedPassword = txtPassword.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if (isPasswordValid(cleanedPassword) == false){
            showFailedAlert(title: "Password Failure", message: "\nPlease Make sure your password contains at least:\n\n - 1 Uppercase \n - 1 Lowercase \n - 1 Digit \n - 1 Special Character \n - Minimum 8 Characters")
            return false;
        }
        //check if the format for email is correct
        let cleanedEmail = txtEmail.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if(isValidEmail(email: cleanedEmail) == false){
            showFailedAlert(title: "Email Failure", message: "Please make sure your email is in proper format")
            return false;
        }
        //matches the password and confirm password fields
        if(txtPassword.text != txtConfirmPassword.text){
            showFailedAlert(title: "Password Conflict", message: "Password and confirm password should be same")
            return false;
        }
        return true;
    }
    
    func isPasswordValid(_ password : String) -> Bool {
        // least one uppercase,
        // least one digit
        // least one lowercase
        // least one symbol
        //  min 8 characters total
        let password = password.trimmingCharacters(in: CharacterSet.whitespaces)
        let passwordRegx = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&<>*~:`-]).{8,}$"
        let passwordCheck = NSPredicate(format: "SELF MATCHES %@",passwordRegx)
        return passwordCheck.evaluate(with: password)
    }
    
    func isValidEmail(email:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: email)
        return result
    }
    func showFailedAlert(title : String, message : String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func userExistAlert() {
        let alert = UIAlertController(title: "Sign Up Unsuccessful", message: "Account already exists. Please enter a different email address.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "default action"), style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        return
    }
}
