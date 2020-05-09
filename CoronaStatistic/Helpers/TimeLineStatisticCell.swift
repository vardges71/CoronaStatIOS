//
//  TimeLineStatisticCell.swift
//  CoronaStatistic
//
//  Created by Vardges Gasparyan on 2020-05-06.
//  Copyright © 2020 Vardges Gasparyan. All rights reserved.
//

import UIKit

class TimeLineStatisticCell: UITableViewCell {

    @IBOutlet weak var dateResult: UILabel!
    
    @IBOutlet weak var tCasesLabel: UILabel!
    @IBOutlet weak var tCasesResult: UILabel!
    @IBOutlet weak var tRecoveredLabel: UILabel!
    @IBOutlet weak var tRecoveredResult: UILabel!
    @IBOutlet weak var tDeathsLabel: UILabel!
    @IBOutlet weak var tDeathsResult: UILabel!
    @IBOutlet weak var newCasesLabel: UILabel!
    @IBOutlet weak var newCasesResult: UILabel!
    @IBOutlet weak var newDeathsLabel: UILabel!
    @IBOutlet weak var newDeathsResult: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
