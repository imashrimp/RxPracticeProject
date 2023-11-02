//
//  ViewController.swift
//  RxPracticeProject
//
//  Created by 권현석 on 2023/10/31.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    let pickerView1 = UIPickerView()
    let pickerView2 = UIPickerView()
    let pickerView3 = UIPickerView()
    let sesacPickerView = UIPickerView()
    
    let disposeBag = DisposeBag()
    
    let item = [1, 2, 3]
    let sesacItem = ["영화", "드라마", "애니메이션", "다큐멘터리"]

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setConstraints()
        
        Observable.just(item) // observable을 만들기
            .bind(to: pickerView1.rx.itemTitles) { _, item in
                return "\(item)"
            }
            .disposed(by: disposeBag)
        
        pickerView1.rx.modelSelected(Int.self)
            .subscribe { data in
                print(data) // 타입이 Event<>로 제네릭을 사용하고 있음. 그러면 제네릭에 뭐가 들어오느
                print(type(of: data))
            }
            .disposed(by: disposeBag)
        
        Observable.just(item)
            .bind(to: pickerView2.rx.itemAttributedTitles) { row, element in
                return NSAttributedString(string: "\(element)",
                                          attributes: [
                                            NSAttributedString.Key.foregroundColor: UIColor.systemGreen,
                                            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.double.rawValue
                                          ])
                
            }
            .disposed(by: disposeBag)
        
        pickerView2.rx.modelSelected(Int.self)
            .subscribe(onNext: { models in
                print("models selected 2: \(models)")
            })
            .disposed(by: disposeBag)
        
        Observable.just([UIColor.systemBlue, UIColor.systemGreen, UIColor.systemRed])
            .bind(to: pickerView3.rx.items) { row, element, _ in
            let view = UIView()
                view.backgroundColor = element
                return view
            }
            .disposed(by: disposeBag)
        
        pickerView3.rx.modelSelected(UIColor.self)
            .subscribe(onNext: { models in
                print("models selected3: \(models)")
            })
            .disposed(by: disposeBag)
        
        Observable.just(sesacItem)
            .bind(to: sesacPickerView.rx.itemTitles) { row, element in
                return "\(element)"
            }
            .disposed(by: disposeBag)
        
        sesacPickerView.rx.modelSelected(String.self)
            .subscribe(onNext: { value in
                print("새우: \(value)")
            })
            .disposed(by: disposeBag)
    }
}

extension ViewController {
    private func configure() {
        
        view.backgroundColor = .white
        
        [
        pickerView1,
        pickerView2,
        pickerView3,
        sesacPickerView
        ].forEach {
            view.addSubview($0)
        }
    }
    
    private func setConstraints() {
        pickerView1.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalToSuperview()
            //높이 설정 보류
        }
        
        pickerView2.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(pickerView1.snp.bottom).offset(5)
            //높이 설정 보류
        }
        
        pickerView3.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(pickerView2.snp.bottom).offset(5)
//            make.bottom.lessThanOrEqualTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        sesacPickerView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(pickerView3.snp.bottom).offset(5)
            make.bottom.lessThanOrEqualTo(view.safeAreaLayoutGuide).inset(20)        }
    }
}
