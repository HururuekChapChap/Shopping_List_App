//
//  LiveCollectionViewCell.swift
//  Buzzni
//
//  Created by yoon tae soo on 2020/12/15.
//

import UIKit
import RxSwift

class LiveCollectionViewCell: UICollectionViewCell {
 
    @IBOutlet weak var liveImageView: UIImageView!
    
    @IBOutlet weak var liveStuffName: UILabel!
    let utilityViewModel = UtilityViewModel()
    let apiViewModel = ApiViewModel()
    
    let imageCache = AppDelegate.imageCache
    let disposeBag = DisposeBag()
    
    func updateLiveImageViewUI(liveItem : ItemModel){
        
        getImageView(ImageList: liveItem.image_list)
        
    }
    
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
