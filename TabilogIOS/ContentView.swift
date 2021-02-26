//
//  ContentView.swift
//  TabilogIOS
//
//  Created by 藤森千裕 on 2021/02/25.
//

import SwiftUI

struct ContentView: View {
    init() {
        UINavigationBar.appearance().barTintColor = UIColor(red: 240/255, green: 172/255, blue: 14/255, alpha: 1)
    }
    var body: some View {
        NavigationView {
            TabBarView()
                .navigationBarTitle(Text(""), displayMode: .inline)
                .navigationBarItems(
                leading: Image("marker1")
                    .resizable()
                    .overlay(
                        Circle().stroke(Color.white, lineWidth: 2)
                    )
                    .frame(width: 30, height: 30)
                    .clipShape(Circle())
                )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
