## [TABILOG概要 ]
旅行の記録を投稿するSNSです。
記事には位置情報を紐づけられるので、旅行の計画を練る時、旅行をしたいけど場所が決まらないとき、地図上から記事を探して読むことができます。</br>
「旅行先で、時間が空いてしまったけどどうしよう、、、、」という時も現在地から周辺の記事を取得して参考にすることができるでしょう。</br>
[TABILOG　ソースコード](https://github.com/fujimorichihiro/TABILOG)

### ①新着記事表示画面
新着記事をサーバーから取得、表示します。


![swiftgif1](https://user-images.githubusercontent.com/62407835/109243776-de5f3480-7820-11eb-9f11-d00626817583.gif)




### ②場所、住所から周辺の記事を検索するページ
ピンをタップすることで画面下部分に記事が現れます。記事をタップすると記事詳細に飛ぶことができます。



![swiftgif2](https://user-images.githubusercontent.com/62407835/109244261-bde3aa00-7821-11eb-9ff1-c6a2f0ef560e.gif)


### ③現在地周辺記事検索ページ
端末から現在地を取得、サーバーに送信することで今いる場所の周辺の記事が取得できます。
こちらは、クロージャや非同期な処理の理解が足りなかったので2回ほど読み込み直さないと記事が表示されない状況です。。。


![swiftgif3](https://user-images.githubusercontent.com/62407835/109245990-c8ec0980-7824-11eb-9eeb-cb5926d29cd4.gif)



### 開発環境
Mac Book Pro</br>
macOS Catalina 10.15.7</br>
Xcode 12.4</br>
Swift 5.3.2</br>
SwiftUI</br>
##### 実機でのテストはiphoneXR IOS 14.4を使用しました。
