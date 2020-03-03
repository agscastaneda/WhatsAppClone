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
        composerView.sendButton.snp.updateConstraints { make in
            make.bottom.equalToSuperview().offset(-40)
        composerView.clipsToBounds = false
        composerView.layoutIfNeeded()
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
        let actionCustomImg =  UIAlertAction(title: "Custom (Upload Local Image)", style: UIAlertAction.Style.default) { _ in
            print("Custom")
            self.uploadImage()
        }
        
        let actionCustomPDF =  UIAlertAction(title: "Custom (Upload Local PDF)", style: UIAlertAction.Style.default) { _ in
            print("Custom")
            self.uploadPDF()
        }

        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        
        actionCamera.setValue(UIImage(systemName: "camera"), forKey: "image")
        actionPhoto.setValue(UIImage(systemName: "photo"), forKey: "image")
        actionDocument.setValue(UIImage(systemName: "doc.text"), forKey: "image")
        actionCustomImg.setValue(UIImage(systemName: "ellipsis.circle"), forKey: "image")
        actionCustomPDF.setValue(UIImage(systemName: "arrow.up.doc.fill"), forKey: "image")
        
        alert.addAction(actionCamera)
        alert.addAction(actionPhoto)
        alert.addAction(actionDocument)
        alert.addAction(actionCustomImg)
        alert.addAction(actionCustomPDF)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
}

extension WAChatViewController{
    
    fileprivate func uploadImage(){
        let image = UIImage(named: "mariposa")!
        // Upload UIImage.
        if let imageData = image.jpegData(compressionQuality: 0.9) {
            self.channelPresenter?.channel.sendImage(fileName: "mariposa",
                              mimeType: AttachmentFileType.jpeg.mimeType,
                              imageData: imageData)
                .observeOn(MainScheduler.instance)
                .subscribe(
                    onNext: { response in
                        print(response.progress)
                        if let url = response.result{
                            self.channelPresenter?.send(text:"\(url.absoluteString)")
                            .subscribe(
                                onNext: { [weak self] messageResponse in
                                    if messageResponse.message.type == .error {
                                        self?.show(error: ClientError.errorMessage(messageResponse.message))
                                    }
                                },
                                onError: { [weak self] in
                                    self?.composerView.reset()
                                    self?.show(error: $0)
                                },
                                onCompleted: { [weak self] in self?.composerView.reset() })
                                .disposed(by: self.disposeBag)
                        }
                        
                },
                    onCompleted: {
                        print("The image was uploaded")
                        self.send()
                })
                .disposed(by: disposeBag)
        }
    }
    
    fileprivate func uploadPDF(){
        guard let url = Bundle.main.url(forResource: "lorem-ipsum", withExtension: "pdf")else {
            return
        }
        
        self.composerView.addFileUploaderItem(UploaderItem(channel: self.channelPresenter!.channel, url: url))
    }
}


