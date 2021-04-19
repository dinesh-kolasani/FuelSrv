//
//  Utility.swift
//  FuelSrv
//
//  Created by PBS9 on 03/04/19.
//  Copyright © 2019 Dinesh. All rights reserved.
//

import Foundation
import UIKit

class Utility
{

    static func showAlertMessage(vc: UIViewController?, titleStr:String, messageStr:String) -> Void
    {
        let alert = UIAlertController(title: titleStr, message: messageStr, preferredStyle: UIAlertControllerStyle.alert);
        let action = UIAlertAction.init(title: "ok", style: .default, handler: nil)
        alert.addAction(action)
        if (vc == nil)
        {
            if let app = UIApplication.shared.delegate as? AppDelegate, let window = app.window {
                window.rootViewController?.present(alert, animated: true, completion: nil)
            }
        }
        else
        {
            vc?.present(alert, animated: true, completion: nil)
        }
    }
}

// For the RoundedButton with border color and cornerradius also for UIButton.

@IBDesignable
class RoundButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 0{
        didSet{
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0{
        didSet{
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear{
        didSet{
            self.layer.borderColor = borderColor.cgColor
        }
    }
}

//  For the Roundedview with border color and cornerradius also for UIView.
@IBDesignable
class RoundedView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 0{
        didSet{
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0{
        didSet{
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear{
        didSet{
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var rightSideCorner: CGFloat = 0{
        didSet{
            self.layer.maskedCorners = .layerMinXMaxYCorner
        }
    }
}
extension UIViewController
{
    //Mark:- Validations
    // Verifying valid Email or Not
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    // vrify Valid PhoneNumber or Not
    func isValidPhone(phone: String) -> Bool {
        
        let phoneRegex = "^[0-9]{10}$";
        let valid = NSPredicate(format: "SELF MATCHES %@", phoneRegex).evaluate(with: phone)
        return valid
    }
    
    // Show AlertMessage
    func showAlert(_ title: String, _ message:String,_ buttonTitle:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: buttonTitle, style: .default) { (action: UIAlertAction) in
            
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func addsubView(subView:UIView , superView:UIView){
                let topConstraint = NSLayoutConstraint(item: superView, attribute: .top, relatedBy: .equal, toItem: subView , attribute: .top, multiplier: 1, constant: 0)
                let bottomConstraint = NSLayoutConstraint(item: superView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: 0)
                let leadingConstraint = NSLayoutConstraint(item: superView, attribute: .leading, relatedBy: .equal, toItem: subView, attribute: .leading, multiplier: 1, constant: 0)
                let trailingConstraint = NSLayoutConstraint(item: superView, attribute: .trailing, relatedBy: .equal, toItem: subView, attribute: .trailing, multiplier: 1, constant: 0)
        
                subView.addSubview(superView)
                subView.addConstraints([topConstraint, bottomConstraint, leadingConstraint, trailingConstraint])
                subView.layoutIfNeeded()
    }
    
    func currencyFormat(_ value: String?) -> String {
        guard value != nil else { return "$0.00" }
        let doubleValue = Double(value!) ?? 0.0
        let formatter = NumberFormatter()
        formatter.currencyCode = "USD"
        formatter.currencySymbol = "$"
        
        formatter.minimumFractionDigits = (value!.contains(".00")) ? 0 : 2
        formatter.maximumFractionDigits = 2
        formatter.numberStyle = .currencyAccounting
        formatter.negativeFormat = "-$"
        return formatter.string(from: NSNumber(value: doubleValue)) ?? "$\(doubleValue)"
    }
    
    func numberFormat(_ someString: String?) -> NSNumber {
        guard someString != nil else { return 0.00 }
        let doubleValue = Double(someString!) ?? 0.0
        //let myInteger = Int(doubleValue)
        let myNumber = NSNumber(value:doubleValue)
        return myNumber
    }
//    func setImage(_ card : String) -> UIImage {
//        switch card {
//
//        case card == "Visa" :
//            #imageLiteral(resourceName: "Visa")
//
//        case CardType.MasterCard.rawValue: break
//
//        case CardType.Amex.rawValue: break
//
//        case CardType.JCB.rawValue: break
//
//        case CardType.Discover.rawValue: break
//
//        case CardType.Diners.rawValue: break
//
//        case CardType.Maestro.rawValue: break
//
//        case CardType.Electron.rawValue: break
//
//        case CardType.Dankort.rawValue: break
//
//        case CardType.UnionPay.rawValue: break
//
//        case CardType.RuPay.rawValue: break
//
//
//        case CardType.Unknown.rawValue: break
//
//        default:
//
//
//            break
//        }
//    }
   
}
//Maximum length of characters for text field

private var __maxLengths = [UITextField: Int]()
extension UITextField {
    @IBInspectable var maxLength: Int {
        get {
            guard let l = __maxLengths[self] else {
                return 150 // (global default-limit. or just, Int.max)
            }
            return l
        }
        set {
            __maxLengths[self] = newValue
            addTarget(self, action: #selector(fix), for: .editingChanged)
        }
    }
    @objc func fix(textField: UITextField) {
        let t = textField.text
        textField.text = t?.safelyLimitedTo(length: maxLength)
    }
}

extension String
{
    func safelyLimitedTo(length n: Int)->String {
        if (self.count <= n) {
            return self
        }
        return String( Array(self).prefix(upTo: n) )
    }
    
    var numberValue: NSNumber? {
        if let value = Int(self) {
            return NSNumber(value: value)
        }
        return nil
    }
}

//MARK:- Button Text UnderLine
extension UIButton {
    func underline() {
        guard let text = self.titleLabel?.text else { return }
        
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSAttributedStringKey.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: NSRange(location: 0, length: text.count))
        
        self.setAttributedTitle(attributedString, for: .normal)
    }
}
//MARK:- Label Text UnderLine
extension UILabel {
    func underline() {
        if let textString = self.text {
            let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(NSAttributedStringKey.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: NSRange(location: 0, length: attributedString.length - 1))
            attributedText = attributedString
        }
    }
}

extension UIView {
    func setOneSideCorner(outlet:UIView){
    //Corner radius for view.
    outlet.clipsToBounds = true
    outlet.layer.cornerRadius = 25
    outlet.layer.maskedCorners = [.layerMinXMaxYCorner]
    }
    
    func dropShadow(view: UIView, opacity: Float){
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOpacity = opacity
        view.layer.shadowOffset = CGSize(width: 3, height: 3)
        view.layer.shadowRadius = 5
    }
}
//extension UIFont {
//    class func appSemiBoldFontWith( size:CGFloat ) -> UIFont{
//        return  UIFont(name: "SegoeUI-Semibold", size: size)!
//    }
//    for name in UIFont.familyNames() {
//    println(name)
//    if let nameString = name as? String
//    
//    {
//    
//    println(UIFont.fontNamesForFamilyName(nameString))
//    }
//    }
//}
extension UIApplication {
    var statusBarView: UIView?{
        return value(forKey: "statusBar") as? UIView
    }
}
