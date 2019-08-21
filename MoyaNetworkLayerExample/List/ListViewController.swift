//
//  ViewController.swift
//  MoyaNetworkLayerExample
//
//  Created by Sergey Shirnin on 21/08/2019.
//  Copyright © 2019 devnex. All rights reserved.
//

import RxSwift
import RxCocoa

class ListViewController: UIViewController {

    var viewModel: ListViewModel!

    private let tableView = UITableView()
    private let disposeBag = DisposeBag()

    override func loadView() {
        self.view = tableView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = ListViewModel()

        title = "Countries"
        navigationController?.navigationBar.prefersLargeTitles = true

        tableView.register(ListTableViewCell.self, forCellReuseIdentifier: "cell")

        viewModel.loadData()
        viewModel.items.bind(to: tableView.rx.items(cellIdentifier: "cell")) { row, model, cell in
            cell.textLabel?.text = model.name
            cell.detailTextLabel?.text = model.population.description
        }.disposed(by: disposeBag)
    }


}

