//
//  TabBarView.swift
//  TabilogIOS
//
//  Created by 藤森千裕 on 2021/02/25.
//

import SwiftUI

struct TabBarView: View {
    init() {
        //TabBar非選択時のアイコン色
        UITabBar.appearance().unselectedItemTintColor = .black
        //TabBarの背景色
        UITabBar.appearance().barTintColor = UIColor.orange
    }
    var body: some View {
        
        TabView {
            Text("新着記事一覧") //新着記事
            .tabItem {
                Image(systemName: "house")
                    .font(.title)
            }
            Text("検索画面") //検索画面
                .tabItem {
                    Image(systemName: "magnifyingglass")
                        .font(.title)
                }
            Text("現在地付近記事検索")
                .tabItem {
                    Image(systemName: "map")
                        .font(.title)
                }
            Text("メール画面")
                .tabItem {
                    Image(systemName: "envelope")
                        .font(.title)
                }
        }
        .accentColor(.white)
    }
}


