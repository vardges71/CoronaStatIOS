//
//  LogInViewController.swift
//  CoronaStatistic
//
//  Created by Vardges Gasparyan on 2020-04-25.
//  Copyright © 2020 Vardges Gasparyan. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class LogInViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupElements()
        // Do any additional setup after loading the view.
    }
    
    func setupElements() {
        
        // Set background
        let backgroundImage = UIImage(named: "covid_back-1")
        var imageView: UIImageView!
        
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = backgroundImage
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
        
        errorLabel.alpha = 0
        
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(loginButton)
        Utilities.styleHollowButton(registerButton)
    }

    @IBAction func loginTapped(_ sender: Any) {
        
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Signing in the user
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            if error != nil {
                
                self.errorLabel.text = error!.localizedDescription
                self.errorLabel.alpha = 1
            } else {
                
                let homeViewController = self.storyboard?.instantiateViewController(identifier: Constants.Stroryboard.homeViewController) as? HomeViewController
                
                self.view.window?.rootViewController = homeViewController
                self.view.window?.makeKeyAndVisible()
            }
        }
    }
    
    @IBAction func registerTapped(_ sender: Any) {
        
        let registerController = self.storyboard?.instantiateViewController(identifier: Constants.Stroryboard.registerController) as? SignInViewController
        
        self.view.window?.rootViewController = registerController
        self.view.window?.makeKeyAndVisible()
    }
    
}
