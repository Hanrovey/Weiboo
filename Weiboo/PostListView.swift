//
//  PostListView.swift
//  Weiboo
//
//  Created by chenxihang on 2024/8/13.
//

import SwiftUI
import BBSwiftUIKit

// 微博列表ListView
struct PostListView: View {
    let category: PostListCategory
    
    // 全局环境对象
    @EnvironmentObject var userData: UserData
    
//    init() {
//        // 取消分割线
//        UITableView.appearance().separatorStyle = .none
//        // 取消cell选中效果
//        UITableViewCell.appearance().selectionStyle = .none
//    }
    
    var body: some View {
        BBTableView(userData.postList(for: category).list) { postModel in
            NavigationLink(destination: PostDetailView(postModel: postModel)) {
                PostCell(postModel: postModel)
            }
            .buttonStyle(CustomButtonStyle()) // 消除cell中其它控件颜色被NavigationLink影响
        }
        .bb_setupRefreshControl({ control in
            control.attributedTitle = NSAttributedString(string: "加载中...")
        })
        .bb_reloadData($userData.reloadData) // 刷新整个列表，不需要动画
        .bb_pullDownToRefresh(isRefreshing: $userData.isRefreshing, refresh: {
            print("下啦刷新")
            self.userData.refreshPostList(for: self.category)
        })
        .bb_pullUpToLoadMore(bottomSpace: 30, loadMore: {
            self.userData.loadMorePostList(for: self.category)
        })
        .onAppear(perform: {
            self.userData.loadPostListIsNeeded(for: self.category)
        })
        .overlay(content: { // 错误提示
            Text(userData.loadingErrorText)
                .bold()
                .foregroundColor(.red)
                .frame(width: 200)
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(.white)
                        .opacity(0.8)
                }
                .animation(nil)
                .scaleEffect(userData.showLoaingError ? 1:0.5)
                .animation(.spring(dampingFraction: 0.5))
                .opacity(userData.showLoaingError ? 1 : 0)
                .animation(.easeInOut)
            
        })
        .listStyle(PlainListStyle())
    }
}

#Preview {
    NavigationView(content: {
        PostListView(category: .recommend)
        .navigationBarTitle("标题")
        .navigationBarHidden(false)
    }).environmentObject(UserData.testData)
}
