//
//  LiveCollectionHeaderView.swift
//  Buzzni
//
//  Created by yoon tae soo on 2020/12/15.
//

import UIKit
import RxSwift

//5일차
class LiveCollectionHeaderView: UICollectionReusableView {
        
    @IBOutlet weak var liveImageView: UIImageView!
    @IBOutlet weak var liveShopName: UILabel!
    @IBOutlet weak var liveStuffName: UILabel!
    @IBOutlet weak var liveStuffPrice: UILabel!
    
    let utilityViewModel = UtilityViewModel()
    let apiViewModel = ApiViewModel()
    
    let imageCache = AppDelegate.imageCache
    let disposeBag = DisposeBag()
    
    //4일차 - Header UI update
    func updateLiveImageViewUI(liveItem : ItemModel){
        
        getImageView(ImageList: liveItem.image_list)
        liveShopName.text = liveItem.shop ?? ""
        liveStuffName.text = liveItem.name ?? ""
        let priceString = liveItem.price ?? 0
        liveStuffPrice.text = priceString < 10 ? "상담/렌탈" : priceString.currencyKR
        
    }
    
    //4일차 - 이미지 생성
    func getImageView(ImageList : [String]?){
        
        if let imageURL = ImageList {
            
            if let image = imageCache.object(forKey: imageURL[0] as NSString){
                liveImageView.image = image
            }
            else{
            
                apiViewModel.getUIimage(imageUrl: imageURL[0])
                    .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .default))
                    .observe(on: MainScheduler.instance)
                    .subscribe { [weak self](event) in
                    
                        switch event {
                    
                        case .next(let image):
                            self?.liveImageView.image = image
                            self?.imageCache.setObject(image, forKey: imageURL[0] as NSString)
                        case .error(_):
                            self?.liveImageView.image = UIImage(named: "Buzzni.png")
                        case .completed:
                            break
                        }
                    
                    }.disposed(by: disposeBag)
                
            }
        }
        else{
            liveImageView.image = UIImage(named: "Buzzni.png")
        }
        
        
    }
    
}
