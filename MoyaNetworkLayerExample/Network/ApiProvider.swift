//
//  ApiProvider.swift
//  MoyaNetworkLayerExample
//
//  Created by Sergey Shirnin on 21/08/2019.
//  Copyright © 2019 devnex. All rights reserved.
//

import Moya
import RxSwift

public class ApiProvider<T: TargetType> {

    public let provider: MoyaProvider<T>

    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()

    public init() {
        self.provider = MoyaProvider<T>(plugins: [
            NetworkLoggerPlugin(verbose: true, responseDataFormatter: ApiProvider.JSONResponseDataFormatter)
            ])
    }

    private static func JSONResponseDataFormatter(_ data: Data) -> Data {
        do {
            let dataAsJSON = try JSONSerialization.jsonObject(with: data)
            let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
            return prettyData
        } catch {
            return data // fallback to original data if it can't be serialized.
        }
    }

    func responseData<DataType: Codable>(_ targetType: T, dataType: DataType.Type) -> Observable<DataResponse<DataType>> {
        return provider.rx.request(targetType)
            .map(DataType.self, using: decoder)
            .map { responseObject -> DataResponse<DataType> in
                return DataResponse.success(result: responseObject)
            }
            .asObservable()
            .catchError({ [weak self] error -> Observable<DataResponse<DataType>> in
                self?.printDebugInfo(for: error)
                return BehaviorSubject<DataResponse<DataType>>(value: DataResponse<DataType>.message(message: error.localizedDescription)).asObservable()
            })
    }

    private func printDebugInfo(for error: Error) {
        print(error.localizedDescription)
        if let error = error as? Moya.MoyaError {
            switch error {
            case .objectMapping(let error, let response):
                print(response)
                if let error = error as? DecodingError {
                    switch error {
                    case .keyNotFound(let key, let context):
                        print(error.localizedDescription)
                        print(key, context)
                    case .typeMismatch(let type, let context):
                        print(error.localizedDescription)
                        print(type, context)
                    default:
                        break
                    }
                }
            default:
                break
            }
        }
    }
}
