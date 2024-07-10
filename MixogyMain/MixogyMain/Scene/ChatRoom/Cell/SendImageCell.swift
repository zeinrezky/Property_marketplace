//
//  SendImageCell.swift
//  WeKiddo_School-School
//
//  Created by Abdul Aziz H on 30/08/19.
//  Copyright © 2019 Mixogy. All rights reserved.
//

import Firebase
import FirebaseStorage
import SDWebImage
import UIKit

protocol SendImageCellDelegate: class {
    func didTapImage(image: UIImage)
}

class SendImageCell: UITableViewCell {
    
    weak var delegate: SendImageCellDelegate?
    
    private var messageImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .center
        imageView.backgroundColor = UIColor.init(white: 0.8, alpha: 1.0)
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private var messageButton = UIButton(frame: .zero)
    
    private var messageContainer: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor(red: 203/255, green: 237/255, blue: 241/255, alpha: 1.0)
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        return view
    }()
    
    private var dateLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = UIColor(hexString: "#8E8E93")
        label.font = UIFont(name: "Nunito-Regular", size: 10)
        label.numberOfLines = 0
        return label
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
        contentView.addSubview(messageContainer)
        contentView.addSubview(dateLabel)
        
        messageContainer.addSubview(messageImageView)
        messageContainer.addSubview(messageButton)
    }
    
    func setupConstraints() {
        contentView.addConstraints(format: "H:[v0(160)]-16-|", views: messageContainer)
        contentView.addConstraints(format: "H:[v0]-16-|", views: dateLabel)
        contentView.addConstraints(format: "V:|-16-[v0]-5-[v1]-16-|", views: messageContainer, dateLabel)
        
        messageContainer.addConstraints(format: "H:|-8-[v0]-8-|", views: messageImageView)
        messageContainer.addConstraints(format: "V:|-8-[v0(160)]-8-|", views: messageImageView)
        
        messageContainer.addConstraints(format: "H:|[v0]|", views: messageButton)
        messageContainer.addConstraints(format: "V:|[v0]|", views: messageButton)
    }
    
    func setupViews() {
        selectionStyle = .none
        
        messageButton.addTarget(self, action: #selector(imageButtonDidTapped), for: .touchUpInside)
    }
    
    func config(message: Message) {
        let imageStorageRef = Storage.storage().reference(forURL: message.mediaHash ?? "")
        messageImageView.sd_setImage(with: imageStorageRef, placeholderImage: nil)
        let date = Date(timeIntervalSince1970: message.date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateLabel.text = dateFormatter.string(from: date)
    }
    
    @objc
    func imageButtonDidTapped() {
        guard let image = messageImageView.image else {
            return
        }
        
        delegate?.didTapImage(image: image)
    }
}
