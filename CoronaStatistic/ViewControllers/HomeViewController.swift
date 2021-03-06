//
//  HomeViewController.swift
//  CoronaStatistic
//
//  Created by Vardges Gasparyan on 2020-04-25.
//  Copyright © 2020 Vardges Gasparyan. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let casesLabel = "total cases: "
    let tRecoveredLabel = "total recovered: "
    let tUnresolvedLabel = "total unresolved: "
    let tDeathsLabel = "total deaths: "
    let newCasesLabel = "new cases today: "
    let newDeathsLabel = "new deaths today: "
    let activeCasesLabel = "total active cases: "
    let seriousCasesLabel = "serious cases: "
    let affectedCountriesLabel = "affected countries: "
    
    var casesResult = ""
    var tRecoveredResult = ""
    var tUnresolvedResult = ""
    var tDeathsResult = ""
    var newCasesResult = ""
    var newDeathsResult = ""
    var activeCasesResult = ""
    var seriousCasesResult = ""
    var affectedCountriesResult = ""
    
    @IBOutlet weak var timelineStatisticButton: UIBarButtonItem!
    @IBOutlet weak var countryStatisticButton: UIBarButtonItem!
    @IBOutlet weak var logOutButton: UIBarButtonItem!
    @IBOutlet weak var globalStatisticTableView: UITableView!
    
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
    
    @IBAction func timelineStatisticButton(_ sender: Any) {
        
        let countryTLStatistic = self.storyboard?.instantiateViewController(identifier: Constants.Stroryboard.countryTLStatistic) as? CTLStatisticViewController
        
        self.view.window?.rootViewController = countryTLStatistic
        self.view.window?.makeKeyAndVisible()
    }
    
    func jsonParse() {

//        let urlString = "https://api.thevirustracker.com/free-api?global=stats"
        let urlString = "https://disease.sh/v3/covid-19/all?yesterday=true&twoDaysAgo=false&allowNull=true"
        
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

//                    if let endResults = json["results"] as? Array<Dictionary<String, Any>> {

//                        for endResult in json {

                            if let tCases = json["cases"] as? Int {
                                self.casesResult = String(tCases)
                                print(tCases)
                            }
                            if let tRecovered = json["recovered"] as? Int {
                                self.tRecoveredResult = String(tRecovered)
                                print(tRecovered)
                            }
                            if let tUnresolved = json["active"] as? Int {
                                self.tUnresolvedResult = String(tUnresolved)
                                print(tUnresolved)
                            }
                            if let tDeaths = json["deaths"] as? Int {
                                self.tDeathsResult = String(tDeaths)
                                print(tDeaths)
                            }
                            if let newCasesToday = json["todayCases"] as? Int {
                                self.newCasesResult = String(newCasesToday)
                                print(newCasesToday)
                            }
                            if let newDeathsToday = json["todayDeaths"] as? Int {
                                self.newDeathsResult = String(newDeathsToday)
                                print(newDeathsToday)
                            }
                            if let activeCases = json["active"] as? Int {
                                self.activeCasesResult = String(activeCases)
                                print(activeCases)
                            }
                            if let seriousCases = json["critical"] as? Int {
                                self.seriousCasesResult = String(seriousCases)
                                print(seriousCases)
                            }
                            if let affectedCountries = json["affectedCountries"] as? Int {
                                self.affectedCountriesResult = String(affectedCountries)
                                print(affectedCountries)
                            }
//                        }
//                    }
                    
                    DispatchQueue.main.async { self.globalStatisticTableView.reloadData() }
                }
            } catch {

                print(err?.localizedDescription ?? "Error Localize")
            }
        }

        } .resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        globalStatisticTableView.delegate = self
        globalStatisticTableView.dataSource = self
        globalStatisticTableView.register(UINib(nibName: "GlobalStatisticCell", bundle: nil), forCellReuseIdentifier : "globalStatCell")
        
        jsonParse()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let globalStatisticCell = tableView.dequeueReusableCell(withIdentifier: "globalStatCell", for: indexPath) as! GlobalStatisticCell

        globalStatisticCell.tCasesLabel.text = casesLabel
        globalStatisticCell.tRecoveredLabel.text = tRecoveredLabel
        globalStatisticCell.tUnresolvedLabel.text = tUnresolvedLabel
        globalStatisticCell.tDeathsLabel.text = tDeathsLabel
        globalStatisticCell.newCasesLabel.text = newCasesLabel
        globalStatisticCell.newDeathsLabel.text = newDeathsLabel
        globalStatisticCell.activeCasesLabel.text = activeCasesLabel
        globalStatisticCell.seriousCasesLabel.text = seriousCasesLabel
        globalStatisticCell.affectedCountriesLabel.text = affectedCountriesLabel
        
        globalStatisticCell.tCasesResult.text = casesResult
        globalStatisticCell.tRecoveredResult.text = tRecoveredResult
        globalStatisticCell.tUnresolvedResult.text = tUnresolvedResult
        globalStatisticCell.tDeathsResult.text = tDeathsResult
        globalStatisticCell.newCasesResult.text = newCasesResult
        globalStatisticCell.newDeathsResult.text = newDeathsResult
        globalStatisticCell.activeCasesResult.text = activeCasesResult
        globalStatisticCell.seriousCasesResult.text = seriousCasesResult
        globalStatisticCell.affectedCountriesResult.text = affectedCountriesResult

        return globalStatisticCell
    }
}
