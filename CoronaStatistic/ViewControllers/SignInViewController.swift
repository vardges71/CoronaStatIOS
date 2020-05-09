//
//  SignInViewController.swift
//  CoronaStatistic
//
//  Created by Vardges Gasparyan on 2020-04-25.
//  Copyright © 2020 Vardges Gasparyan. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

class SignInViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var rePasswordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLable: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupElements()
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func setupElements() {

        // Set baclground
        let backgroundImage = UIImage(named: "covid_back-1")
        var imageView: UIImageView!
        
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = backgroundImage
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
        
        errorLable.alpha = 0
        
        Utilities.styleTextField(firstNameTextField)
        Utilities.styleTextField(lastNameTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleTextField(rePasswordTextField)
        Utilities.styleFilledButton(registerButton)
        Utilities.styleHollowButton(loginButton)
        
    }
    
    // Check the fields and validate that the data is correct. If everything is correct, this methods returns nil. Othervise, it returns the error message
    func validateFields() -> String? {
        
        // Check that all fields are filled in
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "please fill in all fields"
        }
        
        // Check that password field equals rePassword text fild
        if passwordTextField.text! != rePasswordTextField.text! {
            
            return "please enter the same passwords in the passwors and rePassword fields"
        }
        
        // Check if the password is secure
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isPasswordValid(cleanedPassword) == false {
            
            // Password isn't secure enogh
            return "Please make sure your password is at least 8 characters, contains a special character and number"
        }
        
        return nil
    }

    @IBAction func registerTapped(_ sender: UIButton) {
        
        // Validate the fields
        let error = validateFields()
        
        if error != nil {
            
            // There's something wrong with the fields, show error message
            showError(error!)
        } else {
        
            // Create cleaned version of the data
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Create the User
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                
                if err != nil {
                    
                    // There was an error creating the user
                    self.showError("Error creatimg the user")
                } else {
                    
                    // User was created successfully, now store the first name and the last name
                    let db = Firestore.firestore()
                    
                    db.collection("users").addDocument(data: ["firstname" : firstName, "lastname" : lastName, "email" : email, "uid" : result!.user.uid]) { (error) in
                        
                        if error != nil {
                            
                            //Show erroe message
                            self.showError("Error saving user data")
                        }
                    }
                    
                    // Transition to the home screen
                    self.transitionToHome()
                }
            }
            
        }
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        
        let loginController = self.storyboard?.instantiateViewController(identifier: Constants.Stroryboard.loginController) as? LogInViewController
        
        self.view.window?.rootViewController = loginController
        self.view.window?.makeKeyAndVisible()
    }
    
    func showError(_ message: String) {
        
        errorLable.text = message
        errorLable.alpha = 1
    }
    
    func transitionToHome() {
        
        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Stroryboard.homeViewController) as? HomeViewController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
    

}
