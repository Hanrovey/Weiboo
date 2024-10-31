//
//  NetworkAPI.swift
//  Weiboo
//
//  Created by chenxihang on 2024/8/17.
//

import Foundation
import Alamofire

class NetworkAPI {
    
    // 推荐列表
    static func recommendPostList(completion: @escaping (Result<PostListModel, Error>) -> Void) {
        NetworkManager.shared.requestGet(path: "PostListData_recommend_1.json", parameters: nil) { result in
            switch result {
            case let .success(data):
                let parseResult: Result<PostListModel, Error> = self.parseData(data)
                completion(parseResult)
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    // 热门列表
    static func hotPostList(completion: @escaping (Result<PostListModel, Error>) -> Void) {
        NetworkManager.shared.requestGet(path: "PostListData_hot_1.json", parameters: nil) { result in
            switch result {
            case let .success(data):
                let parseResult: Result<PostListModel, Error> = self.parseData(data)
                completion(parseResult)
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    // 发送微博
    static func createPost(text: String, completion: @escaping (Result<PostModel, Error>) -> Void) {
        NetworkManager.shared.requestPost(path: "createpost", parameters: ["text": text]) { result in
            switch result {
            case let .success(data):
                let parseResult: Result<PostModel, Error> = self.parseData(data)
                completion(parseResult)
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    // 解析数据
    private static func parseData<T: Decodable>(_ data: Data) -> Result<T, Error> {
        guard let decodedData = try? JSONDecoder().decode(T.self, from: data) else {
            let error = NSError(domain: "NetworkAPIError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Can not parse data"])
            return .failure(error)
        }
        return .success(decodedData)
    }
}
