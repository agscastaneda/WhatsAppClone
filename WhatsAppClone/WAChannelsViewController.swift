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
    }
    
    override func createChatViewController(with channelPresenter: ChannelPresenter, indexPath: IndexPath) -> ChatViewController {
        let chatViewController = WAChatViewController(nibName: nil, bundle: nil)
        chatViewController.style = style
        channelPresenter.eventsFilter = channelsPresenter.channelEventsFilter
        chatViewController.channelPresenter = channelPresenter
        print("❕\(Self.self).\(#function)")
        return chatViewController
    }


}

