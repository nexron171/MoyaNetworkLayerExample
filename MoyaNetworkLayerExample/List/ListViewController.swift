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

    private let refresher = UIRefreshControl()
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
        tableView.refreshControl = refresher
        refresher.addTarget(self, action: #selector(refresh), for: .valueChanged)

        tableView.register(ListTableViewCell.self, forCellReuseIdentifier: "cell")

        viewModel.loadData()

        viewModel.items.bind(to: tableView.rx.items(cellIdentifier: "cell")) { row, model, cell in
            cell.textLabel?.text = model.name
            cell.detailTextLabel?.text = model.population.description
        }.disposed(by: disposeBag)

        viewModel.error.subscribe(onNext: { error in
            let alertVC = UIAlertController(title: nil, message: error, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertVC, animated: true, completion: nil)
        }).disposed(by: disposeBag)
    }

    @objc private func refresh() {
        viewModel.loadData()
        refresher.endRefreshing()
    }
}

