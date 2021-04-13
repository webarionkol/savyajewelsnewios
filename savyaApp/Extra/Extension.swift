//
//  Extension.swift
//  savyaApp
//
//  Created by Yash on 6/17/19.
//  Copyright © 2019 Yash Rathod. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    // OUTPUT 1
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 1
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func addShadow(offset: CGSize, color: UIColor, radius: CGFloat, opacity: Float) {
        layer.masksToBounds = false
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        
        let backgroundCGColor = backgroundColor?.cgColor
        backgroundColor = nil
        layer.backgroundColor =  backgroundCGColor
    }
    
    func cornerRadius(radius:CGFloat) {
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
    }
}

extension UIViewController {
    
    func showAlert(titlee:String,message:String) {
        let alert = UIAlertController(title: titlee, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
extension String{
    func convertHtml(str:String) -> NSAttributedString{
       let htmlData = NSString(string: str).data(using: String.Encoding.unicode.rawValue)
       let options = [NSAttributedString.DocumentReadingOptionKey.documentType:
               NSAttributedString.DocumentType.html]
       let attributedString = try? NSMutableAttributedString(data: htmlData ?? Data(),
                                                                 options: options,
                                                                 documentAttributes: nil)
        return attributedString!
    }
}
extension NSMutableAttributedString {
    @discardableResult func bold(_ text: String) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [.font: UIFont(name: "AvenirNext-Medium", size: 12)!]
        let boldString = NSMutableAttributedString(string:text, attributes: attrs)
        append(boldString)

        return self
    }

    @discardableResult func normal(_ text: String) -> NSMutableAttributedString {
        let normal = NSAttributedString(string: text)
        append(normal)

        return self
    }
}
extension String {
    var floatValue: Float {
        return (self as NSString).floatValue
    }
}
extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
extension Array where Element: Hashable {
    var uniques: Array {
        var buffer = Array()
        var added = Set<Element>()
        for elem in self {
            if !added.contains(elem) {
                buffer.append(elem)
                added.insert(elem)
            }
        }
        return buffer
    }
}

extension String {

    func toDate(withFormat format: String = "yyyy-MMM-dd")-> String? {

        let dateFormatter = DateFormatter()
      //  dateFormatter.timeZone = TimeZone(identifier: "India Standard Time")
      //  dateFormatter.locale = Locale(identifier: "fa-IR")
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)
        let str = dateFormatter.string(from: date!)
        return str

    }
    func toTime(withFormat format: String = "HH:mm:ss")-> String?{

        let dateFormatter = DateFormatter()
        //   dateFormatter.timeZone = TimeZone(identifier: "Asia/Tehran")
        //   dateFormatter.locale = Locale(identifier: "fa-IR")
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)
        let str = dateFormatter.string(from: date!)
        return str

       }
}

extension Date {

    func toString(withFormat format: String = "EEEE ، d MMMM yyyy") -> String {

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "fa-IR")
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Tehran")
        dateFormatter.calendar = Calendar(identifier: .persian)
        dateFormatter.dateFormat = format
        let str = dateFormatter.string(from: self)

        return str
    }
}
extension Double {
    func rounded(digits: Int) -> Double {
        let multiplier = pow(10.0, Double(digits))
        return (self * multiplier).rounded() / multiplier
    }
}
extension UIView {

    func visiblity(gone: Bool, dimension: CGFloat = 0.0, attribute: NSLayoutConstraint.Attribute = .height) -> Void {
        if let constraint = (self.constraints.filter{$0.firstAttribute == attribute}.first) {
            constraint.constant = gone ? 0.0 : dimension
            self.layoutIfNeeded()
            self.isHidden = gone
        }
    }
    
    func addDashedBorder() {
    let color = UIColor.lightGray.cgColor

    let shapeLayer:CAShapeLayer = CAShapeLayer()
    let frameSize = self.frame.size
    let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)

    shapeLayer.bounds = shapeRect
    shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
    shapeLayer.fillColor = UIColor.clear.cgColor
    shapeLayer.strokeColor = color
    shapeLayer.lineWidth = 2
    shapeLayer.lineJoin = CAShapeLayerLineJoin.round
    shapeLayer.lineDashPattern = [6,3]
    shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 5).cgPath

    self.layer.addSublayer(shapeLayer)
    }
}

