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
    
    internal var searchText: String? {
        get {
            return searchLabel.text!
        }
        set {
            let isValue = newValue != nil && newValue?.count != 0
            messageLabel.isHidden = isValue
        }
    }
    
    private var _searchLabel: UILabel?
    private var searchLabel: UILabel {
        get {
            if _searchLabel == nil {
                _searchLabel = UILabel()
                _searchLabel?.textColor = .black
                _searchLabel?.font = UIFont(name: "GillSans", size: 20.0)
            }
            return _searchLabel!
        }
        set {
            _searchLabel = newValue
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
