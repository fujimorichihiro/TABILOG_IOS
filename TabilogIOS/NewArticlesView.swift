//
//  NewArticlesView.swift
//  TabilogIOS
//
//  Created by 藤森千裕 on 2021/02/26.
//

import SwiftUI

struct NewArticlesView: View {
    @State private var newArticles = [Article]()
    var body: some View {
        VStack() {
            Text("New Articles")
                .padding()
                .foregroundColor(.gray)
            List(newArticles, id: \.id) { article in
                NavigationLink(destination: ArticleDetailView(articleDetail: article)) {
                    VStack() {
                        HStack() { //ユーザー情報部分
                            URLImageView(viewModel: .init(url: "\(article.user?.profile_image.thumb_25.url ?? "")"))
                                .scaledToFill()
                                .frame(width:50, height: 50)
                                .clipShape(Circle())
                            Spacer()
                                .frame(width: 20)
                            Text(article.user?.name ?? "")
                                .foregroundColor(.gray)
                                .offset(y: -10)
                            Spacer()
                       }
                        
                        HStack() { //記事タイトル
                            Spacer()
                                .frame(width: 60)
                            Text(article.title ?? "")
                            Spacer()
                        }
                        Spacer()
                            .frame(width: 20)
                        URLImageView(viewModel: .init(url: "\(article.article_image?.thumb.url ?? "")")) //記事サムネイル部分
                            .scaledToFill()
                            .frame(width: 250, height: 200)
                            .cornerRadius(16)
                    }
                }
            }
        }.onAppear(perform: loadNewArticles)
    }
    // データ取得の処理
    func loadNewArticles() {
        guard let url = URL(string: "https://tabilog.cyou/api/v1/articles") else {
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
                    newArticles = decodedResponse
                }
            } else {
                print("Fetch Failed:")
            }
        }.resume()
    }
}
