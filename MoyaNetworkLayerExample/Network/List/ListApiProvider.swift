//
//  ListApiProvider.swift
//  MoyaNetworkLayerExample
//
//  Created by Sergey Shirnin on 21/08/2019.
//  Copyright © 2019 devnex. All rights reserved.
//

import RxSwift

class ListApiProvider: ApiProvider<ListTarget> {

    func getCountries(search: String?) -> Observable<DataResponse<[Country]>> {
        return responseData(.all, dataType: [Country].self)
    }
}
