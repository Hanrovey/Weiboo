//
//  PostModel.swift
//  Weiboo
//
//  Created by chenxihang on 2024/8/13.
//

import SwiftUI
import SDWebImageSwiftUI

// 微博列表Model
struct PostListModel: Codable {
    var list: [PostModel]
}

// 微博cell - 数据model
struct PostModel: Codable, Identifiable {
    let id: Int // id
    let avatar: String // 头像
    let name: String // 昵称
    let vip: Bool // 是否vip
    let date: String // 发布日期
    var isFollowed: Bool // 是否关注
    
    let text: String // 正文
    let images: [String] // 图片集合
    
    var commentCount: Int // 评论数
    var likeCount: Int // 点赞数
    var isLiked: Bool // 是否点赞
}

extension PostModel: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}

extension PostModel {
    
    // 头像
    var avatarImage: WebImage {
        return loadImage(name: avatar)
    }
    
    // 评论文本
    var commentCoutText: String {
        if commentCount <= 0 {
            return "评论"
        }
        if commentCount <= 1000 {
            return "\(commentCount)"
        }
        return String(format: "%.1f", Double(commentCount) / 1000)
    }
    
    // 点赞文本
    var likeCoutText: String {
        if likeCount <= 0 {
            return "点赞"
        }
        if likeCount <= 1000 {
            return "\(likeCount)"
        }
        return String(format: "%.1f", Double(likeCount) / 1000)
    }
    
}


let postListModel = loadPostListData("PostListData_recommend_1.json")

// 加载列表数据
func loadPostListData(_ fileName: String) -> PostListModel {
    guard let url = Bundle.main.url(forResource: fileName, withExtension: nil) else {
        fatalError("can not load \(fileName) url in main bundle")
    }

    guard let data = try? Data(contentsOf: url) else {
        fatalError("can not data")
    }
                   
    guard let list = try? JSONDecoder().decode(PostListModel.self, from: data) else {
        fatalError("can not parse post list data")
    }
    return list
}


// 创建图片
func loadImage(name: String) -> WebImage {
    return WebImage(url: URL(string: kNetworkAPIBaseURL + name))
        .placeholder {
            Color.gray
        }
}
