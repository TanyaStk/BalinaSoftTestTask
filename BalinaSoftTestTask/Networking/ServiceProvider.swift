//
//  ServiceProvider.swift
//  BalinaSoftTestTask
//
//  Created by Tanya Samastroyenka on 23.10.2022.
//

import Foundation
import UIKit
import Moya

protocol ServiceProviderProtocol {
    func getData(page: Int, completion: @escaping (DataResponse) -> Void)
    func postData(name: String, image: UIImage, typeId: Int)
}

class ServiceProvider: ServiceProviderProtocol {
    private let provider = MoyaProvider<ServiceAPI>()
    
    func getData(page: Int, completion: @escaping (DataResponse) -> Void) {
        provider.request(.getData(page: page)) { result in
            switch result {
            case let .success(response):
                do {
                    let data = try JSONDecoder().decode(DataResponse.self, from: response.data)
                    completion(data)
                } catch {
                    print("Parsing error!")
                }
            case let .failure(error):
                print(error.localizedDescription)
                return
            }
        }
    }
    
    func postData(name: String, image: UIImage, typeId: Int) {
        guard let pngImage = image.pngData() else {
            return
        }
        
        provider.request(.uploadImage(pngImage, name: name, typeId: typeId)) { result in
            print(result)
        }
    }
}
