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
        UITabBar.appearance().unselectedItemTintColor = .white
        //TabBarの背景色
        UITabBar.appearance().barTintColor = UIColor(red: 240/255, green: 172/255, blue: 14/255, alpha: 1)
    }
    var body: some View {
        
        TabView {
            NewArticlesView() //新着記事
              .tabItem {
                Image(systemName: "house")
                    .font(.title)
            }
            SearchArticleView() //検索画面
                .tabItem {
                    Image(systemName: "magnifyingglass")
                        .font(.title)
                }
            MyLocationView()
                .tabItem {
                    Image(systemName: "map")
                        .font(.title)
                }
        }
        .accentColor(Color(red: 212/255, green: 220/255, blue: 211/255))
    }
}


