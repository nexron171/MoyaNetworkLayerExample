//
//  ListTarget.swift
//  MoyaNetworkLayerExample
//
//  Created by Sergey Shirnin on 21/08/2019.
//  Copyright © 2019 devnex. All rights reserved.
//

import Moya

enum ListTarget {
    case all
}

extension ListTarget: TargetType {

    var baseURL: URL { return URL(string: "https://restcountries.eu/rest/v2")! }

    var path: String {
        switch self {
        case .all:
            return "/all"
        }
    }

    var method: Moya.Method {
        return .get
    }

    var task: Task {
        switch self {
        default:
            return .requestPlain
        }
    }

    var validationType: ValidationType {
        switch self {
        case .all:
            return .successCodes
        }
    }

    var headers: [String: String]? {
        return nil
    }

    var sampleData: Data {
        return Data()
    }
}
