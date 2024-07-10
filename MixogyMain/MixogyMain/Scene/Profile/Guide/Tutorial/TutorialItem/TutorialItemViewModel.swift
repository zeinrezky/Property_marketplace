//
//  TutorialItemViewModel.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 17/09/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import RxCocoa
import RxSwift

class TutorialItemViewModel {
    var image = BehaviorRelay<UIImage?>(value: nil)
    var info = BehaviorRelay<String?>(value: nil)
}
