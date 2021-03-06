//
//  UIView+Extension.swift
//  SpiderColor
//
//  Created by Ailton Vieira Pinto Filho on 16/03/20.
//  Copyright © 2020 Veevaz. All rights reserved.
//

import UIKit

extension UIView {
    @IBInspectable
    var cornerRadius: CGFloat {
        get { layer.cornerRadius }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get { layer.borderWidth }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get { layer.shadowRadius }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get { layer.shadowOpacity }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get { layer.shadowOffset }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
}

extension UIView {
    var isRTL: Bool {
        UIView.userInterfaceLayoutDirection(
            for: self.semanticContentAttribute) == .rightToLeft
    }
}
