//
//  SearchArticleView.swift
//  TabilogIOS
//
//  Created by 藤森千裕 on 2021/02/26.
//

import SwiftUI
import CoreLocation
import MapKit

struct SearchArticleView: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
            span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
    )
    @State private var trackingMode: MapUserTrackingMode = .follow
    //ピンを入れる空の配列を作成
    @State private var points = [PinItem]()
    //記事の探索結果を入れる配列
    @State private var surroundingArticles = [Article]()
    //タップされたピンに紐づいた記事を入れる
    @State private var selectedArticle = Article()
    //タップされているかのフラグ
    @State private var flag = false
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct SearchArticleView_Previews: PreviewProvider {
    static var previews: some View {
        SearchArticleView()
    }
}
