//
//  URLImageView.swift
//  TabilogIOS
//
//  Created by 藤森千裕 on 2021/02/26.
//


import SwiftUI
class URLImageViewModel: ObservableObject {
    //ここにデータが格納されるとviewが切り替わる
    @Published var downloadData: Data? = nil
    let url: String
    
    init(url: String, isSync: Bool = false) {
        self.url = url
        if isSync {
            self.downloadImageSync(url: self.url)
        } else {
            self.downloadImageAsync(url: self.url)
        }
    }
    
    func downloadImageAsync(url: String) {
        
        guard let imageURL = URL(string: url) else {
            return
        }
                
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: imageURL)
            DispatchQueue.main.async {
                self.downloadData = data
            }
        }
    }
    
    func downloadImageSync(url: String) {
        
        guard let imageURL = URL(string: url) else {
            return
        }
        
        let data = try? Data(contentsOf: imageURL)
        self.downloadData = data
    }
}

// View
struct URLImageView: View {
    @ObservedObject var viewModel: URLImageViewModel
            
    var body: some View {
            if let imageData = self.viewModel.downloadData {
            if let image = UIImage(data: imageData) {
                        return Image(uiImage: image).resizable()
            } else {
                        return Image(uiImage: UIImage()).resizable()
        }
    } else {
        return Image(uiImage: UIImage()).resizable()
        }
    }
}

