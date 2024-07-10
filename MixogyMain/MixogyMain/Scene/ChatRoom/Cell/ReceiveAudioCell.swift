//
//  ReceiveAudioCell.swift
//  WeKiddo_School-School
//
//  Created by Abdul Aziz H on 04/09/19.
//  Copyright © 2019 Mixogy. All rights reserved.
//

import UIKit

class ReceiveAudioCell: UITableViewCell {
    
    weak var delegate: SendAudioCellDelegate?
    var audioURL: URL?
    
    private var avatar: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.layer.cornerRadius = 18
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private var nameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 13)
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
        view.layer.cornerRadius = 4
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 0.7
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
        contentView.addConstraints(format: "H:|-16-[v0(36)]-[v1(160)]", views: avatar, messageContainer)
        contentView.addConstraints(format: "V:|-16-[v0(36)]", views: avatar)
        contentView.addConstraints(format: "V:|-16-[v0]-16-|", views: messageContainer)
        
        messageContainer.addConstraints(format: "H:|-8-[v0]-8-|", views: nameLabel)
        messageContainer.addConstraints(format: "H:|-8-[v0]-8-|", views: messageImageView)
        messageContainer.addConstraints(format: "V:|-8-[v0]-8-[v1(160)]-8-|", views: nameLabel, messageImageView)
        
        messageContainer.addConstraints(format: "H:[v0(40)]-60-|", views: messageButton)
        messageContainer.addConstraints(format: "V:|-80-[v0(40)]", views: messageButton)
    }
    
    func setupViews() {
        selectionStyle = .none
        
        messageButton.addTarget(self, action: #selector(imageButtonDidTapped), for: .touchUpInside)
    }
    
    func config(message: Message) {
        avatar.sd_setImage(
            with: URL(string: message.senderAvatar),
            placeholderImage: UIImage(named: "ic_parent_profile"),
            options: .refreshCached,
            completed: nil
        )
        
        nameLabel.text = message.senderName
        audioURL = URL(string: message.mediaHash ?? "")
    }
    
    @objc
    func imageButtonDidTapped() {
        guard let url = self.audioURL else {
            return
        }
        delegate?.didTapAudio(audioURL: url)
    }
}
