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
        center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
            span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
    )
    //現在地周辺の記事の探索結果を入れる配列
    @State private var surroundingArticles = [Article]()
    let coordinator = Coordinator()
    
    var body: some View {
        Map(coordinateRegion: $region).onAppear(perform: updateView)
    }
    
    func updateView() {
        
        coordinator.getLocation()
        region.center = CLLocationCoordinate2D(latitude: coordinator.myLatitude!, longitude: coordinator.myLongitude!)
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

struct MyLocationView_Previews: PreviewProvider {
    static var previews: some View {
        MyLocationView()
    }
}
