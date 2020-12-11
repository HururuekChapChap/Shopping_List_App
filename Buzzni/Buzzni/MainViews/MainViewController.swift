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
    
    var selectedCellPath: [IndexPath] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        setTableViewDelegate()
        
        apiViewModel.getfetchData(input_url: apiViewModel.makeUrl(dateTime: nil)) { (result) in
            
            switch result {
            
            case .success(let _):
                print("Get Data Success")
            case .failure(let error):
                print(error.rawValue)
            }
            
        }
        
    }
    

}

extension MainViewController : UITableViewDelegate, UITableViewDataSource{
    
    private func setTableViewDelegate(){
        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = mainTableView.dequeueReusableCell(withIdentifier: "MainCell") as? MainTableViewCell else {return UITableViewCell()}
        
        cell.expandHandler = { [weak self] in
            
            self?.selectedCellPath.append(indexPath)
            self?.mainTableView.reloadRows(at: self!.selectedCellPath, with: .none)
            
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if !selectedCellPath.isEmpty && selectedCellPath.contains(indexPath){

            return 280
        }
        
        return 190
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 && selectedCellPath.contains(indexPath){
            print("Cell 0")
            
//            let temp = cell as! MainTableViewCell
            
            
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        selectedCellPath.append(indexPath)
//
//        mainTableView.reloadRows(at: selectedCellPath, with: .none)
        
    }
    

    
    
}
