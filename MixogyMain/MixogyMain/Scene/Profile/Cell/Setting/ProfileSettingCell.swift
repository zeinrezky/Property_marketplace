//
//  ProfileSettingCell.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 22/03/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

protocol ProfileSettingCellDelegate: class {
    func profileSettingCell(didChangeRadius profileSettingCell: ProfileSettingCell, radius: Int)
    func profileSettingCell(didLogout profileSettingCell: ProfileSettingCell)
    func profileSettingCell(didChangePassword profileSettingCell: ProfileSettingCell)
    func profileSettingCell(didOpenGuide profileSettingCell: ProfileSettingCell)
}

class ProfileSettingCell: MixogyBaseCell {

    @IBOutlet var logoutButton: UIButton!
    @IBOutlet var languageButton: UIButton!
    @IBOutlet var changePasswordButton: UIButton!
    @IBOutlet var nearbyLabel: UILabel!
    @IBOutlet var changeLanguageLabel: UILabel!
    @IBOutlet var slider: UISlider!
    
    weak var delegate: ProfileSettingCellDelegate?
    var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupUI() {
        logoutButton.layer.cornerRadius = 12
        logoutButton.layer.borderColor = UIColor(hexString: "#21A99B").cgColor
        logoutButton.layer.borderWidth = 1
    }
    
    override func setupLanguage() {
        logoutButton.setTitle("profile-logout".localized(), for: .normal)
        changePasswordButton.setTitle("profile-change-password".localized(), for: .normal)
        languageButton.setTitle("profile-lang".localized(), for: .normal)
        
        changeLanguageLabel.text = "profile-change-language".localized()
        nearbyLabel.text = "profile-radius".localized() + ": \(Int(radius ?? 0)) m"
    }
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        self.delegate?.profileSettingCell(didChangeRadius: self, radius: Int(slider.value))
    }
    
    @IBAction func sliderOnChanged(_ sender: UISlider) {
        nearbyLabel.text = "profile-radius".localized() + ": \(Int(sender.value)) m"
    }
    
    @IBAction func changePasswordDidTapped(_ sender: UIButton) {
        delegate?.profileSettingCell(didChangePassword: self)
    }
    
    @IBAction func logout(_ sender: UIButton) {
        self.delegate?.profileSettingCell(didLogout: self)
    }
    
    @IBAction func changeLanguage(_ sender: UIButton) {
        Preference.language = Preference.language ?? "en" == "en" ? "id-ID" : "en"
        Bundle.setLanguage(lang: Preference.language ?? "en")
        NotificationCenter.default.post(
            name: Notification.Name(Constants.ChangeLanguageKey),
            object: nil,
            userInfo: nil
        )
    }
    
    @IBAction func guide(_ sender: UIButton) {
        self.delegate?.profileSettingCell(didOpenGuide: self)
    }
    
    var radius: Float? {
        didSet {
            if let value = radius {
                slider.value = value
                nearbyLabel.text = "profile-radius".localized() + ": \(Int(value)) m"
            }
        }
    }
}
