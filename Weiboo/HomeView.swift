//
//  HomeView.swift
//  Weiboo
//
//  Created by chenxihang on 2024/8/14.
//

import SwiftUI

struct HomeView: View {
    
    @State var leftPercent: CGFloat = 0
    
    init() {
        // 取消分割线
        UITableView.appearance().separatorStyle = .none
        // 取消cell选中效果
        UITableViewCell.appearance().selectionStyle = .none
    }
    
    var body: some View {
        NavigationView(content: {
            
            GeometryReader(content: { geometry in
                // 使用UIKit封装的ScrollView, 将$leftPercent传入scrollView，进行双向绑定
                HScrollViewController(pageWidth: geometry.size.width, contentSize: CGSize(width: geometry.size.width*2, height: geometry.size.height), leftPercent: self.$leftPercent, content: {
                    
                    // 构建2个列表
                    HStack(spacing: 0, content: {
                        PostListView(category: .recommend)
                            .frame(width: UIScreen.main.bounds.width)
                        PostListView(category: .hot)
                            .frame(width: UIScreen.main.bounds.width)
                    })
                    
                })
            })
            .edgesIgnoringSafeArea(.bottom) // 忽略屏幕底部安全区域
            .navigationBarItems(leading: HomeNavigationBar(leftPercent: $leftPercent)) // 将$leftPercent传入HomeNavigationBar，进行双向绑定
            .navigationBarTitle("", displayMode: .inline) // 导航栏小标题样式
        })
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    HomeView().environmentObject(UserData.testData)
}
