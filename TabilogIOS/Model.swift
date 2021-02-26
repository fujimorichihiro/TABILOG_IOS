//
//  Model.swift
//  TabilogIOS
//
//  Created by 藤森千裕 on 2021/02/25.
//

import Foundation
import CoreLocation

struct Responce: Codable {
    var articles: [Article] //Articleの配列
}
//記事情報
struct Article: Codable {
    var id: Int?
    var title: String?
    var body: String?
    var article_image: Thumb?
    var address: String?
    var latitude: Double?
    var longitude: Double?
    var user: User?
}
//ユーザー情報
struct User: Codable {
    var name: String?
    var profile_image: Thumb25
    struct Thumb25: Codable {
        var thumb_25: Url
    }
}
//サムネイル
struct Thumb: Codable {
    var thumb: Url
}

struct Url: Codable {
    var url: String?
}

//マップに立てるピン：緯度経度と、記事情報を持たせる
struct PinItem: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let article: Article
    let pinFlag: Bool = false //ピンがタップされているか→動作未実装
}
