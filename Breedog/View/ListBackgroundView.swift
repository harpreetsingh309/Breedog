//
//  ListBackgroundView.swift
//  Breedog
//
//  Created by macexpert on 02/04/21.
//

import UIKit

class ListBackgroundView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initViews()
    }
    
    private func initViews() {
        backgroundColor = .clear
        addSubviews([messageLabel])
    }
    
    // MARK: Getters and Setters
    
    internal var messageText: String {
        get {
            return messageLabel.text!
        }
        set {
            messageLabel.text = newValue
        }
    }
    
    private var _messageLabel: UILabel?
    private var messageLabel: UILabel {
        get {
            if _messageLabel == nil {
                _messageLabel = UILabel()
                _messageLabel?.textColor = .black
                _messageLabel?.font = UIFont(name: "GillSans", size: 22.0)
                _messageLabel?.textAlignment = .center
            }
            return _messageLabel!
        }
        set {
            _messageLabel = newValue
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addConstraintSameCenterXY(self, and: messageLabel)
    }
    
}
