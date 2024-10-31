//
//  PostDetailView.swift
//  Weiboo
//
//  Created by chenxihang on 2024/8/14.
//

import SwiftUI

// 详情页面
struct PostDetailView: View {
    let postModel: PostModel
    
    var body: some View {
        List {
            PostCell(postModel: postModel)
                .listRowInsets(/*@START_MENU_TOKEN@*/EdgeInsets()/*@END_MENU_TOKEN@*/)
            
            ForEach(0...10, id: \.self) { index in
                Text("\(index)")
            }
        }
        .listStyle(PlainListStyle())
        .navigationBarTitle("详情", displayMode: .inline)
    }
}

#Preview {
    PostDetailView(postModel: postListModel.list[0])
}
