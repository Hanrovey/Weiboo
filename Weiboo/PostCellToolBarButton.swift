//
//  PostCellToolBarButton.swift
//  Weiboo
//
//  Created by chenxihang on 2024/8/13.
//

import SwiftUI

// 底部工具栏： 点赞/评论
struct PostCellToolBarButton: View {
    let image: String
    let text: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action, label: {
            HStack(spacing: 5, content: {
                Image(systemName: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 18, height: 18)
                    .foregroundColor(color)
                
                Text(text)
                    .font(.system(size: 15))
                    .foregroundColor(color)
            })
        })
        .buttonStyle(BorderlessButtonStyle())
    }
}

#Preview {
    PostCellToolBarButton(image: "heart", text: "点赞", color: .red, action: {
        print("click toolbar button")
    })
}
