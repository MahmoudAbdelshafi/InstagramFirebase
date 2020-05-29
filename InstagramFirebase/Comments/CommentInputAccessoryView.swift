//
//  CommentInputAccessoryView.swift
//  InstagramFirebase
//
//  Created by Mahmoud on 5/29/20.
//  Copyright © 2020 Mahmoud. All rights reserved.
//

import UIKit


protocol CommentInputAccessoryViewDelegate {
    func didSubmit(for comment: String)
    
}


class CommentInputAccessoryView: UIView{
    
    var delegate:CommentInputAccessoryViewDelegate?
    
    let submitButton :UIButton = {
        let sb = UIButton(type: .system)
        sb.setTitle("Post", for: .normal)
        sb.setTitleColor(#colorLiteral(red: 0, green: 0.4705882353, blue: 0.6862745098, alpha: 1), for: .normal)
        sb.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        sb.addTarget(self, action: #selector(handelSubmit), for: .touchUpInside)
        return sb
    }()
    
    
    let commentTextView:CommentInputTextView = {
        let tv = CommentInputTextView ()
        tv.isScrollEnabled = false
        tv.font = UIFont.systemFont(ofSize: 18)
        return tv
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        autoresizingMask = .flexibleHeight
        addSubview(submitButton)
        addSubview(commentTextView)
        submitButton.anchor(top: topAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 65, height: 50 )
        commentTextView.anchor(top: topAnchor, left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor , right: submitButton.leftAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8, width: 0, height: 0)
        
        lineSeparatorView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize{
        return .zero
    }
    @objc  func handelSubmit(){
        
        guard let commentText = commentTextView.text else {return}
        if commentText.isEmpty{
            return
        }
        delegate?.didSubmit(for: commentText)
      
    }
    func clearCommentTextFiled(){
        commentTextView.text = nil
        commentTextView.showPlaceHolder()
    }
    
}

//MARK: Private Functions
extension CommentInputAccessoryView{
    
    
    
    fileprivate func lineSeparatorView(){
        let lineSeparatorView = UIView()
        lineSeparatorView.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230 )
        addSubview(lineSeparatorView)
        lineSeparatorView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        
        
    }
    
    
}
