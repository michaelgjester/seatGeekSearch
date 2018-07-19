//
//  EventTableViewCell.swift
//  seatGeekSearch
//
//  Created by Michael Jester on 7/19/18.
//  Copyright © 2018 Michael Jester. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {

  @IBOutlet weak var eventTitleLabel: UILabel!
  
  
  @IBOutlet weak var eventDateTimeLabel: UILabel!
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
