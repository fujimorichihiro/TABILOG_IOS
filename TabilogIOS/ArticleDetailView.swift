//
//  ArticleDetailView.swift
//  TabilogIOS
//
//  Created by 藤森千裕 on 2021/02/26.
//

import SwiftUI
import MapKit

struct ArticleDetailView: View {
    //タップされた記事を取得する
    let articleDetail: Article
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
            span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        )
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 10)
            HStack {
                Spacer()
                    .frame(width: 10)
                Text(articleDetail.title ?? "")
                    .font(.title)
                    .bold()
                    
                Spacer()
            }
            Rectangle()//下線
                .frame(height: 4)
                .foregroundColor(.gray)
            HStack() {
                Spacer()
                    .frame(width: 10)
                URLImageView(viewModel: .init(url: "\(articleDetail.user?.profile_image.thumb_25.url ?? "")"))
                    .scaledToFill()
                    .frame(width:40, height: 40)
                    .cornerRadius(30)
                Spacer()
                    .frame(width: 10)
                Text(articleDetail.user?.name ?? "")
                    .font(.system(size: 10))
                    .offset(y: -10)
                Spacer()
            }
        }
        HStack {
            Spacer()
                .frame(width: 30)
            HTMLStringView(htmlContent: articleDetail.body ?? "")
        }
        Map(coordinateRegion: $region).onAppear(perform: updateMap)
    }
    //マップに記事の位置情報を表示
    func updateMap() {
        region.center = CLLocationCoordinate2D(latitude: articleDetail.latitude!, longitude: articleDetail.longitude!)
    }
}
