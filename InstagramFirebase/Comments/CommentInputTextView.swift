//
//  CommentInputTextView.swift
//  InstagramFirebase
//
//  Created by Mahmoud on 5/29/20.
//  Copyright © 2020 Mahmoud. All rights reserved.
//

import UIKit

class CommentInputTextView: UITextView, UITextViewDelegate {
    fileprivate let placeholder:UILabel = {
        let label = UILabel()
        label.text = "Add a comment here..."
        label.textColor = UIColor.lightGray
        return label
    }()
    
    func showPlaceHolder(){
        placeholder.isHidden = false
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer:textContainer)
        
        self.delegate = self
        addSubview(placeholder)
        placeholder.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8, width: 0, height: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func textViewDidChange(_ textView: UITextView) {
        placeholder.isHidden = !self.text.isEmpty
    }
    
}
