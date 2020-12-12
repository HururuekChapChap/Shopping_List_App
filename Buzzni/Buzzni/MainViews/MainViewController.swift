//
//  MainViewController.swift
//  Buzzni
//
//  Created by yoon tae soo on 2020/12/11.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var mainTableView: UITableView!
    
    let apiViewModel = ApiViewModel()
    let utilityViewModel = UtilityViewModel()
    
    
    var selectedCellPath: [IndexPath] = []
    var itemData : [dataModel]?
    var liveData : [liveModel]?
    
    var viewcenter : CGFloat = 0
    var noDataSection : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setTableViewDelegate()
        
        //1일차 - 예측되는 셀크기 주지 않을 경우 오류
        mainTableView.estimatedRowHeight = 190
        
        //1일차
        viewcenter = view.center.x
        
        //2일차 - 월일이 들어가는 부분 찾기
        noDataSection = utilityViewModel.check_noDataSection(itemData: itemData ?? [])
    
    }
    

}

extension MainViewController : UITableViewDelegate, UITableViewDataSource{
    
    private func setTableViewDelegate(){
        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
    }
    
    //2일차 총 섹션의 갯수
    func numberOfSections(in tableView: UITableView) -> Int {
        return itemData?.count ?? 0
    }
    
    //2일차 sectino의 크기
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let itemData = itemData else {return UIView()}
        
        if section == noDataSection {
            
            let view = utilityViewModel.make_sectionView(viewCenter: viewcenter,
                                                     inputText: "")
            return view
            
        }
    
        let view  = utilityViewModel.make_sectionView(viewCenter: viewcenter,
                                                     inputText: itemData[section].time!)
        
        return view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let itemData = itemData else {return 0}
        
        if section == noDataSection {
            return 1
        }

        return itemData[section].data!.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let itemData = itemData else {return UITableViewCell()}
        
        if itemData[indexPath.section].data != nil {
            
            guard let cell = mainTableView.dequeueReusableCell(withIdentifier: "MainCell") as? MainTableViewCell else {return UITableViewCell()}
           
                   cell.expandHandler = { [weak self] (response) in
           
                       if response {
                           self?.selectedCellPath.append(indexPath)
                       }
                       else{
                           self?.selectedCellPath = self!.selectedCellPath.filter({ (index) -> Bool in
                               return index != indexPath
                           })
                       }

                       self?.mainTableView.reloadRows(at: self!.selectedCellPath, with: .none)
           
                   }
            
            return cell
            
        }
        
        guard let cell = mainTableView.dequeueReusableCell(withIdentifier: "DateInfoCell") as? DateInfoTableViewCell else {return UITableViewCell()}
        
            cell.contentView.backgroundColor = .black
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        guard let _ = itemData else {return 0}
        
        if indexPath.section == noDataSection{
            return 100
        }
        
        
        if !selectedCellPath.isEmpty && selectedCellPath.contains(indexPath){

            return 280
        }
        
        return UITableView.automaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {}
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}
    
}
