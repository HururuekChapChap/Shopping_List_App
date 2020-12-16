//
//  MainTableViewCell.swift
//  Buzzni
//
//  Created by yoon tae soo on 2020/12/11.
//

import UIKit
import RxSwift

class MainTableViewCell: UITableViewCell {
    
    @IBOutlet weak var insideTableView: UITableView!
    
    @IBOutlet weak var mainCellimageView: UIImageView!
    @IBOutlet weak var shopLabel: UILabel!
    @IBOutlet weak var castTimeLabel: UILabel!
    @IBOutlet weak var stuffNameLabel: UILabel!
    @IBOutlet weak var stuffPriceLabel: UILabel!
    @IBOutlet weak var expandBtn: UIButton!
    
    var selectedBtn : Bool = false
    
    //4일차 - 동시간대 Item들
    //mainViewController에서 받아왔을 때, 반드시 reloadData() 해줘야했다.
    var sameTimeItems : [LittleItemModel]? {
        didSet{
            insideTableView.reloadData()
        }
    }
    
    var expandHandler : ((Bool)->())?
    
    let apiViewModel = ApiViewModel()
    let utilityViewModel = UtilityViewModel()
    
    let imageCache = AppDelegate.imageCache
    let disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //1일차
        //storyBoard에서도 Nib으로 생성되는 것과 마찬가지의 역할을 한다.
        //따라서 내부에 tableView를 만들게 될 때 이렇게 호출해도 된다.
        setInsideTableViewDelegate()
        
        mainCellimageView.layer.borderWidth = 2
        mainCellimageView.layer.borderColor = UIColor.black.cgColor
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //1일차 - Cell 확장 통신 버튼
    @IBAction func expandViewBtn(_ sender: UIButton) {
        
        guard let items = sameTimeItems else {return}
//        print(items.count)
        if items.isEmpty {return}
        
        selectedBtn = !selectedBtn
        expandHandler?(selectedBtn)
        
    }
    //3일차 - tableView reuse 상태
    override func prepareForReuse() {
        mainCellimageView.image = nil
        shopLabel.text = nil
        stuffNameLabel.text = nil
        stuffPriceLabel.text = nil
        castTimeLabel.text = nil
    }
}

extension MainTableViewCell {
    
    //3일차 - Cell 뷰 업데이트 함수
    func updateCellView(itemModel : ItemModel){
        
        if let imageUrl = itemModel.image_list{
//            print(imageUrl[0])
            updateImageView(imageUrl: imageUrl[0])
        }
        else{
            DispatchQueue.main.async {self.mainCellimageView.image = UIImage(named: "Buzzni.png")}
        }
        
        shopLabel.text = itemModel.shop ?? ""
        stuffNameLabel.text = itemModel.name ?? ""
        let priceString = itemModel.price ?? 0
        stuffPriceLabel.text = priceString < 10 ? "상담/렌탈" : priceString.currencyKR
        updatePriceLabel(startTime: itemModel.start_datetime, endTime: itemModel.end_datetime)
        expandBtn.setTitle("같은 시간대 판매 상품 \(itemModel.sametime?.count ?? 0)개", for: .normal)
        
    }
    
    //3일차 - PriceLabel 변경
    func updatePriceLabel(startTime : DynamicJsonProperty? , endTime : String?){
        
        guard let startTime = startTime , let endTime = endTime else {
            castTimeLabel.text = "미지정~미지정"
            return
        }
        
        var newStartTime : String
        
        switch startTime {
            
        case .int(let value):
             newStartTime = utilityViewModel.make_removeLastTwoZero(inputTime: String(value))
        case .string(let value):
            newStartTime = utilityViewModel.make_removeLastTwoZero(inputTime: String(value))

        }
        
        let newEndTime = utilityViewModel.make_removeLastTwoZero(inputTime: endTime)
        
        let start =  utilityViewModel.make_Date2TimeString(inputDate: utilityViewModel.make_String2Date(inputTime: newStartTime))
        
        let end =  utilityViewModel.make_Date2TimeString(inputDate: utilityViewModel.make_String2Date(inputTime: newEndTime))
        
        castTimeLabel.text = "\(start)~\(end)"
    }
    
    //3일차 - URL로 이미지 가져오는 함수
    func updateImageView(imageUrl : String){
                
        if let image = imageCache.object(forKey: imageUrl as NSString){
            mainCellimageView.image = image
        }
        else{
        
            apiViewModel.getUIimage(imageUrl: imageUrl)
                .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .default))
                .observe(on: MainScheduler.instance)
                .subscribe { [weak self](event) in
                
                    switch event {
                
                    case .next(let image):
                        self?.mainCellimageView.image = image
                        self?.imageCache.setObject(image, forKey: imageUrl as NSString)
                    case .error(_):
                        self?.mainCellimageView.image = UIImage(named: "Buzzni.png")
                    case .completed:
                        break
                    }
                
                }.disposed(by: disposeBag)
            
        }
        
    }
    
}

extension MainTableViewCell : UITableViewDelegate , UITableViewDataSource {
    
    //1일차
    func setInsideTableViewDelegate(){
        insideTableView.delegate = self
        insideTableView.dataSource = self
    }
    
    //4일차 - Cell 갯수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return sameTimeItems?.count ?? 0
    }
    
    //4일차 - update Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let littleItems = sameTimeItems else {return UITableViewCell()}
        
        guard let cell = insideTableView.dequeueReusableCell(withIdentifier: "InsideCell") as? InsideTableViewCell else {return UITableViewCell()}
    
        cell.updateCellUI(littleItemModel: littleItems[indexPath.row])
 
        return cell
        
    }
    
    //4일차
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    


}
