//
//  MyLocationView.swift
//  TabilogIOS
//
//  Created by 藤森千裕 on 2021/02/25.
//

import SwiftUI
import CoreLocation
import MapKit

struct MyLocationView: View {
    
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 35.7719, longitude: 139.873),
            span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
    )
    //ピンを入れる空の配列を作成
    @State private var points = [PinItem]()
    //現在地周辺の記事の探索結果を入れる配列
    @State private var surroundingArticles = [Article]()
    //タップされたピンに紐づいた記事を入れる
    @State private var selectedArticle = Article()
    //タップされているかのフラグ
    @State private var flag = false
    let coordinator = Coordinator()
    var body: some View {
        
        //Map表示部分
        ZStack {
            Map(
                coordinateRegion: $region,
                showsUserLocation: true,
                annotationItems: points, //ピンの配列を渡す
                annotationContent: { item in //ピンの形などを指定する
                    MapAnnotation(coordinate: item.coordinate){
                        Image(systemName: "mappin.circle.fill")
                            .foregroundColor(.red)
                            .font(.title)
                            .onTapGesture{ //ピンをタップして時の動作
                                selectedArticle = item.article
                                self.flag = false
                                withAnimation() { self.flag.toggle() }
                            }
                    }
                }
            ).onAppear(perform: updateViewMap) //下に記述、位置情報などを取得更新する。
            VStack() {
                Spacer()
                if flag {
                    NavigationLink(destination: ArticleDetailView(articleDetail: selectedArticle)) {
                        HStack() {
                            URLImageView(viewModel: .init(url: "\(selectedArticle.article_image?.thumb.url ?? "")"))
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                            Spacer()
                                .frame(width: 30)
                            Text(selectedArticle.title ?? "")
                                .foregroundColor(.black) //文字色
                            Spacer()
                                .frame(width: 30)
                        }
                        .background(Color.white) //背景色
                        .cornerRadius(16) //角丸
                        .shadow(color: .gray, radius: 10, y: 10) //影
                        
                    }.transition(.slide)
                    
                }
                Spacer()
                    .frame(height: 20)
            }
        }
    }
    
    func updateViewMap() {//上から順に処理されるわけではないっぽい？
        // 現在地を取得
        coordinator.getLocation()
        //JSONデータを取得,surroundingArticlesを更新する。
        loadData(request_url: "https://tabilog.cyou/api/v1/search/by_current_location?latitude=\(coordinator.myLatitude!)&longitude=\(coordinator.myLongitude!)")
        
        DispatchQueue.main.async {
            //mapの中心を更新
            region.center = CLLocationCoordinate2D(latitude: coordinator.myLatitude!, longitude: coordinator.myLongitude!)
            
        }
        
    }

    
    //記事情報を取得する関数
    func loadData(request_url: String) {
        guard let url = URL(string: request_url) else {
            return
        }
        // URLリクエストを作成
        let request = URLRequest(url: url)
        // HTTPリクエストを送信？
        URLSession.shared.dataTask(with: request) { data, response, error in
            
             if let data = data {
                let decoder = JSONDecoder()
                guard let decodedResponse: [Article] = try? decoder.decode([Article].self, from: data) else {
                    print("Json decode エラー")
                    return
                }
                // Viewをアップデート
                DispatchQueue.main.async {
                    print("Decode完了")
                    //ピンを生成する。
                    for article in surroundingArticles {
                        points.append(PinItem(coordinate: .init(latitude: article.latitude!, longitude: article.longitude!), article: article))
                    }
                    surroundingArticles = decodedResponse
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
            let status = CLLocationManager.authorizationStatus() //IOS 14で非推奨なので変えたい****************
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

