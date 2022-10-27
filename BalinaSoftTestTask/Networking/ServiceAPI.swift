//
//  ServiceAPI.swift
//  BalinaSoftTestTask
//
//  Created by Tanya Samastroyenka on 27.10.2022.
//

import Foundation
import Moya

public enum ServiceAPI {
    case getData(page: Int)
    case uploadImage(Data, name: String, typeId: Int)
}

extension ServiceAPI: TargetType {
    public var baseURL: URL {
        URL(string: "https://junior.balinasoft.com/api/v2")!
    }
    
    public var path: String {
        switch self {
        case .getData:
            return "/photo/type"
        case .uploadImage:
            return "/photo"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .getData:
            return .get
        case .uploadImage:
            return .post
        }
    }
    
    public var task: Task {
        switch self {
        case let .getData(page):
            return .requestParameters(
                parameters: ["page": "\(page)"],
                encoding: URLEncoding.queryString)
            
        case let .uploadImage(data, name, typeId):
            let imageData = MultipartFormData(provider: .data(data),
                                              name: "photo",
                                              fileName: "testImage.png",
                                              mimeType: "image/png")
            let multipartData = [imageData]
            let urlParameters = ["name": name,
                                 "typeId": "\(typeId)"]

            return .uploadCompositeMultipart(multipartData, urlParameters: urlParameters)
        }
    }
    
    public var headers: [String : String]? {
        switch self {
        case .getData:
            return ["Content-Type": "application/json"]
        case .uploadImage:
            return ["Content-type": "multipart/form-data"]
        }
    }
}
