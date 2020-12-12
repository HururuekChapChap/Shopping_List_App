//
//  LaunchViewController.swift
//  Buzzni
//
//  Created by yoon tae soo on 2020/12/12.
//

import UIKit

class LaunchViewController: UIViewController {
    
    let apiViewModel = ApiViewModel()
    let utilityViewModel = UtilityViewModel()
    
    //2일차
    var jsonData : after_liveModel? {
        
        didSet{
            moveMainViewController()
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //2일차
        let beforeTime = utilityViewModel.make_oneHour_before()
        
        print(beforeTime)
        //2일차
        apiViewModel.getfetchData(input_url: apiViewModel.makeUrl(dateTime: beforeTime)) { [weak self] (result) in
            
            switch result {
            
            case .success(let data):
                self?.jsonData = data
//                print(self!.jsonData!.live)
            case .failure(let error):
                print(error.rawValue)
            }
            
        }
        
    }
    
    //2일차
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "moveMainViewSegue"{
            
            guard let vc = segue.destination as? MainViewController else {return}
            
            vc.itemData = jsonData?.after_live
            vc.liveData = jsonData?.live
            
            
        }
        
        
        
    }
    
    //2일차
    func moveMainViewController(){
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.performSegue(withIdentifier: "moveMainViewSegue", sender: nil)
        }
        
    }
    

}
