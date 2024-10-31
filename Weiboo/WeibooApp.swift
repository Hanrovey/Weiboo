//
//  WeibooApp.swift
//  Weiboo
//
//  Created by chenxihang on 2024/8/13.
//

import SwiftUI

@main
struct WeibooApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView().environmentObject(UserData())
//            NavigationView(content: {
////                PostListView(category: .recommend)
//                HomeView()
////                .navigationBarTitle("标题")
////                .navigationBarHidden(false)
//                .navigationBarTitle("首页", displayMode: .inline)
//            })
//            .navigationViewStyle(StackNavigationViewStyle())
//            PostListView()
//            PostCell(postModel: postListModel.list[0])
        }
    }
}
