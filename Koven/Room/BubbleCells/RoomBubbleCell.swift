//
//  RoomBubbleCell.swift
//  Koven
//
//  Created by Adit Sachde on 2/5/21.
//

import Foundation
import UIKit
import MatrixKit
import MessageKit

class RoomBubbleCell: UITableViewCell, MXKCellRendering {
    var delegate: MXKCellRenderingDelegate!
    private var renderCount = 0
    private var reuseCount = 0

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
    
    static func nib() -> UINib! {
        return nil
    }
    
    @objc static func defaultReuseIdentifier() -> String {
        return String(describing: self)
    }

    func setDelegate(_ delegate: MXKCellRenderingDelegate) {
        self.delegate = delegate
    }
        
    override func prepareForReuse() {
        super.prepareForReuse()
        cellTopLabel.text = nil
        cellBottomLabel.text = nil
        messageTopLabel.text = nil
        messageBottomLabel.text = nil
        messageTimestampLabel.attributedText = nil
    }

    // MARK: - Subviews
    
    /// The image view displaying the avatar.
    var avatarView = AvatarView()
    
    func layoutAvatarView() {
        
    }
    
    /// The container used for styling and holding the message's content view.
    var messageContainerView: MessageContainerView = {
        let containerView = MessageContainerView()
        containerView.clipsToBounds = true
        containerView.layer.masksToBounds = true
        return containerView
    }()
    
    func layoutMessagesContainerView() {
        var origin: CGPoint = .zero
        var size: CGSize = .zero
        
        origin.y = 20
        size.height = self.bounds.height - 35
        origin.x = 40
        size.width = self.bounds.width - 50
        
        messageContainerView.frame = CGRect(origin: origin, size: size)
    }
    
    /// The top label of the cell.
    var cellTopLabel: InsetLabel = {
        let label = InsetLabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    func layoutCellTopLabel() {
        cellTopLabel.textAlignment = .center
        cellTopLabel.text = "test"
        cellTopLabel.frame = CGRect(origin: .zero, size: CGSize(width: self.bounds.width, height: 20))
    }
    
    /// The bottom label of the cell.
    var cellBottomLabel: InsetLabel = {
        let label = InsetLabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    func layoutCellBottomLabel() {
        cellBottomLabel.textAlignment = .left
        cellBottomLabel.text = "bottom text"
        cellBottomLabel.frame = CGRect(origin: CGPoint(x: 35, y: self.bounds.height-15), size: CGSize(width: self.bounds.width-35, height: 15))

    }
    
    /// The top label of the messageBubble.
    var messageTopLabel: InsetLabel = {
        let label = InsetLabel()
        label.numberOfLines = 0
        return label
    }()

    func layoutMessageTopLabel() {
        
    }
    
    /// The bottom label of the messageBubble.
    var messageBottomLabel: InsetLabel = {
        let label = InsetLabel()
        label.numberOfLines = 0
        return label
    }()
    
    func layoutMessageBottomLabel() {
        
    }

    /// The time label of the messageBubble.
    var messageTimestampLabel: InsetLabel = InsetLabel()
    
    func layoutMessageTimestampLabel() {
        
    }
    
    // MARK: - Subview Setup
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutCellTopLabel()
        layoutMessageTopLabel()
        layoutMessageBottomLabel()
        layoutCellBottomLabel()
        layoutMessagesContainerView()
        layoutAvatarView()
        layoutMessageTimestampLabel()
    }
    
    func setupSubviews() {
        cellTopLabel.backgroundColor = UIColor.gray
        self.contentView.addSubview(cellTopLabel)
        messageTopLabel.backgroundColor = UIColor.gray
        self.contentView.addSubview(messageTopLabel)
        messageBottomLabel.backgroundColor = UIColor.gray
        self.contentView.addSubview(messageBottomLabel)
        cellBottomLabel.backgroundColor = UIColor.gray
        self.contentView.addSubview(cellBottomLabel)
        messageContainerView.backgroundColor = UIColor.gray
        self.contentView.addSubview(messageContainerView)
        avatarView.backgroundColor = UIColor.gray
        self.contentView.addSubview(avatarView)
        messageTimestampLabel.backgroundColor = UIColor.gray
        self.contentView.addSubview(messageTimestampLabel)
    }
    
    // MARK: - Rendering and Height
    
    func render(_ cellData: MXKCellData!) {
        
        return
    }
    
    static func height(for cellData: MXKCellData!, withMaximumWidth maxWidth: CGFloat) -> CGFloat {
        return 160
    }
    
}
