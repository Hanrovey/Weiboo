//
//  UserData.swift
//  Weiboo
//
//  Created by chenxihang on 2024/8/14.
//

import Combine
import Foundation

// 用户数据，采用环境变量
class UserData: ObservableObject {
    // 定义全局环境变量
    @Published var recommendPostList: PostListModel = PostListModel(list: [])
    @Published var hotPostList: PostListModel = PostListModel(list: [])
    @Published var isRefreshing: Bool = false
    @Published var isLodingMore: Bool = false
    @Published var loadingError: Error?
    @Published var reloadData: Bool = false
    
    private var recommendPostDict: [Int: Int] = [:] // [id: index] 微博id: 数组中索引
    private var hotPostDict: [Int: Int] = [:] // [id: index]
    
}

// 微博列表数据类型
enum PostListCategory {
    case recommend // 推荐
    case hot       // 热门
}

// 扩展常用方法
extension UserData {
    
    // 测试数据
    static let testData: UserData = {
      let data = UserData()
        data.handleRefreshPostList(loadPostListData("PostListData_recommend_1.json"), for: .recommend)
        data.handleRefreshPostList(loadPostListData("PostListData_hot_1.json"), for: .hot)
        return data
    }()
    
    // 是否展示错误
    var showLoaingError: Bool {
        return loadingError != nil
    }
    
    // 错误文案
    var loadingErrorText: String {
        return loadingError?.localizedDescription ?? "加载错误"
    }
    
    // 根据类型返回对应列表数据
    func postList(for category: PostListCategory) -> PostListModel {
        switch category {
        case .recommend:
            return recommendPostList
        case .hot:
            return hotPostList
        }
    }
    
    // 首次进入刷新
    func loadPostListIsNeeded(for category: PostListCategory) {
        if self.postList(for: category).list.isEmpty {
            self.refreshPostList(for: category)
            self.reloadData = true
        }
    }
    
    // 下拉刷新
    func refreshPostList(for category: PostListCategory) {
        
        let completion:(Result<PostListModel, Error>) -> Void = { result in
            switch result {
            case let .success(list):
                self.handleRefreshPostList(list, for: category)
            case let .failure(error):
                self.handleLoadingError(error)
            }
            self.isRefreshing = false
        }
        
        switch category {
        case .recommend:
            NetworkAPI.recommendPostList(completion: completion)
        case .hot:
            NetworkAPI.hotPostList(completion: completion)
        }
    }
    
    // 加载更多
    func loadMorePostList(for category: PostListCategory) {
        if isLodingMore || postList(for: category).list.count > 10 {
            return
        }
        isLodingMore = true
        
        let completion:(Result<PostListModel, Error>) -> Void = { result in
            switch result {
            case let .success(list):
                self.handleLoadMorePostList(list, for: category)
            case let .failure(error):
                self.handleLoadingError(error)
            }
            self.isLodingMore = false
        }
        
        switch category {
        case .recommend:
            NetworkAPI.hotPostList(completion: completion)
        case .hot:
            NetworkAPI.recommendPostList(completion: completion)
        }
    }
    
    // 处理下拉数据
    private func handleRefreshPostList(_ list: PostListModel, for category: PostListCategory) {
        var tempList: [PostModel] = []
        var tempDic: [Int: Int] = [:]
        for (index, post) in list.list.enumerated() {
            if tempDic[post.id] != nil { continue }
            tempList.append(post)
            tempDic[post.id] = index
            update(post)
        }
        switch category {
        case .recommend:
            recommendPostList.list = tempList
            recommendPostDict = tempDic
        case .hot:
            hotPostList.list = tempList
            hotPostDict = tempDic
        }
        reloadData = true
    }
    
    // 处理错误
    private func handleLoadingError(_ error: Error) {
        loadingError = error
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.loadingError = nil
        }
    }
    
    // 处理加载更多
    private func handleLoadMorePostList(_ list: PostListModel, for category: PostListCategory) {
        switch category {
        case .recommend:
            for post in list.list {
                update(post)
                if recommendPostDict[post.id] != nil { continue }
                recommendPostList.list.append(post)
                recommendPostDict[post.id] = recommendPostList.list.count - 1
            }
        case .hot:
            for post in list.list {
                update(post)
                if hotPostDict[post.id] != nil { continue }
                hotPostList.list.append(post)
                hotPostDict[post.id] = hotPostList.list.count - 1
            }
        }
    }
    
    /// 根据id返回一个微博postModel
    /// - Parameter id: id
    /// - Returns: 微博postModel
    func post(forId id: Int) -> PostModel? {
        if let index = recommendPostDict[id] {
            return recommendPostList.list[index]
        }
        if let index = hotPostDict[id] {
            return hotPostList.list[index]
        }
        return nil
    }
    
    
    /// 更新微博列表
    /// - Parameter post: 微博postModel
    func update(_ post: PostModel) {
        if let index = recommendPostDict[post.id] {
            recommendPostList.list[index] = post
        }
        if let index = hotPostDict[post.id] {
            hotPostList.list[index] = post
        }
    }
}
