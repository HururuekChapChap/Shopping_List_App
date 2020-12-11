//
//  ApiViewModel.swift
//  Buzzni
//
//  Created by yoon tae soo on 2020/12/11.
//

import Foundation


enum ApiError : String, Error{
    
    case urlError = "URL 에러입니다."
    case sessionError = "session 에러입니다"
    case stateCodeError = "stateCode 에러입니다"
    case emptyDataError = "Data가 비어 있습니다"
    case getDataError = "Data를 파싱과정 오류입니다."
}

class ApiViewModel {
    
    private let urlconfig = URLSessionConfiguration.default
    
    func makeUrl(dateTime : String?) -> URL? {
        
        var urlComponet = URLComponents(string: "http://item.assignment.dev-k8s.buzzni.net/timeline?")!
        var urlDictionary : [String : String] = [
            "platform" : "ios",
            "time_size" : "4",
            "direction" : "down"
        ]
        
        if let date = dateTime {
            urlDictionary["base_time"] = date
        }
        
        urlComponet.queryItems = urlDictionary.map({ (key , value ) -> URLQueryItem in
            return URLQueryItem(name: key, value: value)
        })
        
        
        return urlComponet.url
        

    }
    
    func getfetchData(input_url : URL?, completeHandler : @escaping (Result<[dataModel],ApiError>) -> ()){
        
        guard let url = input_url else {
            completeHandler(.failure(.urlError))
            return
        }
        print(url)
        
        let session = URLSession(configuration: urlconfig)
        
        session.dataTask(with: url) { [weak self] (data, res, err) in
            
            if err != nil {
                completeHandler(.failure(.sessionError))
                return
            }
            
            
            guard self?.checkStateCode(response: res) == true else {
                completeHandler(.failure(.stateCodeError))
                return
            }
            
            
            guard let jsonData = data else {
                completeHandler(.failure(.emptyDataError))
                return
            }
            
            do{
                
                let items = try JSONDecoder().decode(resultModel.self, from: jsonData)
                
                let returnValue = items.result.after_live
                
                completeHandler(.success(returnValue))
                
            }
            catch let jsonError{
                print(jsonError.localizedDescription)
                completeHandler(.failure(.getDataError))
            }
            
        }.resume()
   
    }
    
    private func checkStateCode(response : URLResponse? ) -> Bool{
        
        guard let statecode = (response as? HTTPURLResponse)?.statusCode else {
            return false
        }
        
        let safeRange = 200..<300
        
        return safeRange.contains(statecode) ? true : false
        
    }
    
}
