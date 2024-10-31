//
//  CommentInputView.swift
//  Weiboo
//
//  Created by chenxihang on 2024/8/15.
//

import SwiftUI

struct CommentInputView: View {
    let post: PostModel
    
    // 输入框文本内容
    @State private var text: String = ""
    
    // 是否展示空白提示
    @State private var showEmptyHUD: Bool = false
    
    // 系统维护的模态弹出模式
    @Environment(\.presentationMode) var presentationMode
    
    // 全局环境变量数据
    @EnvironmentObject var userData: UserData
    
    @ObservedObject var keyboardResponser = KeyboardResponder()

    var body: some View {
        
        VStack {
            // 输入框
            CommentTextView(text: $text, beginEdittingOnAppear: true)
            
            HStack {
                Button {
                    print("取消")
                    // 关闭模态页面
                    self.presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("取消").padding()
                }
                
                Spacer()

                Button {
                    print("发送")
                    // 移除首位空格和换行符号
                    if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        self.showEmptyHUD = true
                        
                        // 延迟1.5s 后还原
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                            self.showEmptyHUD = false
                        })
                        return
                    }
                    print(self.text)
                    var post = self.post
                    post.commentCount += 1
                    self.userData.update(post)
                    
                    // 关闭模态页面
                    self.presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("发送").padding()
                }
            }
            .font(.system(size: 18))
            .foregroundColor(.black)
        }
        .overlay(content: {
            Text("评论不能为空！")
                .scaleEffect(showEmptyHUD ? 1 : 0.5) // 缩放
                .animation(.spring(dampingFraction: 0.5)) // 动画
                .opacity(showEmptyHUD ? 1 : 0) // 透明度
                .animation(.easeInOut) // 动画
        })
        .padding(.bottom, keyboardResponser.keyboardHeight) // 底部间距
        .edgesIgnoringSafeArea(keyboardResponser.keyboardShow ? .bottom : []) // 是否忽略底部安全区域
    }
}

#Preview {
    CommentInputView(post: UserData().recommendPostList.list[0])
}
