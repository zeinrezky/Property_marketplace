//
//  SellCreateMovieCell.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 03/04/21.
//  Copyright © 2021 Mixogy. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

protocol SellCreateMovieCellDelegate: class {
    func sellCreateMovieCell(sellCreateMovieCell didFill: SellCreateMovieCell, text: String, index: Int)
}

class SellCreateMovieCell: UICollectionViewCell {

    @IBOutlet var seatTextField: UITextField!
    
    weak var delegate: SellCreateMovieCellDelegate?
    var disposeBag = DisposeBag()
    
    var value: String? {
        didSet {
            seatTextField.text = value
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        seatTextField.layer.borderWidth = 1.0
        seatTextField.layer.borderColor = UIColor(hexString: "#D5D5D5").cgColor
        
        seatTextField
            .rx
            .controlEvent([.editingDidEnd])
            .asObservable().subscribe({ [unowned self] _ in
                if let value = self.seatTextField.text, !value.isEmpty {
                    self.delegate?.sellCreateMovieCell(sellCreateMovieCell: self, text: value, index: self.contentView.tag)
                }
        }).disposed(by: disposeBag)
    }
}
