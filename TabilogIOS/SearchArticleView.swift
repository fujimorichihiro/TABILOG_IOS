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
        center: CLLocationCoordinate2D(latitude: 35.7719, longitude: 139.873),
            span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
    )
    //ピンを入れる空の配列を作成
    @State private var points = [PinItem]()
    //記事の探索結果を入れる配列
    @State private var searchedArticles = [Article]()
    //タップされたピンに紐づいた記事を入れる
    @State private var selectedArticle = Article()
    //タップされているかのフラグ
    @State private var flag = false
    @State private var search = ""     //検索ワード
    @State private var editting = false   //入力ステータス
    var body: some View {
        ZStack() {
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
            )
            //検索フォーム
            VStack {
                TextField("場所や住所で記事を検索（「東京タワー」など）", text: $search,
                    onEditingChanged: { begin in
                        if begin {
                            self.editting = true
                        } else {
                            self.editting = false
                        }
                    },
                    onCommit: {
                        // searchが空でない時のみ実行するように変える*******
                        // 検索文字列をパーセントエンコーディング
                        let encodedText = search.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                        self.flag = false
                        // データ取得を実行
                        loadData(request_url: "https://tabilog.cyou/api/v1/search/by_location?search=\(encodedText ?? "")")
                    })
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .shadow(color: editting ? .blue : .black, radius: 3)
                Spacer()
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
                let decoder = JSONDecoder()
                guard let decodedResponse: [Article] = try? decoder.decode([Article].self, from: data) else {
                    print("Json decode エラー")
                    return
                }
                // Viewをアップデート
                DispatchQueue.main.async {
                    searchedArticles = decodedResponse
                    //ピンを生成
                    for article in searchedArticles {
                        points.append(PinItem(coordinate: .init(latitude: article.latitude!, longitude: article.longitude!), article: article))
                    }
                    let art = searchedArticles.first
                    region.center = CLLocationCoordinate2D(latitude: art?.latitude ?? 0.0 , longitude: art?.longitude ?? 0.0)
                }
            } else {
                print("Fetch Failed:")
            }
        }.resume()
    }
}
