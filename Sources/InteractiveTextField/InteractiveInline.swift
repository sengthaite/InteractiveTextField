//
//  File.swift
//  
//
//  Created by Sengthai Te on 13/5/22.
//

import UIKit

public class InteractiveInline: UIStackView {
    
    public override func sizeToFit() {
        super.sizeToFit()
        layoutUI()
    }
    
    var icon: UIImage? {
        didSet {
            iconView.image = icon
        }
    }
    
    var iconSize: CGSize = CGSize(width: 14, height: 14) {
        didSet {
            layoutUI()
        }
    }
    
    var iconPadding: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 4) {
        didSet {
            layoutUI()
        }
    }
    
    var text: String? {
        didSet {
            label.text = text
        }
    }
    
    var textColor: UIColor? {
        didSet {
            label.textColor = textColor
        }
    }
    
    var textAlignment: NSTextAlignment = .left {
        didSet {
            label.textAlignment = textAlignment
        }
    }
    
    var numberOfLines: Int = 1 {
        didSet {
            label.numberOfLines = numberOfLines
        }
    }
    
    var font: UIFont? {
        didSet {
            label.font = font
        }
    }
    
    private let iconWrapper = UIView()
    
    private let iconView = UIImageView()
    
    private let label = UILabel()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commitUI()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        commitUI()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        layoutUI()
    }
    
}

extension InteractiveInline {
    
    private func commitUI() {
        iconWrapper.addSubview(iconView)
        addArrangedSubview(iconView)
        addArrangedSubview(label)
    }
    
    private func layoutUI() {
        let iconSize = icon?.size ?? iconSize
        iconView.frame = CGRect(x: iconPadding.left, y: iconPadding.top, width: iconSize.width, height: iconSize.height)
        iconWrapper.frame.size.width = iconSize.width + iconPadding.left + iconPadding.right
        label.frame = CGRect(x: iconWrapper.frame.maxX, y: 0, width: bounds.width - iconWrapper.frame.maxX, height: 0)
        label.numberOfLines = numberOfLines
        label.sizeToFit()
        label.frame.size.height = label.frame.height
    }
    
}
