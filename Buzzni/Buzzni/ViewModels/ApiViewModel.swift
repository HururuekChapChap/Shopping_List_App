//
//  ApiViewModel.swift
//  Buzzni
//
//  Created by yoon tae soo on 2020/12/11.
//

import Foundation
import UIKit
import RxSwift

enum ApiError : String, Error{
    
    case urlError = "URL 에러입니다."
    case sessionError = "session 에러입니다"
    case stateCodeError = "stateCode 에러입니다"
    case emptyDataError = "Data가 비어 있습니다"
    case getDataError = "Data를 파싱과정 오류입니다."
}

class ApiViewModel {
    
    private let urlconfig = URLSessionConfiguration.default
    
    var isPagination : Bool = false
    
    //1일차 - url 생성 함수
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
     
    //1일차 - Http Network 통신으로 데이터 가져오는 함수
    func getfetchData(input_url : URL?, completeHandler : @escaping (Result<after_liveModel,ApiError>) -> ()){
        
        isPagination = true
        
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
                
                let returnValue = items.result
                
                completeHandler(.success(returnValue))
                
            }
            //3일차 - 가끔씩 typeMismatch 오류가 뜨는데,,, 왜지? ㅠㅠ
            //4일차 - 찾았음... Live에 "start_datetime": -1" 이 가능했다,,,,
            catch DecodingError.keyNotFound(let key, let context){
                print("could not find key \(key) in JSON: \(context.debugDescription)")
            }
            catch DecodingError.valueNotFound(let key, let context){
                print("could not find key \(key) in JSON: \(context.debugDescription)")
            }
            catch DecodingError.typeMismatch(let type, let context) {
                print("type mismatch for type \(type) in JSON: \(context.debugDescription)")
            } catch DecodingError.dataCorrupted(let context) {
                print("data found to be corrupted in JSON: \(context.debugDescription)")
            }
            catch let jsonError{
                print(jsonError.localizedDescription)
                completeHandler(.failure(.getDataError))
            }
           
            
        }.resume()
   
    }
    
    //1일차 - Network state 점검 코드
    private func checkStateCode(response : URLResponse? ) -> Bool{
        
        guard let statecode = (response as? HTTPURLResponse)?.statusCode else {
            return false
        }
        
        let safeRange = 200..<300
        
        return safeRange.contains(statecode) ? true : false
        
    }
    
    
    //3일차 - image 가져오는 함수
    func getUIImage(imageUrl : String , complete : ((UIImage?)->())? ){
        
        guard let url = URL(string: imageUrl) else {
            complete?(nil)
            return}
        
        DispatchQueue.global().async {
            
            guard let imageData = try? Data(contentsOf: url) else {
                complete?(nil)
                return}
            
            let image = UIImage(data: imageData)
            
            complete?(image)
            
        }
        
    }
    
    //3일차 - image 가져오는 함수 with RxSwift
    func getUIimage(imageUrl : String) -> Observable<UIImage>{
        
        return Observable.create(){ emitter in
            
            guard let url = URL(string: imageUrl) else {
                emitter.onError(ApiError.urlError)
                return Disposables.create()
            }
            
            guard let imageData = try? Data(contentsOf: url) else {
                emitter.onError(ApiError.emptyDataError)
                return Disposables.create()}
            
            emitter.onNext(UIImage(data: imageData)!)
            emitter.onCompleted()
            
            return Disposables.create()
        }
        
    }
    
    
    
 
    
}

