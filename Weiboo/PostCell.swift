//
//  PostCell.swift
//  Weiboo
//
//  Created by chenxihang on 2024/8/13.
//

import SwiftUI

struct PostCell: View {
    
    // 数据model
    let postModel: PostModel
    
    var bindingPostModel: PostModel {
        userData.post(forId: postModel.id)!
    }
    
    // 是否模态弹出
    @State var isPresented: Bool = false
    
    // 全局环境变量
    @EnvironmentObject var userData: UserData
    
    var body: some View {
        var postModel = bindingPostModel
        return VStack(alignment: .leading, spacing: 10, content: {
            
            HStack(spacing: 5, content: {
                
           // 头像
           postModel.avatarImage
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                    .overlay (
                        PostVipBadge(vip: postModel.vip)
                            .offset(x: 16, y: 16)
                )
                
                // 昵称
                VStack(alignment: .leading, spacing: 5, content: {
                    Text(postModel.name)
                        .font(Font.system(size: 16))
                        .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                        .lineLimit(1)
                    Text(postModel.date)
                        .font(.system(size: 20))
                        .foregroundColor(.yellow)
                })
                .padding(.leading, 10)
                
                if !postModel.isFollowed { // 是否关注
                    // 占位
                    Spacer()
                    
                    // 关注按钮
                    Button(action: {
                        postModel.isFollowed = true
                        self.userData.update(postModel)
                    }, label: {
                        Text("关注")
                            .font(.system(size: 14))
                            .foregroundColor(.orange)
                            .frame(width: 50, height: 26)
                            .overlay {
                                RoundedRectangle(cornerRadius: 13)
                                    .stroke(.red, lineWidth: 3)
                            }
                    }).buttonStyle(BorderlessButtonStyle()) // 控制按钮点击范围
                }
            
            })
            
            // 正文
            Text(postModel.text)
                .font(.system(size: 17))
            
            // 图片
            if !postModel.images.isEmpty {
                PostImageCell(images: postModel.images, width: CGFloat(UIScreen.main.bounds.width - 30))
            }

            // 分割线
            Divider()
            
            // 底部工具栏
            HStack(content: {
                Spacer()
                
                PostCellToolBarButton(image: "message", text: postModel.commentCoutText, color: .black, action: {
                    print("comment click")
                    // 改变状态
                    self.isPresented = true
                })
                .sheet(isPresented: $isPresented) {
                    // 模态弹出，需要将environmentObject 传入下个页面，保证数据双向绑定
                    CommentInputView(post: self.postModel).environmentObject(self.userData)
                }
                
                Spacer()
                
                PostCellToolBarButton(image: postModel.isLiked ? "heart.fill" : "heart", text: postModel.likeCoutText, color: postModel.isLiked ? .red : .black, action: {
                    print("like click")
                    if postModel.isLiked {
                        postModel.isLiked = false
                        postModel.likeCount -= 1
                    } else {
                        postModel.isLiked = true
                        postModel.likeCount += 1
                    }
                    self.userData.update(postModel)
                })
                
                Spacer()
            })
            
            Rectangle()
                .padding(.horizontal, -15)
                .frame(height: 10)
                .foregroundColor(Color(red: 235/255, green: 235/255, blue: 235/255))
        })
        .padding(.horizontal, 15)
        .padding(.top, 15)
    }
}

#Preview {
    let userData = UserData.testData
    return PostCell(postModel: userData.recommendPostList.list[0]).environmentObject(userData)
}

