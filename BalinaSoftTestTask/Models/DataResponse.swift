//
//  DataResponse.swift
//  BalinaSoftTestTask
//
//  Created by Tanya Samastroyenka on 22.10.2022.
//

import Foundation

struct DataResponse: Codable {
    let page: Int
    let pageSize: Int
    let totalPages: Int
    let content: [Content]
}

struct Content: Codable {
    let id: Int
    let name: String
    let image: String?
}
