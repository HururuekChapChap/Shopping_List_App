//
//  InsideTableViewCell.swift
//  Buzzni
//
//  Created by yoon tae soo on 2020/12/12.
//

import UIKit
import RxSwift

//4일차 - MainCell 내부에 TableViewCell
class InsideTableViewCell: UITableViewCell {

    @IBOutlet weak var insideImageView: UIImageView!
    @IBOutlet weak var insideStuffNameLabel: UILabel!
    
    let apiViewModel = ApiViewModel()
    let utilityViewModel = UtilityViewModel()
    let disposeBag = DisposeBag()
    
    let imageCache = AppDelegate.imageCache
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //4일차 - Inside Table View Cell 업데이트 함수
    func updateCellUI(littleItemModel : LittleItemModel){
        
        let itemImage = littleItemModel.image
        
        updateImageView(imageUrl: itemImage)
        
        insideStuffNameLabel.text = littleItemModel.name
        
    }
    
    //4일차 - Image 가져오는 함수
    func updateImageView(imageUrl : String){
        
        if let image = imageCache.object(forKey: imageUrl as NSString){
            insideImageView.image = image
        }
        else{
        
            apiViewModel.getUIimage(imageUrl: imageUrl)
                .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .default))
                .observe(on: MainScheduler.instance)
                .subscribe { [weak self](event) in
                
                    switch event {
                
                    case .next(let image):
                        self?.insideImageView.image = image
                        self?.imageCache.setObject(image, forKey: imageUrl as NSString)
                    case .error(_):
                        self?.insideImageView.image = UIImage(named: "Buzzni.png")
                    case .completed:
                        break
                    }
                
                }.disposed(by: disposeBag)
            
        }
        
    }

}
