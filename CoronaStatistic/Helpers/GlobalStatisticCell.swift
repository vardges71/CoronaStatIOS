//
//  GlobalStatisticCell.swift
//  CoronaStatistic
//
//  Created by Vardges Gasparyan on 2020-04-26.
//  Copyright © 2020 Vardges Gasparyan. All rights reserved.
//

import UIKit

class GlobalStatisticCell: UITableViewCell {

    @IBOutlet weak var tCasesLabel: UILabel!
    @IBOutlet weak var tCasesResult: UILabel!
    @IBOutlet weak var tRecoveredLabel: UILabel!
    @IBOutlet weak var tRecoveredResult: UILabel!
    @IBOutlet weak var tUnresolvedLabel: UILabel!
    @IBOutlet weak var tUnresolvedResult: UILabel!
    @IBOutlet weak var tDeathsLabel: UILabel!
    @IBOutlet weak var tDeathsResult: UILabel!
    @IBOutlet weak var newCasesLabel: UILabel!
    @IBOutlet weak var newCasesResult: UILabel!
    @IBOutlet weak var newDeathsLabel: UILabel!
    @IBOutlet weak var newDeathsResult: UILabel!
    @IBOutlet weak var activeCasesLabel: UILabel!
    @IBOutlet weak var activeCasesResult: UILabel!
    @IBOutlet weak var seriousCasesLabel: UILabel!
    @IBOutlet weak var seriousCasesResult: UILabel!
    @IBOutlet weak var affectedCountriesLabel: UILabel!
    @IBOutlet weak var affectedCountriesResult: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
