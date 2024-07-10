//
//  ChatRoomViewController.swift
//  WeKiddo_School-School
//
//  Created by Ferry Irawan on 25/08/19.
//  Copyright © 2019 Mixogy. All rights reserved.
//

import Agrume
import Foundation
import SVProgressHUD
import UIKit
import IQAudioRecorderController
import GSImageViewerController
import AVKit
import StreamingKit

class ChatRoomViewController: UIViewController {
    
    private var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private var sendMessageView: UIView = {
        let view = UIView(frame: .zero)
        return view
    }()
    
    private var separatorView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .lightGray
        return view
    }()
    
    private var sendButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setImage(UIImage(named: "ChatSend"), for: .normal)
        return button
    }()
    
    private var attachButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setImage(UIImage(named: "ChatAttach"), for: .normal)
        return button
    }()
    
    private var sendField: UITextField = {
        let textfield = UITextField(frame: .zero)
        textfield.placeholder = "Start Chatting..."
        textfield.borderStyle = UITextField.BorderStyle.roundedRect
        textfield.font = UIFont(name: "Nunito-Regular", size: 14)
        return textfield
    }()
    
    private var messages = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubview()
        setupConstraint()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.isNavigationBarHidden = true
        navigationController?.navigationBar.isHidden = true
    }
    
    func addSubview() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(separatorView)
        view.addSubview(sendMessageView)
        
        sendMessageView.addSubview(sendField)
        sendMessageView.addSubview(sendButton)
        sendMessageView.addSubview(attachButton)
    }
    
    func setupConstraint() {
        let window = UIApplication.shared.keyWindow
        let bottomPadding = window?.safeAreaInsets.bottom
        view.addConstraints(format: "H:|[v0]|", views: tableView)
        view.addConstraints(format: "H:|[v0]|", views: separatorView)
        view.addConstraints(format: "H:|[v0]|", views: sendMessageView)
        view.addConstraints(format: "V:|[v0][v1(1)][v2(44)]-\(bottomPadding ?? 0)-|", views: tableView, separatorView, sendMessageView)
        
        sendMessageView.addConstraints(format: "H:|-8-[v0(44)]-8-[v1]-8-[v2(44)]-8-|", views: attachButton, sendField, sendButton)
        sendButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        attachButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: sendMessageView.centerYAnchor).isActive = true
        attachButton.centerYAnchor.constraint(equalTo: sendMessageView.centerYAnchor).isActive = true
        sendField.centerYAnchor.constraint(equalTo: sendMessageView.centerYAnchor).isActive = true
    }
    
    func setupViews() {
        title = "Messaging"
        sendButton.addTarget(self, action: #selector(sendTextMessage), for: .touchUpInside)
        attachButton.addTarget(self, action: #selector(sendMediaMessage), for: .touchUpInside)
        
        tableView.register(SendTextCell.self, forCellReuseIdentifier: "SendTextCell")
        tableView.register(SendImageCell.self, forCellReuseIdentifier: "SendImageCell")
        tableView.register(SendAudioCell.self, forCellReuseIdentifier: "SendAudioCell")
        tableView.register(ReceiveAudioCell.self, forCellReuseIdentifier: "ReceiveAudioCell")
        tableView.register(ReceiverTextCell.self, forCellReuseIdentifier: "ReceiverTextCell")
        tableView.register(ReceiveImageCell.self, forCellReuseIdentifier: "ReceiveImageCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        
        Discussion.fetchMessage { messages in
            self.messages = messages
            self.tableView.reloadData()
            self.scrollToDown()
        }
    }
    
    @objc func sendTextMessage() {
        guard let messageValue = sendField.text, !messageValue.isEmpty else {
            return
        }
        
        SVProgressHUD.show()
        
        Discussion.sendTextMessage(messageValue: messageValue) {
            SVProgressHUD.dismiss()
            self.sendField.text = ""
            self.view.endEditing(true)
        }
    }
    
    @objc func sendMediaMessage() {
        let alertController = UIAlertController(title: "Pilihan", message: nil, preferredStyle: .actionSheet)
        
        let sendImageAction = UIAlertAction(title: "Kirim Gambar", style: .default) { _ in
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Batal", style: .cancel, handler: nil)
        
        alertController.addAction(sendImageAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func scrollToDown() {
        if !messages.isEmpty {
            let indexPath = IndexPath(row: messages.count-1, section: 0)
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
}

extension ChatRoomViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        
        if message.senderId == ((Preference.profile?.codePhone ?? "") + (Preference.profile?.phoneNumber ?? "")) {
            switch message.type {
            case "image":
                let cell = tableView.dequeueReusableCell(withIdentifier: "SendImageCell", for: indexPath) as! SendImageCell
                cell.config(message: messages[indexPath.row])
                cell.delegate = self
                return cell
                
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "SendTextCell", for: indexPath) as! SendTextCell
                cell.config(message: messages[indexPath.row])
                return cell
            }
        } else {
            switch message.type {
            case "image":
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiveImageCell", for: indexPath) as! ReceiveImageCell
                cell.config(message: messages[indexPath.row])
                cell.delegate = self
                return cell
                
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiverTextCell", for: indexPath) as! ReceiverTextCell
                cell.config(message: messages[indexPath.row])
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

public extension UIView {
    
    func addConstraints(
        format: String, views: UIView...,
        options: NSLayoutConstraint.FormatOptions = NSLayoutConstraint.FormatOptions(),
        metrics: [String: Any]? = nil
        ) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: format,
                options: options,
                metrics: metrics,
                views: viewsDictionary
            )
        )
    }
}

extension ChatRoomViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let originalImage = info[.originalImage] as? UIImage {
            SVProgressHUD.show()
            Discussion.sendImageMessage(messageValue: originalImage.jpegData(compressionQuality: 0.5)) {
                SVProgressHUD.dismiss()
            }
        }
    }
}

extension ChatRoomViewController: SendImageCellDelegate {
    
    func didTapImage(image: UIImage) {
        let agrume = Agrume(image: image)
        agrume.show(from: self)
    }
}
