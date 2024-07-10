//
//  TermAndConditionViewController.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 07/06/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import UIKit

class TermAndConditionViewController: UIViewController {

    @IBOutlet var textView: UITextView!
    @IBOutlet var titleLabel: UILabel!
    
    var value: String?
    var titleValue: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textView.attributedText = value?.htmlToAttributedString
        titleLabel.text = titleValue ?? "Terms and Conditions"
    }
}
