//
//  ViewController.swift
//  SpotMyParking
//
//  Created by Amandeep Bhavra on 2022-01-17.
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
import Firebase
import FirebaseAuth

class ViewController: UIViewController {
    let db = Firestore.firestore()
    var txtEmail = MDCOutlinedTextField();
    var txtPassword = MDCOutlinedTextField();
    var email = ""
    var password = ""
    var nInitYPos = 320
    var nyPosDiff = 40
    let LRPadding:Int = 40
    var wdtTxtField:Int = 0
    var wdtButton:Int = 0
    let myButton = MDCButton()
    var doRemember:Bool = false
    var emailEntered = ""
    var passwordEntered = ""
    
    @IBOutlet weak var lblRememberMe: UILabel!
    @IBOutlet weak var switchRememberMe: UISwitch!
    @IBOutlet weak var btnForgotPassword: UIButton!
    @IBOutlet weak var lblBottomText: UILabel!
    @IBOutlet weak var btnSignUp: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wdtTxtField = Int(UIScreen.main.bounds.width) - (LRPadding * 2)
        wdtButton = Int(UIScreen.main.bounds.width) - (LRPadding * 2)
    
        fnAddEmailTextField()
        fnAddPasswordTextField()
        fnAddLoginButton()
        
//        lblRememberMe.font = UIFont.init(name: (Constants.FontFamily), size: Constants.FontSize + 1);
        lblRememberMe.frame.origin.x = CGFloat(LRPadding);
        lblRememberMe.frame.origin.y = CGFloat(nInitYPos + (nyPosDiff * 4) + 20);
        
        btnForgotPassword.frame.origin.x = lblRememberMe.frame.origin.x + lblRememberMe.frame.width + 70
        btnForgotPassword.frame.origin.y = lblRememberMe.frame.origin.y
        
        let nSwitchXPos = Int(lblRememberMe.frame.origin.x) + Int(lblRememberMe.frame.width)
        switchRememberMe.frame.origin.x = CGFloat(nSwitchXPos)
        switchRememberMe.frame.origin.y = CGFloat(nInitYPos + (nyPosDiff * 4) + 20);
        switchRememberMe.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
    
        let yPosBottomText = myButton.frame.origin.y + myButton.frame.height + 30
        lblBottomText.frame.origin.y = yPosBottomText
        btnSignUp.frame.origin.y = yPosBottomText - 5
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        txtEmail.text = ""
        txtPassword.text = ""
        btnSignUp.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        if UserDefaults.standard.bool(forKey: "DoRemember") {
            switchRememberMe.isOn = true
            doRemember = true
            
            txtEmail.text = UserDefaults.standard.string(forKey: "UserName")!
            txtPassword.text = UserDefaults.standard.string(forKey: "Password")!
            
            emailEntered = txtEmail.text!
            passwordEntered = txtPassword.text!
            
            fnLogin();
        } else {
            switchRememberMe.isOn = false
            doRemember = false
        }
    }
    @IBAction func rememberMe(_ sender: UISwitch) {
        if(sender.isOn){
            doRemember = true
        } else {
            doRemember = false
        }
    }
    
    func fnAddEmailTextField() {
        let yPosition = Int(nInitYPos)
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
        let yPosition = Int(nInitYPos + nyPosDiff * 2)
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
    
    func fnAddLoginButton () {
        myButton.setTitle("LOGIN", for: .normal)
        myButton.addTarget(self, action: #selector(loginPressed(_:)), for: .touchUpInside)
        let btnXPosition = Int(UIScreen.main.bounds.width * 0.5) - Int(Double(wdtButton) * 0.5)
        myButton.frame = CGRect(x: btnXPosition, y: nInitYPos + (nyPosDiff * 5) + 20, width: wdtButton, height: 50)
        
        myButton.layer.cornerRadius = 25
        myButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        
        myButton.setBorderWidth(1.0, for: UIControl.State.normal)
        
        view.addSubview(myButton)
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        fnLogin()
        print("LOGIN PRESSED")
    }
    
    func fnLogin() {
        if (UserDefaults.standard.bool(forKey: "DoRemember") == false) {
            emailEntered = txtEmail.text!
            passwordEntered = txtPassword.text!
        }

        if (emailEntered.isEmpty && passwordEntered.isEmpty) {
            fnShowAlert(title: "Login failed", message: "Please enter your email and password")
            return
        } else if (emailEntered.isEmpty) {
            fnShowAlert(title: "Login failed", message: "Please enter your email")
            return
        } else if (passwordEntered.isEmpty) {
            fnShowAlert(title: "Login failed", message: "Please enter your password")
            return
        }

        Auth.auth().signIn(withEmail: emailEntered, password: passwordEntered) { [weak self] authResult, error in
            guard let strongSelf = self else { return }

            if let authResult = authResult {
                let user = authResult.user
                if user.isEmailVerified {
                    Constants.CurrentUserEmail = strongSelf.emailEntered
                    strongSelf.fnNavigateFurther(email: strongSelf.emailEntered)

                    if strongSelf.doRemember {
                        UserDefaults.standard.set(true, forKey: "DoRemember");
                        UserDefaults.standard.set(strongSelf.txtEmail.text!, forKey: "UserName");
                        UserDefaults.standard.set(strongSelf.txtPassword.text!, forKey: "Password");
                    } else {
                        UserDefaults.standard.removeObject(forKey: "DoRemember");
                        UserDefaults.standard.removeObject(forKey: "UserName");
                        UserDefaults.standard.removeObject(forKey: "Password");
                    }
                } else {
                    // do whatever you want to do when user isn't verified
                    strongSelf.fnShowVerificationAlert(title: "Please verify your email", message: "\nYou're almost there! We have sent an email to " + strongSelf.emailEntered + "\n\nJust click on the link in that email to complete you registeration. If you don't see it, you may need to check your spam folder.\n\n Still can't find the email? Hit resend.")
                }
            }

            if (error != nil) {
                strongSelf.fnShowAlert(title: "Login failed", message: "Incorrect username or password. Please try again!")
                return
            }
        }
    }
    
   
    @IBAction func btnCreateAccount(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "signUp") as! SignUpViewController
        vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
        self.navigationController?.pushViewController(vc, animated: true)
        self.present(vc, animated: true, completion: nil)
    }
    
    func fnNavigateFurther(email: String) {
        let colName = "parkingSpot/users/" + email
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
                        if (row["Email"] as? String) == email {
                            self.gotoHome();
                            return;
                        }
                    }
                }
            }
        }
    }
    func gotoHome () {
        guard let move = self.storyboard?.instantiateViewController(identifier: "mainTabBarController") as? MainTabBar_Controller else {
        print("Cannot find Tab Bar Controller!")
        return
        }
        move.modalPresentationStyle = .fullScreen
        move.emailAddress = emailEntered
        self.show(move, sender: self)
    }
    func fnShowAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "default action"), style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func fnShowVerificationAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Try Again", comment: "default action"), style: .default, handler: {_ in
            self.fnLogin()
        }))
        
        alert.addAction(UIAlertAction(title: "Resend", style: .default, handler: {_ in
            FirebaseAuth.Auth.auth().currentUser?.sendEmailVerification(completion: { error in
                if let error = error {
                    print(error)
                } else {
                    print("Email sent successfully.")
                }
            })
        }))
        present(alert, animated: true)
    }
}


