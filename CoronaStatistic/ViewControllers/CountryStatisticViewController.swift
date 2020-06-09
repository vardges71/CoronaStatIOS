//
//  CountryStatisticViewController.swift
//  CoronaStatistic
//
//  Created by Vardges Gasparyan on 2020-04-25.
//  Copyright © 2020 Vardges Gasparyan. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class CountryStatisticViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var cCode = ""
    
    let countryLabel = "country: "
    let cTCasesLabel = "total cases: "
    let cTRecoveredLabel = "total recovered: "
    let cTUnresolvedLabel = "total unresolved: "
    let cTDeathsLabel = "total deaths: "
    let cTNewCasesLabel = "new cases today: "
    let cTNewDeathsLabel = "new deaths today: "
    let cTActiveCasesLabel = "active cases: "
    let cTSeriousCasesLabel = "serious cases: "
    
    var countryResult = ""
    var cTCasesResult = ""
    var cTRecoveredResult = ""
    var cTUnresolvedResult = ""
    var cTDeathsResult = ""
    var cTNewCasesResult = ""
    var cTNewDeathsResult = ""
    var cTActiveCasesResult = ""
    var cTSeriousCasesResult = ""
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
        let countryStatisticCell = tableView.dequeueReusableCell(withIdentifier: "countryCell", for: indexPath) as! CountryStatisticCell

        countryStatisticCell.countryLabel.text = countryLabel
        countryStatisticCell.tCasesLabel.text = cTCasesLabel
        countryStatisticCell.tRecoveredLabel.text = cTRecoveredLabel
        countryStatisticCell.tUnresolvedLabel.text = cTUnresolvedLabel
        countryStatisticCell.tDeathsLabel.text = cTDeathsLabel
        countryStatisticCell.newCasesLabel.text = cTNewCasesLabel
        countryStatisticCell.newDeathsLabel.text = cTNewDeathsLabel
        countryStatisticCell.activeCasesLabel.text = cTActiveCasesLabel
        countryStatisticCell.serCasesLabel.text = cTSeriousCasesLabel
        
        countryStatisticCell.countryResult.text = countryResult
        countryStatisticCell.tCasesResult.text = cTCasesResult
        countryStatisticCell.tRecoveredResult.text = cTRecoveredResult
        countryStatisticCell.tUnresolvedResult.text = cTUnresolvedResult
        countryStatisticCell.tDeathsResult.text = cTDeathsResult
        countryStatisticCell.newCasesResult.text = cTNewCasesResult
        countryStatisticCell.newDeathsResult.text = cTNewDeathsResult
        countryStatisticCell.activeCasesResult.text = cTActiveCasesResult
        countryStatisticCell.serCasesResult.text = cTSeriousCasesResult
        

        return countryStatisticCell
    }
    
    @IBOutlet weak var timelineStatisticButton: UIBarButtonItem!
    @IBOutlet weak var globalStatistic: UIBarButtonItem!
    @IBOutlet weak var logOutButton: UIBarButtonItem!
    
    @IBOutlet weak var countryStatTableView: UITableView!
    @IBOutlet weak var cCodeTextField: UITextField!
    @IBOutlet weak var showButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    
    @IBAction func showButton(_ sender: Any) {
        
        jsonParse()
        loadData()
    }
    
    @IBAction func clearButton(_ sender: Any) {
        
        cCodeTextField.text! = ""
        countryResult = ""
        cTCasesResult = ""
        cTRecoveredResult = ""
        cTUnresolvedResult = ""
        cTDeathsResult = ""
        cTNewCasesResult = ""
        cTNewDeathsResult = ""
        cTActiveCasesResult = ""
        cTSeriousCasesResult = ""
    }
    
    @IBAction func logOutButton(_ sender: Any) {
        
        let alert = UIAlertController(title: "Are you sure?", message: "Do you really want to logOut?", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { acion in
            
            Utilities.logOut()
            
            let firstVC = self.storyboard?.instantiateViewController(identifier: Constants.Stroryboard.firstVC) as? ViewController
            
            self.view.window?.rootViewController = firstVC
            self.view.window?.makeKeyAndVisible()
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))

        self.present(alert, animated: true)
    }
    
    @IBAction func globalStatisticTapped(_ sender: Any) {
        
        let homeViewController = self.storyboard?.instantiateViewController(identifier: Constants.Stroryboard.homeViewController) as? HomeViewController
        
        self.view.window?.rootViewController = homeViewController
        self.view.window?.makeKeyAndVisible()
    }
    
    @IBAction func timelineStatisticTapped(_ sender: Any) {
        
        let countryTLStatistic = self.storyboard?.instantiateViewController(identifier: Constants.Stroryboard.countryTLStatistic) as? CTLStatisticViewController
        
        self.view.window?.rootViewController = countryTLStatistic
        self.view.window?.makeKeyAndVisible()
    }
    
    func setupElements() {
        
        Utilities.styleTextField(cCodeTextField)
        Utilities.styleFilledButton(showButton)
        Utilities.styleHollowButton(clearButton)
    }
    
    func jsonParse() {

        cCode = cCodeTextField.text!
        
        let urlString = "https://api.thevirustracker.com/free-api?countryTotal=\(cCode)"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            DispatchQueue.main.async {

            if let err = err {

                print("Failed to get data from URL", err)
                return
            }
            guard let jsonData = data else { return }
                
            do {
                
                if let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                    
                    if let endResults = json["countrydata"] as? Array<Dictionary<String, Any>> {
                        
                        for endResult in endResults {

                            if let countryName = endResult["info"] as? Dictionary<String, Any> {
                                    
                                if let cTitle = countryName["title"] as? String {
                                self.countryResult = cTitle
                                print("Country Statistic : \(cTitle)")
                                }
                            }
                            
                            if let tCases = endResult["total_cases"] as? Int {
                                self.cTCasesResult = String(tCases)
                                print(tCases)
                            }
                            if let tRecovered = endResult["total_recovered"] as? Int {
                                self.cTRecoveredResult = String(tRecovered)
                                print(tRecovered)
                            }
                            if let tUnresolved = endResult["total_unresolved"] as? Int {
                                self.cTUnresolvedResult = String(tUnresolved)
                                print(tUnresolved)
                            }
                            if let tDeaths = endResult["total_deaths"] as? Int {
                                self.cTDeathsResult = String(tDeaths)
                                print(tDeaths)
                            }
                            if let newCasesToday = endResult["total_new_cases_today"] as? Int {
                                self.cTNewCasesResult = String(newCasesToday)
                                print(newCasesToday)
                            }
                            if let newDeathsToday = endResult["total_new_deaths_today"] as? Int {
                                self.cTNewDeathsResult = String(newDeathsToday)
                                print(newDeathsToday)
                            }
                            if let activeCases = endResult["total_active_cases"] as? Int {
                                self.cTActiveCasesResult = String(activeCases)
                                print(String(activeCases))
                            }
                            if let seriousCases = endResult["total_serious_cases"] as? Int {
                                self.cTSeriousCasesResult = String(seriousCases)
                                print(String(seriousCases))
                            }
                        }
                    }
                
                    DispatchQueue.main.async { self.countryStatTableView.reloadData() }
                }
            } catch {
                
                print(err?.localizedDescription ?? "Error Localize")
            }
        }
        }.resume()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupElements()
        
// *************************************************************************************************************
        self.cCodeTextField.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        // Do any additional setup after loading the view.
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);
        
// *************************************************************************************************************
        
    }
    
// *************************************************************************************************************
    
    @objc func tapDone(sender: Any) {
        
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
         self.view.frame.origin.y = -130 // Move view 150 points upward
    }

    @objc func keyboardWillHide(sender: NSNotification) {
         self.view.frame.origin.y = 0 // Move view to original position
    }
    
// *************************************************************************************************************
    
    func loadData() {

        countryStatTableView.reloadData()
        countryStatTableView.register(UINib(nibName: "CountryStatisticCell", bundle: nil), forCellReuseIdentifier : "countryCell")
        countryStatTableView.delegate = self
        countryStatTableView.dataSource = self
    }
}
