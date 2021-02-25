//
//  Model.swift
//  TabilogIOS
//
//  Created by 藤森千裕 on 2021/02/25.
//

import Foundation

struct Responce: Codable {
    var articles: [Article] //Articleの配列
}

struct Article: Codable {
    var id: Int?
    var title: String?
    var body: String?
    var article_image: Thumb?
    var address: String?
    var latitude: Double?
    var longitude: Double?
}
struct Thumb: Codable {
    var thumb: Url
}
struct Url: Codable {
    var url: String?
}
