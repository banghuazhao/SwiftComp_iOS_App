//
//  HomResultAPI.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 12/1/19.
//  Copyright © 2019 Banghua Zhao. All rights reserved.
//

import Moya

enum HomResultAPI {
    case meshImage(homInformation: HomInformation)
    case delete(homInformation: HomInformation )

}

extension HomResultAPI: TargetType {
    var baseURL: URL {
        return URL(string: "http://128.46.6.100:8888")!
    }
    
    var path: String {
        switch self {
        case .meshImage(let homInformation):
            return "/\(homInformation.route)/meshImage"
        case .delete(let homInformation):
            return "/\(homInformation.route)/delete"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .meshImage, .delete:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .meshImage(let homInformation):
            return .requestParameters(parameters: ["userDirectory": homInformation.swiftcompCwd], encoding: URLEncoding.queryString)
        case .delete(let homInformation):
            return .requestParameters(parameters: ["userDirectory": homInformation.swiftcompCwd], encoding: URLEncoding.queryString)

        }
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
    
    
}
