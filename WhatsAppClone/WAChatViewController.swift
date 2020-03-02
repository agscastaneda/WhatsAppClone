//
//  WAChatViewController.swift
//  WhatsAppClone
//
//  Created by Agustin Castaneda on 26/02/20.
//  Copyright © 2020 Agustin Castaneda. All rights reserved.
//

import UIKit
import StreamChat
import StreamChatCore
import RxSwift


class WAChatViewController: ChatViewController {
    
    private lazy var composerContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .WA_ligthGray
        return view
    }()
    
    private lazy var plusBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .systemBlue
        button.addTarget(self, action: #selector(showActionSheet), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        print("❕\(Self.self).\(#function)")
        self.navigationItem.largeTitleDisplayMode = .never
        styleComposerView()
        styleMessages()
        super.viewDidLoad()
        configureComposerView()
        addComponserContainerBck()
    }
    
    private func styleComposerView(){
        
        style.composer.edgeInsets = .init(top: 8, left: 48, bottom: 8, right: 8)
        style.composer.backgroundColor = .white
        style.composer.textColor = .black
        style.composer.height = 32
        style.composer.cornerRadius = style.composer.height/2
        addFileTypes()
    }
    
    private func styleMessages(){
        style.incomingMessage.backgroundColor = .white
        style.incomingMessage.chatBackgroundColor = .WA_chatBackground
        style.incomingMessage.cornerRadius = 5
        style.incomingMessage.avatarViewStyle = .none
        style.outgoingMessage.backgroundColor = .WA_outgoingChatBubble
        style.outgoingMessage.chatBackgroundColor = .WA_chatBackground
        style.outgoingMessage.cornerRadius = 5
        style.outgoingMessage.avatarViewStyle = .none
    }
    
    private func addFileTypes(){
//        composerAddFileTypes = [.camera,.photo,.file,.custom(icon: UIImage(systemName: "mappin.circle"), title: "Location", .custom(0), {val in
//            print("Location touched \(val)")
//        }),.custom(icon: UIImage(systemName: "person.circle"), title: "Contact", .custom(1), {val in
//            print("Contact touched \(val)")
//        })]
        composerAddFileTypes = [] // empty to hide defult + button
    }
    
    private func configureComposerView(){
        composerView.setSendButtonImage(UIImage(systemName: "paperplane.fill")!)
        composerView.sendButton.tintColor = .systemBlue
        composerView.placeholderText = " "
        composerView.attachmentButton.setImage(UIImage(systemName: "plus"), for: .normal)
        composerView.attachmentButton.tintColor = .systemBlue
    }
    
    private func addComponserContainerBck() {
        view.insertSubview(composerContainer, belowSubview: composerView)
        composerContainer.snp.makeConstraints { make in
            make.top.equalTo(composerView.snp.top).offset(-8)
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        composerContainer.addSubview(plusBtn)
        plusBtn.snp.makeConstraints { make in
            make.centerY.equalTo(composerView.snp.centerY)
            make.right.equalTo(composerView.snp.left).offset(-8)
            make.height.equalTo(32)
            make.width.equalTo(32)
        }
    }
    
    @objc private func showActionSheet(){
        print("Show action sheet here")
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let actionCamera = UIAlertAction(title: "Camera", style: UIAlertAction.Style.default) { _ in
            print("Camera")
            self.showImagePicker(composerAddFileViewSourceType: .photo(.camera))
        }
        
        let actionPhoto = UIAlertAction(title: "Photo & Video Library", style: UIAlertAction.Style.default) { _ in
            print("Photo & Video Library")
            self.showImagePicker(composerAddFileViewSourceType: .photo(.savedPhotosAlbum))
        }
        let actionDocument =  UIAlertAction(title: "Document", style: UIAlertAction.Style.default) { _ in
            print("Document")
            self.showDocumentPicker()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        
        actionCamera.setValue(UIImage(systemName: "camera"), forKey: "image")
        actionPhoto.setValue(UIImage(systemName: "photo"), forKey: "image")
        actionDocument.setValue(UIImage(systemName: "doc.text"), forKey: "image")
        
        alert.addAction(actionCamera)
        alert.addAction(actionPhoto)
        alert.addAction(actionDocument)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
}


