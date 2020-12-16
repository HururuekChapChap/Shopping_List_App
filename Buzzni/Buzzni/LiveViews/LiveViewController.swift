//
//  LiveViewController.swift
//  Buzzni
//
//  Created by yoon tae soo on 2020/12/15.
//

import UIKit

//5일차 - 생방송 중인 것들을 Collection View
class LiveViewController: UIViewController {

    @IBOutlet weak var liveCollectionView: UICollectionView!
    @IBOutlet weak var liveView: UIView!
    @IBOutlet weak var noLiveView: UIView!
    
    var noserviceClosure : (()->())?
    
    var liveItems : [liveModel]? {
        didSet{
            
            if liveItems?.isEmpty == true {
                noserviceClosure = {
                    UIView.animate(withDuration: 0) {
                        self.noLiveView.alpha = 1
                    }
                }
            }
            else{
                
                headerViewItem = liveItems![0].data[0]
                
                liveItems![0].data.removeFirst()
                
                DispatchQueue.main.async { [weak self] in
                    self?.liveCollectionView.reloadData()
                }
            }
        }
    }
    
    var headerViewItem : ItemModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setLiveCollectionViewDelegate()
        liveView.layer.cornerRadius = 15
//        print(liveItems)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        noserviceClosure?()
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
        
        if let liveItems = liveItems , !liveItems.isEmpty {
            
            return liveItems[0].data.count
            
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let liveItems = liveItems else {return UICollectionViewCell()}
        
        guard let cell = liveCollectionView.dequeueReusableCell(withReuseIdentifier: "LiveCollectionViewCell", for: indexPath) as? LiveCollectionViewCell else {return UICollectionViewCell()}
        
        cell.updateLiveImageViewUI(liveItem: liveItems[0].data[indexPath.item] )
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let returnHeaderView = UICollectionReusableView()
        returnHeaderView.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        
        switch kind {
        case UICollectionView.elementKindSectionHeader :
            
            
            guard let header = liveCollectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "LiveCollectionHeaderView", for: indexPath) as? LiveCollectionHeaderView else {return UICollectionReusableView()}
            
            guard let headerViewItem = headerViewItem else {
                print("no Header View")
                return header}
                
            header.updateLiveImageViewUI(liveItem: headerViewItem)
            
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
