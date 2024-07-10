//
//  ReceiverTextCell.swift
//  WeKiddo_School-School
//
//  Created by Abdul Aziz H on 25/08/19.
//  Copyright © 2019 Mixogy. All rights reserved.
//

import UIKit

class ReceiverTextCell: UITableViewCell {
    
    private var messageLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = UIColor(hexString: "#8E8E93")
        label.font = UIFont(name: "Nunito-Regular", size: 12)
        label.numberOfLines = 0
        return label
    }()
    
    private var dateLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = UIColor(hexString: "#8E8E93")
        label.font = UIFont(name: "Nunito-Regular", size: 10)
        label.numberOfLines = 0
        return label
    }()
    
    private var messageContainer: UIView = {
        let view = UIView(frame: .zero)
        view.layer.cornerRadius = 10
        view.backgroundColor = UIColor(hexString: "#F2F2F2")
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
        contentView.addSubview(messageContainer)
        contentView.addSubview(dateLabel)
        
        messageContainer.addSubview(messageLabel)
    }
    
    func setupConstraints() {
        contentView.addConstraints(format: "H:|-16-[v0]-(>=16)-|", views: messageContainer)
        contentView.addConstraints(format: "H:|-16-[v0]", views: dateLabel)
        contentView.addConstraints(format: "V:|-16-[v0]-5-[v1]-16-|", views: messageContainer, dateLabel)
        
        messageContainer.addConstraints(format: "H:|-8-[v0]-(>=8)-|", views: messageLabel)
        messageContainer.addConstraints(format: "V:|-8-[v0]-8-|", views: messageLabel)
    }
    
    func setupViews() {
        selectionStyle = .none
    }
    
    func config(message: Message) {
        messageLabel.text = message.body
        let date = Date(timeIntervalSince1970: message.date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateLabel.text = dateFormatter.string(from: date)
    }

}
