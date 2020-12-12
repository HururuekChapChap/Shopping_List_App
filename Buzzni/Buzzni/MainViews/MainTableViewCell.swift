//
//  MainTableViewCell.swift
//  Buzzni
//
//  Created by yoon tae soo on 2020/12/11.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    
    @IBOutlet weak var insideTableView: UITableView!
    
    var selectedBtn : Bool = false
    
    var expandHandler : ((Bool)->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //storyBoard에서도 Nib으로 생성되는 것과 마찬가지의 역할을 한다.
        //따라서 내부에 tableView를 만들게 될 때 이렇게 호출해도 된다.
        setInsideTableViewDelegate()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func expandViewBtn(_ sender: UIButton) {
        
        selectedBtn = !selectedBtn
        expandHandler?(selectedBtn)
        
    }
}

extension MainTableViewCell : UITableViewDelegate , UITableViewDataSource {

    func setInsideTableViewDelegate(){
        insideTableView.delegate = self
        insideTableView.dataSource = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = insideTableView.dequeueReusableCell(withIdentifier: "InsideCell") as? InsideTableViewCell else {return UITableViewCell()}
        
        cell.backgroundColor = .red
        
        return cell
        
    }


}
