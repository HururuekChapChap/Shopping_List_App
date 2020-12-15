//
//  LiveViewController.swift
//  Buzzni
//
//  Created by yoon tae soo on 2020/12/15.
//

import UIKit

class LiveViewController: UIViewController {

    @IBOutlet weak var liveCollectionView: UICollectionView!
    @IBOutlet weak var liveView: UIView!
    
    var liveItems : [liveModel]? {
        didSet{
            DispatchQueue.main.async { [weak self] in
                self?.liveCollectionView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setLiveCollectionViewDelegate()
        
//        print(liveItems)
    }
    
    @IBAction func closePopView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension LiveViewController : UICollectionViewDelegate , UICollectionViewDataSource {
    
    func setLiveCollectionViewDelegate(){
        liveCollectionView.delegate = self
        liveCollectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let liveItems  = liveItems {
            
            return liveItems[0].data.count
            
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let liveItems = liveItems else {return UICollectionViewCell()}
        
        guard let cell = liveCollectionView.dequeueReusableCell(withReuseIdentifier: "LiveCollectionViewCell", for: indexPath) as? LiveCollectionViewCell else {return UICollectionViewCell()}
        
        cell.updateLiveImageViewUI(liveItem: liveItems[0].data[indexPath.item])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionView.elementKindSectionHeader :
            
            guard let liveItems = liveItems else {return UICollectionReusableView()}
            
            guard let header = liveCollectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "LiveCollectionHeaderView", for: indexPath) as? LiveCollectionHeaderView else {return UICollectionReusableView()}
            
            
            header.updateLiveImageViewUI(liveItem: liveItems[0].data[0])
            
            return header
        
        default:
            return UICollectionReusableView()
        }
        
    }
    
}

extension LiveViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let numberOfItems : CGFloat = 2
        let itemSpacing : CGFloat = 10
        let sideSpacing : CGFloat = 5 * 2 //양쪽 벽
        
        let width : CGFloat = (liveView.bounds.width - ( ((numberOfItems - 1) * itemSpacing) + sideSpacing) ) / numberOfItems
        
        let height : CGFloat = width
        
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: liveView.bounds.width , height: 200)
    }
    
}
