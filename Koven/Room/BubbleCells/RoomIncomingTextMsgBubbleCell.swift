//
//  RoomIncomingTextMsgBubbleCell.swift
//  Koven
//
//  Created by Adit Sachde on 2/1/21.
//

import Foundation
import UIKit
import MatrixKit
import MessageKit

class RoomIncomingTextMsgBubbleCell: RoomBubbleCell {
    
    // MARK: - Initialize
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        setupSubviews()
    }
    
    // MARK: - Setup and Reuse
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        messageLabel.backgroundColor = UIColor.gray
        self.contentView.addSubview(messageLabel)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

        messageLabel.attributedText = nil
        messageLabel.text = nil
    }

    // MARK: - Subviews
    
    var messageLabel = MessageLabel()

    var messageLabel2: UILabel = {
        let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
        label.text = "test text"
        label.backgroundColor = UIColor.green
        return label
    }()
    
    // MARK: - Rendering and Height
    
    override func render(_ cellData: MXKCellData!) {
        super.render(cellData)
        if let bubbleData = cellData as? MXKRoomBubbleCellDataStoring {
            print("loggerlogging attempted to render")
            messageLabel.backgroundColor = UIColor.black
            messageLabel.frame = messageContainerView.frame
            if (bubbleData.hasAttributedTextMessage) {
                if let unwrapped = bubbleData.attributedTextMessage {
                    messageLabel.backgroundColor = UIColor.green
                    print("loggerlogging Atxt \(unwrapped)")
                    self.backgroundColor = UIColor.red

                    messageLabel.text = "message \(unwrapped)"
                }
            }
            
        }
        return
    }
    
    
}
