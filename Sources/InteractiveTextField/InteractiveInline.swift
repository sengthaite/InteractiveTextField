//
//  InteractiveInline.swift
//  
//
//  Created by Sengthai Te on 13/5/22.
//

import UIKit

open class InteractiveInline: UIStackView {
    
    public var itemsAlignment: UIStackView.Alignment = .top {
        didSet {
            alignment = itemsAlignment
        }
    }
    
    public var icon: UIImage? {
        didSet {
            iconView.isHidden = icon == nil
            iconView.image = icon
        }
    }
    
    public var iconSize: CGSize = CGSize(width: 14, height: 14) {
        didSet {
            iconView.frame.size = iconSize
        }
    }
    
    public var text: String? {
        didSet {
            label.text = text
        }
    }
    
    public var textColor: UIColor? {
        didSet {
            label.textColor = textColor
        }
    }
    
    public var textAlignment: NSTextAlignment = .left {
        didSet {
            label.textAlignment = textAlignment
        }
    }
    
    public var numberOfLines: Int = 1 {
        didSet {
            label.numberOfLines = numberOfLines
        }
    }
    
    public var font: UIFont? {
        didSet {
            label.font = font
        }
    }
    
    fileprivate let iconView = UIImageView()
    
    fileprivate let label = UILabel()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commitUI()
    }
    
    public required init(coder: NSCoder) {
        super.init(coder: coder)
        commitUI()
    }
    
    fileprivate func commitUI() {
        addArrangedSubview(iconView)
        addArrangedSubview(label)
        axis = .horizontal
        alignment = itemsAlignment
        iconView.image = icon
        iconView.isHidden = icon == nil
        iconView.contentMode = .scaleAspectFit
        label.textAlignment = textAlignment
        label.numberOfLines = numberOfLines
        label.setContentHuggingPriority(UILayoutPriority(251), for: .horizontal)
    }
    
}
