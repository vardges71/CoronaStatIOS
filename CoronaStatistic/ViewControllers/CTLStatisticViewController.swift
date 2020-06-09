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
import CoreData

class CTLStatisticViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var cCode = ""
    var finalStatArray = [TotalDays]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var statArray: Array = [""]
    
    let countryLabel = "country: "
    let tCasesLabel = "total cases: "
    let tRecoveredLabel = "total recovered: "
    let tDeathsLabel = "total deaths: "
    let newCasesLabel = "new cases: "
    let newDeathsLabel = "new deaths: "
    
//    var timelineDateResult = ""
//    var countryResult = ""
//    var tCasesResult = "25603"
//    var tRecoveredResult = "24777"
//    var tDeathsResult = "3"
//    var newCasesResult = "1456"
//    var newDeathsResult = "1.5"
    
    
    @IBOutlet weak var cLabel: UILabel!
    @IBOutlet weak var cResult: UILabel!
    
    @IBOutlet weak var globalStatisticButton: UIBarButtonItem!
    @IBOutlet weak var countryStatisticButton: UIBarButtonItem!
    @IBOutlet weak var logOutTapped: UIBarButtonItem!
    
    @IBOutlet weak var countryTimeLine: UITableView!
    @IBOutlet weak var countryCodeTextField: UITextField!
    @IBOutlet weak var btnShow: UIButton!
    
    
    @IBAction func btnShowTapped(_ sender: Any) {
        
        self.finalStatArray.removeAll()
        jsonParse()
        loadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        finalStatArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let timeLineStatisticCell = countryTimeLine.dequeueReusableCell(withIdentifier: "timeLineCell", for: indexPath) as! TimeLineStatisticCell
        
        let statistic = finalStatArray[indexPath.row]
        
        timeLineStatisticCell.dateResult?.text = statistic.dateResult
        
        timeLineStatisticCell.tCasesLabel.text = tCasesLabel
        timeLineStatisticCell.tRecoveredLabel.text = tRecoveredLabel
        timeLineStatisticCell.tDeathsLabel.text = tDeathsLabel
        timeLineStatisticCell.newCasesLabel.text = newCasesLabel
        timeLineStatisticCell.newDeathsLabel.text = newDeathsLabel
        
        timeLineStatisticCell.tCasesResult?.text = statistic.tCasesResult
        timeLineStatisticCell.tRecoveredResult?.text = statistic.tRecoveredResult
        timeLineStatisticCell.tDeathsResult?.text = statistic.tDeathsResult
        timeLineStatisticCell.newCasesResult?.text = statistic.newCasesResult
        timeLineStatisticCell.newDeathsResult?.text = statistic.newDeathsResult
        
        return timeLineStatisticCell
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        countryTimeLine.delegate = self
        countryTimeLine.dataSource = self
        
        self.cLabel.text = countryLabel
        setupElements()
        
// ******************************* Customise keyboard **************************************
        
        self.countryCodeTextField.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        // Do any additional setup after loading the view.
//
//        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
//        tap.cancelsTouchesInView = false
//        view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);
        
// ******************************************************************************************
        // Do any additional setup after loading the view.
    }
    
// ***************************** move text Field +*************************************
    
    @objc func tapDone(sender: Any) {
        
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
        
        self.view.frame.origin.y = -130
    }

    @objc func keyboardWillHide(sender: NSNotification) {
         self.view.frame.origin.y = 0 // Move view to original position
    }
    
// ************************************************************************************
    
    func setupElements() {
        
        Utilities.styleTextField(countryCodeTextField)
        Utilities.styleFilledButton(btnShow)
    }
    
// ************************* Bottom Navigation Part ********************************************************

    @IBAction func logOutTapped(_ sender: Any) {
        
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
    @IBAction func countryStatisticTapped(_ sender: Any) {
        
        let countryStatistic = self.storyboard?.instantiateViewController(identifier: Constants.Stroryboard.countryStatistic) as? CountryStatisticViewController
        
        self.view.window?.rootViewController = countryStatistic
        self.view.window?.makeKeyAndVisible()
    }
    
// *********************************************************************************************************
    
    func loadData() {

        countryTimeLine.reloadData()
        countryTimeLine.register(UINib(nibName: "TimeLineStatisticCell", bundle: nil), forCellReuseIdentifier : "timeLineCell")
        countryTimeLine.delegate = self
        countryTimeLine.dataSource = self

    }
    
    func jsonParse() {
        
        cCode = countryCodeTextField.text!
        
        let urlString = "https://api.thevirustracker.com/free-api?countryTimeline=\(cCode)"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            DispatchQueue.main.async {
                
                if let err = err {

                    print("Failed to get data from URL", err)
                    return
                }
                
                guard let jsonData = data else { return }
                
                do {
                    
                    if let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String:Any] {
                        
// ************************************** Display Country Name ******************************************************
                        if let countryTimelineData = json["countrytimelinedata"] as? Array<Dictionary<String, Any>> {
                            for cTLData in countryTimelineData {
                                if let cInfo = cTLData["info"] as? Dictionary<String, Any> {
                                    if let cTitle = cInfo["title"] as? String {
                                        self.cResult.text = cTitle
                                        print(cTitle)
                                    }
                                }
                            }
                        }
// ******************************************************************************************************************
                        if let timelineResults = json["timelineitems"] as? NSArray {
                            
                            for timelineResult in timelineResults {
                                print(timelineResult)
                                
                                if var results = timelineResult as? [String: Any] {
                                    _ = results.removeValue(forKey: "stat")
                                    for (keys, values) in results {
                                        
                                        let newItem = TotalDays(context: self.context)
                                        newItem.dateResult = String(keys)
                                        print(newItem.dateResult!)
                                        print(results)
                                        if let statResult = values as? [String: Int] {
                                            
                                            if let totalCases = statResult["total_cases"] {
                                                newItem.tCasesResult = String(totalCases)
                                            }
                                            if let totalRecovered = statResult["total_recoveries"] {
                                                newItem.tRecoveredResult = String(totalRecovered)
                                            }
                                            if let totalDeaths = statResult["total_deaths"] {
                                                newItem.tDeathsResult = String(totalDeaths)
                                            }
                                            if let newCases = statResult["new_daily_cases"] {
                                                newItem.newCasesResult = String(newCases)
                                            }
                                            if let newDeaths = statResult["new_daily_deaths"] {
                                                newItem.newDeathsResult = String(newDeaths)
                                            }
                                        }
                                        
                                        self.finalStatArray.append(newItem)
                                    }
                                }
                            }
                        }
                        
                        DispatchQueue.main.async { self.countryTimeLine.reloadData() }
                    }
                } catch {
                
                    print(err? .localizedDescription ?? "Localize Description")
                }
            }
        }.resume()
    }
}


//let newItem = TotalDays(context: self.context)
//newItem.dateResult = date
//self.statArray.append(newItem)
