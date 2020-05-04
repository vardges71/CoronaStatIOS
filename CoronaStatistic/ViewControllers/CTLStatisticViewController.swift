//
//  CTLStatisticViewController.swift
//  CoronaStatistic
//
//  Created by Vardges Gasparyan on 2020-04-25.
//  Copyright © 2020 Vardges Gasparyan. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class CTLStatisticViewController: UIViewController {

    
    @IBOutlet weak var globalStatisticButton: UIBarButtonItem!
    @IBOutlet weak var countryStatisticButton: UIBarButtonItem!
    @IBOutlet weak var logOutTapped: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func logOutTapped(_ sender: Any) {
        
        do {
            try Auth.auth().signOut()
            self.dismiss(animated: true, completion: nil)
            } catch let err {
                print(err)
        }
        
        Utilities.logOut()
        let firstVC = self.storyboard?.instantiateViewController(identifier: Constants.Stroryboard.firstVC) as? ViewController
        
        self.view.window?.rootViewController = firstVC
        self.view.window?.makeKeyAndVisible()
    }
    
    @IBAction func globalStatisticTapped(_ sender: Any) {
        
        let homeViewController = self.storyboard?.instantiateViewController(identifier: Constants.Stroryboard.homeViewController) as? HomeViewController
        
        self.view.window?.rootViewController = homeViewController
        self.view.window?.makeKeyAndVisible()
    }
    @IBAction func countryStatisticTapped(_ sender: Any) {
        
        let countryStatistic = self.storyboard?.instantiateViewController(identifier: Constants.Stroryboard.countryStatistic) as? CountryStatisticViewController
        
        self.view.window?.rootViewController = countryStatistic
        self.view.window?.makeKeyAndVisible()
    }
    
    
}
