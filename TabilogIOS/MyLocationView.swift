//
//  MyLocationView.swift
//  TabilogIOS
//
//  Created by 藤森千裕 on 2021/02/25.
//

import SwiftUI
import CoreLocation
import MapKit
struct myLocationTest: View {
    //マップに立てるピン：緯度経度と、記事情報を持たせる
    struct PinItem: Identifiable {
        let id = UUID()
        let coordinate: CLLocationCoordinate2D
        let article: Article
    }
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
            span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
    )
    //ピンを入れるからの配列を作成
    @State private var points = [PinItem]()
    //現在地周辺の記事の探索結果を入れる配列
    @State private var surroundingArticles = [Article]()
    //タップされたピンの記事
    @State private var selectedArticle = Article()
    let coordinator = Coordinator()
    var body: some View {
        
        //Map表示部分
        VStack {
            NavigationLink(destination: ArticleDetailView(articleDetail: selectedArticle)) {
                HStack() {
                    Spacer()
                        .frame(width: 20)
                    URLImageView(viewModel: .init(url: "\(selectedArticle.article_image?.thumb.url ?? "")"))
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                    Spacer()
                        .frame(width: 50)
                    Text(selectedArticle.title ?? "")
                }
            }
        }
        Map(
            coordinateRegion: $region,
            showsUserLocation: true,
            annotationItems: points,
            annotationContent: { item in
                MapAnnotation(coordinate: item.coordinate){
//                    NavigationLink(destination: ArticleView(articleDetail: item.article)) {
                        HStack() {
                            URLImageView(viewModel: .init(url: "\(item.article.article_image?.thumb.url ?? "")"))
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                        }
                        .onTapGesture{
                            selectedArticle = item.article
                        }
//                    }
                }
            }
        ).onAppear(perform: updateViewMap)
        
    }
    
    func updateViewMap() {
        // 現在地を取得
        coordinator.getLocation()
        //JSONデータを取得するurlを作成
        let searchByCurrentLocation = "https://tabilog.cyou/api/v1/search/by_current_location?latitude=\(coordinator.myLatitude!)&longitude=\(coordinator.myLongitude!)"
        //JSONデータを取得,surroundingArticlesを更新する。
        loadData(request_url: searchByCurrentLocation)
        //ピンを生成する。
        for article in surroundingArticles {
            points.append(PinItem(coordinate: .init(latitude: article.latitude!, longitude: article.longitude!), article: article))
        }
        
        //mapの中心を更新
        region.center = CLLocationCoordinate2D(latitude: coordinator.myLatitude!, longitude: coordinator.myLongitude!)
        
    }
    
    func loadData(request_url: String) {
        guard let url = URL(string: request_url) else {
            return
        }
        // URLリクエストを作成
        let request = URLRequest(url: url)
        // HTTPリクエストを送信？
        URLSession.shared.dataTask(with: request) { data, response, error in
            
             if let data = data {
                print("************Json Data***************")
                print(String(data: data, encoding: String.Encoding.utf8) ?? "")
                let decoder = JSONDecoder()
                guard let decodedResponse: [Article] = try? decoder.decode([Article].self, from: data) else {
//                guard let decodedResponse = try? decoder.decode(Response.self, from: data) else {
                    print("Json decode エラー")
                    return
                }
                // Viewをアップデート
                DispatchQueue.main.async {
                    surroundingArticles = decodedResponse
                    print("***** 現在地周辺データ確認 *****")
                    for article in surroundingArticles {
                        print(article)
                    }
                }
            } else {
                print("Fetch Failed:")
            }
        }.resume()
    }
    //classを定義
    class Coordinator : NSObject, CLLocationManagerDelegate {
        var locationManager: CLLocationManager!
        var myLatitude: Double? = 0.0
        var myLongitude: Double? = 0.0
        
        func getLocation() {
            //初期化
            locationManager = CLLocationManager()
            locationManager.requestWhenInUseAuthorization()
            let status = CLLocationManager.authorizationStatus()
            if status == .authorizedWhenInUse {
                locationManager.delegate = self
                locationManager.distanceFilter = 10
                //情報の取得を開始
                locationManager.startUpdatingLocation()
            }
        }
        func locationManager(_ manager: CLLocationManager,
                        didUpdateLocations locations: [CLLocation]) {
                // 最初のデータ
                let location = locations.first
                print("現在地取得成功！")
                // 緯度
                myLatitude = location?.coordinate.latitude
                // 経度
                myLongitude = location?.coordinate.longitude
         
            print("latitude: \(myLatitude!)")
            print("longitude: \(myLongitude!)")
            }
    }
}

