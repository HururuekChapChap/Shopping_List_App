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
    var noDataSection : [Int] = []
    var noMoreFetch : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setTableViewDelegate()
        
        //1일차 - 예측되는 셀크기 주지 않을 경우 오류
        //4일차 - 잠시 틈을 만든다고 StoryBoard를 수정했더니 190에서 오류나서 늘려줬음
        mainTableView.estimatedRowHeight = 192
        
        //2일차 - View의 중앙
        viewcenter = view.center.x
        
        //2일차 - 월일이 들어가는 부분 찾기
        noDataSection = utilityViewModel.check_noDataSection(itemData: itemData ?? [])
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func liveViewBtn(_ sender: UIButton) {
        
        print("LiveView")
    }
    
}

extension MainViewController : UITableViewDelegate, UITableViewDataSource{
    
    private func setTableViewDelegate(){
        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
    }
    
    //2일차 - 총 섹션의 갯수
    func numberOfSections(in tableView: UITableView) -> Int {
        return itemData?.count ?? 0
    }
    
    //2일차 - sectino의 크기
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    //2일차 - section에 들어갈 뷰 생성
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let itemData = itemData else {return UIView()}
        
        //2일차 - 달월이 들어가는 section 비우기
        if noDataSection.contains(section) {
            
            let view = utilityViewModel.make_sectionView(viewCenter: viewcenter,
                                                     inputText: "")
            return view
            
        }
        
        //2일차 - 그외에는 시간이 들어가도록 구현
        let view  = utilityViewModel.make_sectionView(viewCenter: viewcenter,
                                                     inputText: itemData[section].time!)
        
        return view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let itemData = itemData else {return 0}
        
        if noDataSection.contains(section) {
            return 1
        }
        
        //2일차 - 해당 section에 해당하는 편성표 호출 ( 각 section 에 들어갈 cell의 갯수 지정)
        return itemData[section].data!.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let itemData = itemData else {return UITableViewCell()}
        
        //1일차
        if itemData[indexPath.section].data != nil {
            
            guard let cell = mainTableView.dequeueReusableCell(withIdentifier: "MainCell") as? MainTableViewCell else {return UITableViewCell()}
            
                cell.sameTimeItems = itemData[indexPath.section].data![indexPath.row].sametime
                cell.updateCellView(itemModel: itemData[indexPath.section].data![indexPath.row])
            
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
        
        //2일차 - 월일에 해당하는 Section일 경우에
        guard let cell = mainTableView.dequeueReusableCell(withIdentifier: "DateInfoCell") as? DateInfoTableViewCell else {return UITableViewCell()}
        
        let items = itemData[indexPath.section]
        
        let itemTuple : (mon : Int?, day : Int?, weekday : String?) = (items.month , items.day, items.weekday_kor)
        
        cell.updateDateInfoLabel(items: itemTuple)
        
        return cell
        
    }
    
    //각 셀의 크기 지정
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        guard let _ = itemData else {return 0}
        
        //2일차 - 월일에 해당하는 섹션일 경우의 CELL 크기
        if noDataSection.contains(indexPath.section){
            return 100
        }
        
        //1일차 - 버튼을 누렀을 경우 CELL 확장
        if !selectedCellPath.isEmpty && selectedCellPath.contains(indexPath){

            return 280
        }
        
        //1일차
        return UITableView.automaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {}
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}
    
}

extension MainViewController : UIScrollViewDelegate {
    
    //3일차 - pagination
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let contentOffset_y = scrollView.contentOffset.y
        let tableViewContentSize = mainTableView.contentSize.height
        let pagination_y = tableViewContentSize * 0.2
        
        if contentOffset_y > tableViewContentSize - pagination_y {
            
            // is_continues 상태가 -1 일 경우 fetch 금지
            if noMoreFetch {return}
            
            let lastDayTime = utilityViewModel.get_lastTime(itemData: itemData ?? [])
            
            let input_url = apiViewModel.makeUrl(dateTime: lastDayTime)
            
            if apiViewModel.isPagination {return}
            
            apiViewModel.getfetchData(input_url: input_url) { [weak self](result) in

                
                switch result{
                
                case .success(let jsonData):
//                    print(jsonData)
                    self?.noMoreFetch = jsonData.is_continues != 0 ? true : false
                    let newItemData = jsonData.after_live
                    self?.itemData?.append(contentsOf: newItemData)
                    self?.noDataSection = self!.utilityViewModel.check_noDataSection(itemData: self!.itemData!)
                    
                    DispatchQueue.main.async {
                        self?.mainTableView.reloadData()
                        self?.apiViewModel.isPagination = false
                    }
                    
                    
                case .failure(let error):
                    print(error.rawValue)
                    //4일차
                    DispatchQueue.main.async {
                        let errView = self?.storyboard?.instantiateViewController(withIdentifier: "erroView")
                        self?.present(errView!, animated: true, completion: nil)
                    }
                    
                }
                
            }
            
        }
        
    }
    
}
