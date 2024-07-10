//
//  SendAudioCell.swift
//  WeKiddo_School-School
//
//  Created by Abdul Aziz H on 31/08/19.
//  Copyright © 2019 Mixogy. All rights reserved.
//

import Firebase
import UIKit

protocol SendAudioCellDelegate: class {
    func didTapAudio(audioURL: URL)
}

class SendAudioCell: UITableViewCell {

    weak var delegate: SendAudioCellDelegate?
    var audioURL: URL?
    
    private var avatar: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(named: "ic_profile")
        imageView.layer.cornerRadius = 18
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private var nameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.text = "You"
        return label
    }()
    
    private var messageImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        return imageView
    }()
    
    private var messageButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setImage(UIImage(named: "ic_bullet"), for: .normal)
        return button
    }()
    
    private var messageContainer: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor(red: 203/255, green: 237/255, blue: 241/255, alpha: 1.0)
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubviews()
        setupConstraints()
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        addSubviews()
        setupConstraints()
        setupViews()
    }
    
    func addSubviews() {
        contentView.addSubview(avatar)
        contentView.addSubview(messageContainer)
        
        messageContainer.addSubview(nameLabel)
        messageContainer.addSubview(messageImageView)
        messageContainer.addSubview(messageButton)
    }
    
    func setupConstraints() {
        contentView.addConstraints(format: "H:[v0(160)]-[v1(36)]-16-|", views: messageContainer, avatar)
        contentView.addConstraints(format: "V:|-16-[v0(36)]", views: avatar)
        contentView.addConstraints(format: "V:|-16-[v0]-16-|", views: messageContainer)
        
        messageContainer.addConstraints(format: "H:|-8-[v0]-8-|", views: nameLabel)
        messageContainer.addConstraints(format: "H:|-8-[v0]-8-|", views: messageImageView)
        messageContainer.addConstraints(format: "V:|-8-[v0]-8-[v1(160)]-8-|", views: nameLabel, messageImageView)
        
        messageContainer.addConstraints(format: "H:|-60-[v0(40)]", views: messageButton)
        messageContainer.addConstraints(format: "V:|-80-[v0(40)]", views: messageButton)
    }
    
    func setupViews() {
        selectionStyle = .none
        
        messageButton.addTarget(self, action: #selector(audioButtonDidTapped), for: .touchUpInside)
    }
    
    func config(message: Message) {
        audioURL = URL(string: message.mediaHash ?? "")
    }
    
    @objc
    func audioButtonDidTapped() {
        guard let url = self.audioURL else {
            return
        }
        delegate?.didTapAudio(audioURL: url)
    }
}
