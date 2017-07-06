//
//  ResponseTableViewCell.swift
//  Hello Webpage
//
//  Created by James Birchall on 10/05/2017.
//  Copyright © 2017 James Birchall. All rights reserved.
//

import UIKit

class ResponseTableViewCell: UITableViewCell {
    
    // MARK: IBOutlets
    @IBOutlet weak var responseImage: UIImageView!
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var responseLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
