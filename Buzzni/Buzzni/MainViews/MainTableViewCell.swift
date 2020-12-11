//
//  MainTableViewCell.swift
//  Buzzni
//
//  Created by yoon tae soo on 2020/12/11.
//

import UIKit

class MainTableViewCell: UITableViewCell {

    @IBOutlet weak var insideTableview: UIView!
    
    var expandHandler : (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func expandViewBtn(_ sender: UIButton) {
        
        expandHandler?()
    }
}
