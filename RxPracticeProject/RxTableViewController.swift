//
//  RxTableViewController.swift
//  RxPracticeProject
//
//  Created by 권현석 on 2023/10/31.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class RxTableViewController: UIViewController {
    
    let tableView = UITableView()
    
    let disposeBag = DisposeBag()
    
    var item: [String] {
        return (0..<20).map { "\($0)" }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setConstratints() 
       
        
        Observable.just(item)
            .bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { row, element, cell in
                cell.textLabel?.text = "\(element) @ row \(row)"
            }
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(String.self)
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, value in
                owner.presentAlert(message: "Tapped '\(value)'")
            })
            .disposed(by: disposeBag)
        
        
        tableView.rx
            .itemAccessoryButtonTapped
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, indexPath in
                owner.presentAlert(message: "Tapped Detail @ \(indexPath.section),\(indexPath.row)")
            }
            .disposed(by: disposeBag)
    }
    
    
}


extension RxTableViewController: DefaultSettingProtocol {
    func configure() {
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    func setConstratints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    
    
}
