//
//  NetworkManager.swift
//  Weiboo
//
//  Created by chenxihang on 2024/8/17.
//  二次封装alamofire

import Foundation
import Alamofire

typealias NetworkRequestResult = Result<Data, Error>
typealias NetworkRequestCompletion = (NetworkRequestResult) -> Void
let kNetworkAPIBaseURL = "https://gitee.com/hanrovey/Weiboo/raw/main/Weiboo/Resources/"

class NetworkManager {
    // 单例
    static let shared = NetworkManager()
    
    var commonHeader: HTTPHeaders {
        ["token": "xxxx"]
    }
    
    private init() {}
    
    // get请求
    @discardableResult
    func requestGet(path: String, parameters: Parameters?, completion:  @escaping NetworkRequestCompletion) -> DataRequest {
        AF.request(kNetworkAPIBaseURL + path,
                   parameters: parameters,
                   headers: commonHeader,
                   requestModifier: { $0.timeoutInterval = 15 }
        ).response { response in
            switch response.result {
            case let .success(data): completion(.success(data!))
            case let .failure(error): completion(self.handleError(error))
            }
        }
    }
    
    // post请求
    @discardableResult
    func requestPost(path: String, parameters: Parameters?, completion:  @escaping NetworkRequestCompletion) -> DataRequest {
        AF.request(kNetworkAPIBaseURL + path,
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding.prettyPrinted,
                   headers: commonHeader,
                   requestModifier: { $0.timeoutInterval = 15 }
        ).response { response in
            switch response.result {
            case let .success(data): completion(.success(data!))
            case let .failure(error): completion(self.handleError(error))
            }
        }
    }
    
    private func handleError(_ error: AFError) -> NetworkRequestResult {
        if let underlyingError = error.underlyingError {
            let nserror = underlyingError as NSError
            let code = nserror.code
            if  code == NSURLErrorNotConnectedToInternet ||
                code == NSURLErrorTimedOut ||
                code == NSURLErrorInternationalRoamingOff ||
                code == NSURLErrorDataNotAllowed ||
                code == NSURLErrorCannotFindHost ||
                code == NSURLErrorCannotConnectToHost ||
                code == NSURLErrorNetworkConnectionLost {
                var userInfo = nserror.userInfo
                userInfo[NSLocalizedDescriptionKey] = "网络连接有问题喔～"
                let currentError = NSError(domain: nserror.domain, code: code, userInfo: userInfo)
                return .failure(currentError)
            }
        }
        return .failure(error)
    }
    
}