extension NSMutableAttributedString {
    var fontSize:CGFloat { return 14 }
    var boldFont:UIFont { return UIFont(name: "AvenirNext-Bold", size: fontSize) ?? UIFont.boldSystemFont(ofSize: fontSize) }
    var normalFont:UIFont { return UIFont(name: "AvenirNext-Regular", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)}

    func boldNew(_ value:String) -> NSMutableAttributedString {

        let attributes:[NSAttributedString.Key : Any] = [
            .font : boldFont
        ]

        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }

    func normalNew(_ value:String) -> NSMutableAttributedString {

        let attributes:[NSAttributedString.Key : Any] = [
            .font : normalFont,
        ]

        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    /* Other styling methods */
    func orangeHighlight(_ value:String) -> NSMutableAttributedString {

        let attributes:[NSAttributedString.Key : Any] = [
            .font :  normalFont,
            .foregroundColor : UIColor.white,
            .backgroundColor : UIColor.orange
        ]

        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }

    func blackHighlight(_ value:String) -> NSMutableAttributedString {

        let attributes:[NSAttributedString.Key : Any] = [
            .font :  normalFont,
            .foregroundColor : UIColor.white,
            .backgroundColor : UIColor.black

        ]

        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }

    func underlined(_ value:String) -> NSMutableAttributedString {

        let attributes:[NSAttributedString.Key : Any] = [
            .font :  normalFont,
            .underlineStyle : NSUnderlineStyle.single.rawValue

        ]

        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
}
extension Int {
    func toString() -> String {
        return String(self)
    }
}

extension CALayer {

enum BorderSide {
    case top
    case right
    case bottom
    case left
    case notRight
    case notLeft
    case topAndBottom
    case all
}

enum Corner {
    case topLeft
    case topRight
    case bottomLeft
    case bottomRight
}

func addBorder(side: BorderSide, thickness: CGFloat, color: CGColor, maskedCorners: CACornerMask? = nil) {
    var topWidth = frame.size.width; var bottomWidth = topWidth
    var leftHeight = frame.size.height; var rightHeight = leftHeight

    var topXOffset: CGFloat = 0; var bottomXOffset: CGFloat = 0
    var leftYOffset: CGFloat = 0; var rightYOffset: CGFloat = 0

    // Draw the corners and set side offsets
    switch maskedCorners {
    case [.layerMinXMinYCorner, .layerMaxXMinYCorner]: // Top only
        addCorner(.topLeft, thickness: thickness, color: color)
        addCorner(.topRight, thickness: thickness, color: color)
        topWidth -= cornerRadius*2
        leftHeight -= cornerRadius; rightHeight -= cornerRadius
        topXOffset = cornerRadius; leftYOffset = cornerRadius; rightYOffset = cornerRadius

    case [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]: // Bottom only
        addCorner(.bottomLeft, thickness: thickness, color: color)
        addCorner(.bottomRight, thickness: thickness, color: color)
        bottomWidth -= cornerRadius*2
        leftHeight -= cornerRadius; rightHeight -= cornerRadius
        bottomXOffset = cornerRadius

    case [.layerMinXMinYCorner, .layerMinXMaxYCorner]: // Left only
        addCorner(.topLeft, thickness: thickness, color: color)
        addCorner(.bottomLeft, thickness: thickness, color: color)
        topWidth -= cornerRadius; bottomWidth -= cornerRadius
        leftHeight -= cornerRadius*2
        leftYOffset = cornerRadius; topXOffset = cornerRadius; bottomXOffset = cornerRadius;

    case [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]: // Right only
        addCorner(.topRight, thickness: thickness, color: color)
        addCorner(.bottomRight, thickness: thickness, color: color)
        topWidth -= cornerRadius; bottomWidth -= cornerRadius
        rightHeight -= cornerRadius*2
        rightYOffset = cornerRadius

    case [.layerMaxXMinYCorner, .layerMaxXMaxYCorner,  // All
          .layerMinXMaxYCorner, .layerMinXMinYCorner]:
        addCorner(.topLeft, thickness: thickness, color: color)
        addCorner(.topRight, thickness: thickness, color: color)
        addCorner(.bottomLeft, thickness: thickness, color: color)
        addCorner(.bottomRight, thickness: thickness, color: color)
        topWidth -= cornerRadius*2; bottomWidth -= cornerRadius*2
        topXOffset = cornerRadius; bottomXOffset = cornerRadius
        leftHeight -= cornerRadius*2; rightHeight -= cornerRadius*2
        leftYOffset = cornerRadius; rightYOffset = cornerRadius

    default: break
    }

    // Draw the sides
    switch side {
    case .top:
        addLine(x: topXOffset, y: 0, width: topWidth, height: thickness, color: color)

    case .right:
        addLine(x: frame.size.width - thickness, y: rightYOffset, width: thickness, height: rightHeight, color: color)

    case .bottom:
        addLine(x: bottomXOffset, y: frame.size.height - thickness, width: bottomWidth, height: thickness, color: color)

    case .left:
        addLine(x: 0, y: leftYOffset, width: thickness, height: leftHeight, color: color)

    // Multiple Sides
    case .notRight:
        addLine(x: topXOffset, y: 0, width: topWidth, height: thickness, color: color)
        addLine(x: 0, y: leftYOffset, width: thickness, height: leftHeight, color: color)
        addLine(x: bottomXOffset, y: frame.size.height - thickness, width: bottomWidth, height: thickness, color: color)

    case .notLeft:
        addLine(x: topXOffset, y: 0, width: topWidth, height: thickness, color: color)
        addLine(x: frame.size.width - thickness, y: rightYOffset, width: thickness, height: rightHeight, color: color)
        addLine(x: bottomXOffset, y: frame.size.height - thickness, width: bottomWidth, height: thickness, color: color)

    case .topAndBottom:
        addLine(x: topXOffset, y: 0, width: topWidth, height: thickness, color: color)
        addLine(x: bottomXOffset, y: frame.size.height - thickness, width: bottomWidth, height: thickness, color: color)

    case .all:
        addLine(x: topXOffset, y: 0, width: topWidth, height: thickness, color: color)
        addLine(x: frame.size.width - thickness, y: rightYOffset, width: thickness, height: rightHeight, color: color)
        addLine(x: bottomXOffset, y: frame.size.height - thickness, width: bottomWidth, height: thickness, color: color)
        addLine(x: 0, y: leftYOffset, width: thickness, height: leftHeight, color: color)
    }
}

private func addLine(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, color: CGColor) {
    let border = CALayer()
    border.frame = CGRect(x: x, y: y, width: width, height: height)
    border.backgroundColor = color
    addSublayer(border)
}

private func addCorner(_ corner: Corner, thickness: CGFloat, color: CGColor) {
    // Set default to top left
    let width = frame.size.width; let height = frame.size.height
    var x = cornerRadius
    var startAngle: CGFloat = .pi; var endAngle: CGFloat = .pi*3/2

    switch corner {
    case .bottomLeft: startAngle = .pi/2; endAngle = .pi

    case .bottomRight:
        x = width - cornerRadius
        startAngle = 0; endAngle = .pi/2

    case .topRight:
        x = width - cornerRadius
        startAngle = .pi*3/2; endAngle = 0

    default: break
    }

    let cornerPath = UIBezierPath(arcCenter: CGPoint(x: x, y: height / 2),
                                  radius: cornerRadius - thickness,
                                  startAngle: startAngle,
                                  endAngle: endAngle,
                                  clockwise: true)

    let cornerShape = CAShapeLayer()
    cornerShape.path = cornerPath.cgPath
    cornerShape.lineWidth = thickness
    cornerShape.strokeColor = color
    cornerShape.fillColor = nil
    addSublayer(cornerShape)
}
}
@IBDesignable
class DesignableView: UIView {
}

@IBDesignable
class DesignableButton: UIButton {
}

@IBDesignable
class DesignableLabel: UILabel {
}


extension UIView {
  
  @IBInspectable
  var cornerRadius: CGFloat {
    get {
      return layer.cornerRadius
    }
    set {
      layer.cornerRadius = newValue
    }
  }
  
  @IBInspectable
  var borderWidth: CGFloat {
    get {
      return layer.borderWidth
    }
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
    get {
      return layer.shadowRadius
    }
    set {
      layer.shadowRadius = newValue
    }
  }
  
  @IBInspectable
  var shadowOpacity: Float {
    get {
      return layer.shadowOpacity
    }
    set {
      layer.shadowOpacity = newValue
    }
  }
  
  @IBInspectable
  var shadowOffset: CGSize {
    get {
      return layer.shadowOffset
    }
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
