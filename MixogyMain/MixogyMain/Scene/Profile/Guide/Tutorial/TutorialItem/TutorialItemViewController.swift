//
//  TutorialItemViewController.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 10/09/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class TutorialItemViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var infoLabel: UILabel!
    
    var viewModel = TutorialItemViewModel()
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel
            .image
            .bind(to: imageView.rx.image)
            .disposed(by: disposeBag)
        
        viewModel
            .info
            .bind(to: infoLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
