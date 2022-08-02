//
//  EventCell.swift
//  EarthQuake
//
//  Created by Peter Liaw on 7/29/22.
//

import UIKit

/// UITableViewCell for each earthquake event
class EventCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    static let reuseId = String(describing: EventCell.self)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
