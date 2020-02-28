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


class WAChatViewController: ChatViewController {
    
    private lazy var composerContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .WA_ligthGray
        return view
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
        
        style.composer.edgeInsets = .init(top: 8, left: 8, bottom: 8, right: 8)
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
        composerAddFileTypes = [.camera,.photo,.file,.custom(icon: UIImage(systemName: "mappin.circle"), title: "Location", .custom(1), {_ in
            print("Location touched") // move to fuction
        }),.custom(icon: UIImage(systemName: "person.circle"), title: "Contact", .custom(2), {_ in
            print("Contact touched") // move to fuction
        })]
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
    }
    
    
}


