//
//  ArticleDetailView.swift
//  TabilogIOS
//
//  Created by 藤森千裕 on 2021/02/26.
//

import SwiftUI
import MapKit

struct ArticleDetailView: View {
    //タップされた記事idを取得
    let articleDetail: Article
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
            span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        )
    var body: some View {
        VStack {
            HStack {
                Spacer()
                    .frame(width: 10)
                Text(articleDetail.title ?? "")
                    .font(.title2)
                Spacer()
            }
            Divider()
        }
        HStack {
            Spacer()
                .frame(width: 10)
            HTMLStringView(htmlContent: articleDetail.body ?? "")
        }
        Map(coordinateRegion: $region).onAppear(perform: updateMap)
    }
    func updateMap() {
        region.center = CLLocationCoordinate2D(latitude: articleDetail.latitude!, longitude: articleDetail.longitude!)
    }
}
