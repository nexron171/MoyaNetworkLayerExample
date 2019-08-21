//
//  DataResponse.swift
//  MoyaNetworkLayerExample
//
//  Created by Sergey Shirnin on 21/08/2019.
//  Copyright © 2019 devnex. All rights reserved.
//

import Foundation

enum DataResponse<U>{
    case success(result: U)
    case message(message: String)
}
