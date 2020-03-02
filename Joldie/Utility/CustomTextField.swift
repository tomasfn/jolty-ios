//
//  CustomTextField.swift
//  Jolty
//
//  Created by Tomás Fernandez Nuñez on 26/09/2018.
//  Copyright © 2018 Tomás Fernandez Nuñez. All rights reserved.
//

import Foundation
import UIKit

class CustomTextField: UITextField {
    
    @IBInspectable var adjustInterfaceWhenDisabled: Bool = true
    @IBInspectable var enabledAlpha: CGFloat = 1
    @IBInspectable var disabledAlpha: CGFloat = 0.5
    
    override internal var isEnabled: Bool {
        didSet {
            guard adjustInterfaceWhenDisabled == true else { return }
            alpha = isEnabled == true ? enabledAlpha : disabledAlpha
        }
    }
    
    @IBInspectable var placeholderTextColor: UIColor = UIColor.lightGray {
        didSet {
            if placeholder != nil {
                attributedPlaceholder = NSAttributedString(string: placeholder!,
                                                           attributes:[NSAttributedStringKey.foregroundColor: placeholderTextColor])
            } else {
                attributedPlaceholder = nil
            }
        }
    }
    
    override var placeholder : String? {
        didSet {
            
            if placeholder != nil {
                attributedPlaceholder = NSAttributedString(string: placeholder!,
                                                           attributes:[NSAttributedStringKey.foregroundColor: placeholderTextColor])
            } else {
                attributedPlaceholder = nil
            }
            
        }
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 0)
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.rightViewRect(forBounds: bounds)
        rect.origin.x -= 10
        return rect
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.leftViewRect(forBounds: bounds)
        rect.origin.x += 10
        return rect
    }
    
}

//MARK: QuantityTextField
protocol IntegerTextFieldDelegate {
    func didChangeCurrentValue(value: Int)
}

class QuantityTextField: CustomTextField {
    @IBInspectable var minimumValue : Int = 0
    @IBInspectable var maximumValue : Int = 0
    var currentValue : Int = 0 {
        didSet {
            text = "\(currentValue)"
            valueDelegate?.didChangeCurrentValue(value: currentValue)
        }
    }
    
    var valueDelegate : IntegerTextFieldDelegate?
    
    func shouldChangeQuantityTextInRange(range: NSRange, replacementText string: String) -> Bool {
        
        // Validate the entered text
        let inverseSet = NSCharacterSet.decimalDigits.inverted
        let components = string.components(separatedBy: inverseSet)
        let filtered = components.joined(separator: "")
        if string != filtered { return false }
        
        var newString : String
        
        if text != nil {
            newString = (text! as NSString).replacingCharacters(in: range, with: string)
        } else {
            newString = string
        }
        
        if let numericValue = Int(newString),
            numericValue >= minimumValue &&
                numericValue <= maximumValue {
            currentValue = numericValue
        } else {
            text = newString
        }
        
        return false
    }
    
    override func resignFirstResponder() -> Bool {
        let resignFirstResponder = super.resignFirstResponder()
        
        if text != nil && text!.isEmpty == false {
            if let numericValue = Int(text!) { // It's an Int
                
                if numericValue < minimumValue ||
                    numericValue > maximumValue { // If it's beyond the value limits
                    text = "\(currentValue)"
                }
                
            } else { // It's NOT an Int
                text = "\(currentValue)"
            }
            
        } else { // No text entered
            text = "\(currentValue)"
        }
        
        return resignFirstResponder
    }
}
