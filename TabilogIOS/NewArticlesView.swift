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
        List(newArticles, id: \.id) { article in
            NavigationLink(destination: ArticleDetailView(articleDetail: article)) {
                HStack() {
                    Spacer()
                        .frame(width: 20)
                    URLImageView(viewModel: .init(url: "\(article.article_image?.thumb.url ?? "")"))
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                    Spacer()
                        .frame(width: 50)
                    Text(article.title ?? "")
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
                    newArticles = decodedResponse
                    print("***** 最終データ確認 *****")
                    for article in newArticles {
                        print(article)
                    }
                }
            } else {
                print("Fetch Failed:")
            }
        }.resume()
    }
}
