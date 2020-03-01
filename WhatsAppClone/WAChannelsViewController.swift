//
//  WAChannelsViewController.swift
//  WhatsAppClone
//
//  Created by Agustin Castaneda on 26/02/20.
//  Copyright © 2020 Agustin Castaneda. All rights reserved.
//

import UIKit
import StreamChat
import StreamChatCore

class WAChannelsViewController: ChannelsViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("❕\(Self.self).\(#function)")
        title = "Chats"
        setupNavigationBar()
        style.channel.separatorStyle = .init()
        style.channel.nameColor = .black
        style.channel.avatarViewStyle = AvatarViewStyle(radius: 30, placeholderFont: nil)
        style.channel.height = 80
        style.channel.nameFont = .systemFont(ofSize: 15, weight: .bold)
    }
    
    private func setupNavigationBar(){
        self.navigationController?.navigationBar.barTintColor = .WA_ligthGray
                self.navigationController?.navigationBar.prefersLargeTitles = true
                self.navigationController?.navigationBar.tintColor = .systemBlue
                self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
                self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
                self.navigationController?.navigationBar.isTranslucent = false
                self.navigationController?.view.backgroundColor = UIColor.white
        //        TODO: Add navigation bar items
    }
    
    override func createChatViewController(with channelPresenter: ChannelPresenter, indexPath: IndexPath) -> ChatViewController {
        let chatViewController = WAChatViewController(nibName: nil, bundle: nil)
        chatViewController.style = style
        channelPresenter.eventsFilter = channelsPresenter.channelEventsFilter
        chatViewController.channelPresenter = channelPresenter
        print("❕\(Self.self).\(#function)")
        return chatViewController
    }
    
    override func channelCell(at indexPath: IndexPath, channelPresenter: ChannelPresenter) -> UITableViewCell {
        // For now, get the default channel cell.
        let cell = super.channelCell(at: indexPath, channelPresenter: channelPresenter)

        // We need to check if the returned cell is ChannelTableViewCell.
        guard let channelCell = cell as? ChannelTableViewCell else {
            return cell
        }
        
        // Check the number of unread messages.
        if channelPresenter.channel.currentUnreadCount > 0 {
            // Add the info about unread messages to the cell.
            channelCell.update(info: "  \(channelPresenter.channel.currentUnreadCount)  ", isUnread: true)
        }

        return channelCell
    }


}

