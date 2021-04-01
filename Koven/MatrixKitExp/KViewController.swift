//
//  KViewController.swift
//  Koven
//
//  Created by Adit Sachde on 1/14/21.
//

import SwiftUI
import MatrixKit
import MessageKit

class KViewController: MessagesViewController {
    var dataSouce: KDataSource = KDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
    }
}

extension KViewController: MXKDataSourceDelegate {
    func cellViewClass(for cellData: MXKCellData!) -> MXKCellRendering.Type! {
        return nil
    }
    
    func cellReuseIdentifier(for cellData: MXKCellData!) -> String! {
        return nil
    }
    
    func dataSource(_ dataSource: MXKDataSource!, didCellChange changes: Any!) {
        self.messagesCollectionView.reloadData()
        self.messagesCollectionView.collectionViewLayout.invalidateLayout()
    }
}

extension KViewController: MessagesDataSource {
    func currentSender() -> SenderType {
        let senderId = dataSouce.currentSenderId() ?? ""
        let displayName = dataSouce.currentSenderDisplayName() ?? ""
        return Sender(senderId: senderId, displayName: displayName)
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        let bubble = dataSouce.message(forItem: Int32(indexPath.item))
        return Message(sender: self.currentSender(), messageId: "af", sentDate: Date(), kind: .text("Lmaogrid"))
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        dataSouce.numberOfSections()
    }
}

extension KViewController: MessagesDisplayDelegate, MessagesLayoutDelegate {}
