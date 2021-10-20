//
//  AFRequest.swift
//  Demo app Stepanok
//
//  Created by  Stepanok Ivan on 19.10.2021.
//

import Foundation
import Alamofire

class AFRequest {
    
    static func loadData(completion: @escaping (_ jsonData: RootClass)->()) {
        let url = "http://storage42.com/modulotest/data.json"
        
        DispatchQueue.global().async {
            AF.request(url, method: .get).validate().response { responce in
                print(responce)
                guard let data = responce.data else {return}
                do {
                    let decoder = JSONDecoder()
                    let decodedData = try decoder.decode(RootClass.self, from: data)
                    print(decodedData)
                    completion(decodedData)
                } catch let error {
                    print(error)
                }
            }
        }
    }
}
