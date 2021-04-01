//
//  RoomViewController.swift
//  Koven
//
//  Created by Adit Sachde on 1/21/21.
//

import MatrixKit

class RoomViewController: MXKRoomViewController {
    
//    override func cellViewClass(for cellData: MXKCellData!) -> MXKCellRendering.Type! {
//        bubblesTableView.register(ACellView.self, forCellReuseIdentifier: "ACellViewIdentifier")
//        return ACellView.self
//    }
//
//    override func cellReuseIdentifier(for cellData: MXKCellData!) -> String! {
//        return "ACellViewIdentifier"
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bubblesTableView.register(RoomIncomingTextMsgBubbleCell.self, forCellReuseIdentifier: RoomIncomingTextMsgBubbleCell.defaultReuseIdentifier())
        self.bubblesTableView.register(MXKRoomEmptyBubbleTableViewCell.self, forCellReuseIdentifier: MXKRoomEmptyBubbleTableViewCell.defaultReuseIdentifier())
    }
    
    override func cellViewClass(for cellData: MXKCellData!) -> MXKCellRendering.Type! {
        var cellViewClass: MXKCellRendering.Type? = nil
        var showEncrpytionBadge: Bool = false;

        // Sanity Check
        if let bubbleData = cellData as? MXKRoomBubbleCellDataStoring {

            if let roomBubbleCellData = bubbleData as? MXKRoomBubbleCellData {
                showEncrpytionBadge = roomBubbleCellData.containsBubbleComponentWithEncryptionBadge
            }

            // If-else chain to select the suitable table view cell class

            if (bubbleData.hasNoDisplay) {
                cellViewClass = MXKRoomEmptyBubbleTableViewCell.self
            }
            // incoming messages
            else if (bubbleData.isIncoming) {
                // attachments
                if (bubbleData.isAttachmentWithThumbnail) {
                    if (bubbleData.shouldHideSenderInformation) {
                        cellViewClass = MXKRoomIncomingAttachmentWithoutSenderInfoBubbleCell.self
                    } else {
                        cellViewClass = MXKRoomIncomingAttachmentBubbleCell.self
                    }
                }
                // text messages
                else {
                    if (bubbleData.shouldHideSenderInformation) {
                        cellViewClass = MXKRoomIncomingTextMsgWithoutSenderInfoBubbleCell.self
                    } else {
                        cellViewClass = RoomIncomingTextMsgBubbleCell.self
                    }
                }
            }
            // outgoing messages
            else {
                // attachments
                if (bubbleData.isAttachmentWithThumbnail) {
                    if (bubbleData.shouldHideSenderInformation) {
                        cellViewClass = MXKRoomOutgoingAttachmentWithoutSenderInfoBubbleCell.self
                    } else {
                        cellViewClass = MXKRoomOutgoingAttachmentBubbleCell.self
                    }
                }
                // text messages
                else {
                    if (bubbleData.shouldHideSenderInformation) {
                        cellViewClass = MXKRoomOutgoingTextMsgWithoutSenderInfoBubbleCell.self
                    } else {
                        cellViewClass = MXKRoomOutgoingTextMsgBubbleCell.self
                    }
                }
            }

        }

        return cellViewClass
        
    }
    
}
