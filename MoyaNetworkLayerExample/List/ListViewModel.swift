//
//  ListViewModel.swift
//  MoyaNetworkLayerExample
//
//  Created by Sergey Shirnin on 21/08/2019.
//  Copyright © 2019 devnex. All rights reserved.
//

import RxSwift

class ListViewModel {

    let items: BehaviorSubject<[Country]> = BehaviorSubject<[Country]>(value: [])
    let error: PublishSubject<String> = PublishSubject<String>()

    private let provider: ListApiProvider
    private let disposeBag: DisposeBag

    init() {
        provider = ListApiProvider()
        disposeBag = DisposeBag()
    }

    func loadData() {
        provider.getCountries(search: nil).subscribe(onNext: { response in
            switch response {
            case .success(let result):
                self.items.onNext(result)
            case .message(let message):
                self.error.onNext(message)
            }
        }, onError: { error in
            self.error.onNext(error.localizedDescription)
        }).disposed(by: disposeBag)
    }
}
