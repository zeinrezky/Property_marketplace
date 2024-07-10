//
//  ItemLocationDetailViewController.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 20/08/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import BottomPopup
import RxCocoa
import RxSwift
import UIKit

protocol ItemLocationDetailViewControllerDelegate: class {
    func itemLocationDetailViewController(didSelect itemLocationDetailViewController: ItemLocationDetailViewController, id: Int)
}

class ItemLocationDetailViewController: BottomPopupViewController {

    var height: CGFloat?
    var topCornerRadius: CGFloat?
    var presentDuration: Double?
    var dismissDuration: Double?
    var shouldDismissInteractivelty: Bool?
    var disposeBag = DisposeBag()
    var viewModel = ItemLocationDetailViewModel()
    
    @IBOutlet var tablleView: UITableView!
    weak var delegate: ItemLocationDetailViewControllerDelegate?
    
    override func getPopupHeight() -> CGFloat {
        return height ?? CGFloat(UIScreen.main.bounds.size.height - 100)
    }
    
    override func getPopupTopCornerRadius() -> CGFloat {
        return topCornerRadius ?? CGFloat(12)
    }
    
    override func getPopupPresentDuration() -> Double {
        return presentDuration ?? 1.0
    }
    
    override func getPopupDismissDuration() -> Double {
        return dismissDuration ?? 1.0
    }
    
    override func shouldPopupDismissInteractivelty() -> Bool {
        return shouldDismissInteractivelty ?? true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBinding()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.setup()
    }
}

// MARK: - Private Extension

extension ItemLocationDetailViewController {
    
    func setupUI() {
        tablleView.register(UINib(nibName: "ItemLocationDetailHeaderCell", bundle: nil), forCellReuseIdentifier: "ItemLocationDetailHeaderCell")
        
        tablleView.register(UINib(nibName: "ItemLocationDetailInfoCell", bundle: nil), forCellReuseIdentifier: "ItemLocationDetailInfoCell")
        
        viewModel.setup()
    }
    
    func setupBinding() {
        viewModel.data.bind(to: tablleView.rx.items) { tableView, index, item in
            switch item {
            case .header(let data):
                let cell: ItemLocationDetailHeaderCell = tableView.dequeueReusableCell(withIdentifier: "ItemLocationDetailHeaderCell") as! ItemLocationDetailHeaderCell
                cell.data = data
                return cell
            
            case .info(let data):
                let cell: ItemLocationDetailInfoCell = tableView.dequeueReusableCell(withIdentifier: "ItemLocationDetailInfoCell") as! ItemLocationDetailInfoCell
                cell.data = data
                cell.delegate = self
                return cell
                
            }
        }.disposed(by: disposeBag)
    }
}

// MARK: - ItemLocationDetailInfoCellDelegate

extension ItemLocationDetailViewController: ItemLocationDetailInfoCellDelegate {
    
    func itemLocationDetailInfoCell(didSelect itemLocationDetailInfoCell: ItemLocationDetailInfoCell, id: Int) {
        delegate?.itemLocationDetailViewController(didSelect: self, id: id)
        dismiss(animated: true, completion: nil)
    }
}
