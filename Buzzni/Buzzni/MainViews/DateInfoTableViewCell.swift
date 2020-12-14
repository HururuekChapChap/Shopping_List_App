//
//  DateInfoTableViewCell.swift
//  Buzzni
//
//  Created by yoon tae soo on 2020/12/12.
//

import UIKit

//4일차 - 날짜 변경을 보여주는 셀
class DateInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var dateInfoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateDateInfoLabel(items : (mon : Int?, day : Int?, weekday : String?)){
        
        dateInfoLabel.text = "\(items.mon ?? -1)월 \(items.day ?? -1)일 \n \(items.weekday ?? "데이터 오류")"

    }

}
