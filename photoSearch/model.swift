//
//  model.swift
//  photoSearch
//
//  Created by Yotaro Ito on 2021/02/25.
//

import Foundation
 
struct APIResponse: Codable{
    let total: Int
    let total_pages: Int
    let results: [Result]
}

struct Result: Codable {
    let id: String
    let urls: URLS
}

struct URLS: Codable{
    let regular: String
}
