//
//  ContentView.swift
//  TabilogIOS
//
//  Created by 藤森千裕 on 2021/02/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            TabBarView()
                .navigationBarTitle(Text("TABILOG"), displayMode: .inline)
                .navigationBarItems(
                leading: Image("marker1")
                    .resizable()
                    .overlay(
                        Circle().stroke(Color.gray, lineWidth: 1)
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
