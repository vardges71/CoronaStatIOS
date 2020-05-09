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
    
    let countryLabel = "country: "
    let tCasesLabel = "total cases: "
    let tRecoveredLabel = "total recovered: "
    let tDeathsLabel = "total deaths: "
    let newCasesLabel = "new cases: "
    let newDeathsLabel = "new deaths: "
    
    var timelineDateResult = ""
    var countryResult = ""
    var tCasesResult = ""
    var tRecoveredResult = ""
    var tDeathsResult = ""
    var newCasesResult = ""
    var newDeathsResult = ""
    
    
    
    @IBOutlet weak var cLabel: UILabel!
    @IBOutlet weak var cResult: UILabel!
    
    @IBOutlet weak var globalStatisticButton: UIBarButtonItem!
    @IBOutlet weak var countryStatisticButton: UIBarButtonItem!
    @IBOutlet weak var logOutTapped: UIBarButtonItem!
    
    @IBOutlet weak var countryTimeLine: UITableView!
    @IBOutlet weak var countryCodeTextField: UITextField!
    @IBOutlet weak var btnShow: UIButton!
    
    
    @IBAction func btnShowTapped(_ sender: Any) {
        
        jsonParse()
        loadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return Constants.TimelineArray.datesCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let timeLineStatisticCell = tableView.dequeueReusableCell(withIdentifier: "timeLineCell", for: indexPath) as! TimeLineStatisticCell
        
        timeLineStatisticCell.dateResult.text = timelineDateResult
        
        timeLineStatisticCell.tCasesLabel.text = tCasesLabel
        timeLineStatisticCell.tRecoveredLabel.text = tRecoveredLabel
        timeLineStatisticCell.tDeathsLabel.text = tDeathsLabel
        timeLineStatisticCell.newCasesLabel.text = newCasesLabel
        timeLineStatisticCell.newDeathsLabel.text = newDeathsLabel
        
        timeLineStatisticCell.tCasesResult.text = tCasesResult
        timeLineStatisticCell.tRecoveredResult.text = tRecoveredResult
        timeLineStatisticCell.tDeathsResult.text = tDeathsResult
        timeLineStatisticCell.newCasesResult.text = newCasesResult
        timeLineStatisticCell.newDeathsResult.text = newDeathsResult
        
        return timeLineStatisticCell
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    
// *********************************************************************************************************
    
    func loadData() {

        countryTimeLine.reloadData()
        countryTimeLine.register(UINib(nibName: "TimeLineStatisticCell", bundle: nil), forCellReuseIdentifier : "timeLineCell")
        countryTimeLine.delegate = self
        countryTimeLine.dataSource = self

    }
    
    func jsonParse () {
        
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
                                if let cInfo = cTLData["info"] as? NSDictionary {
                                    if let cTitle = cInfo["title"] as? String {
                                        self.cResult.text = cTitle
                                        print(cTitle)
                                    }
                                }
                            }
                        }
// ******************************************************************************************************************
                        if let timelineItems = json["timelineitems"] as? [[String:Any]] {
                            for timelineItem in timelineItems {
                                print(timelineItem.count - 1)
                                Constants.TimelineArray.datesCount = timelineItem.count - 1
//                                print(timelineItem)
                            }
                        }
                        if let timelineStatistics = json["timelineitems"] as? Array<Dictionary<String, Any>> {
                            for timelineArray in timelineStatistics {
                                for (keys, values) in timelineArray {
                                    print(keys, values)
                                    
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
