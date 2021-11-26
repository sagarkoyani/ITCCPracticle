//
//  GExtension+UIView.swift
//  MVVMBasicStructure
//
//  Created by KISHAN_RAJA on 22/09/20.
//  Copyright © 2020 KISHAN_RAJA. All rights reserved.
//

import UIKit

extension UIView {
    var asImage: UIImage? {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in layer.render(in: rendererContext.cgContext) }
    }
    
    func addTabBottomBorderWithColor(color: UIColor,origin : CGPoint, width : CGFloat , height : CGFloat, view: UIView? = nil) -> CALayer {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x:origin.x, y:self.frame.size.height - height, width:width, height:height)
        if view == nil {
            self.layer.insertSublayer(border, at: 0)
        } else {
            self.layer.insertSublayer(border, below: view!.layer)
        }
        
        return border
    }
    
    func shake() {
        self.transform = CGAffineTransform(translationX: 20, y: 0)
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    
    func bounce(completion: @escaping (Bool) -> Void) {
        self.isUserInteractionEnabled = false
        self.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.6, options: .allowUserInteraction, animations: { [weak self] in
            
            self?.transform = .identity
            
        }) { (complete : Bool) in
            self.isUserInteractionEnabled = true
            completion(complete)
        }
    }
    
    func addBlurEffect(){
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        self.insertSubview(blurEffectView, at: 0)
    }
    
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            // swiftlint:disable:next force_unwrapping
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    
    //Bottom Line
    func addBottomBorderWithColor(color: UIColor,origin : CGPoint, width : CGFloat , height : CGFloat) -> CALayer {
        
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x:origin.x, y:self.frame.size.height - height, width:width, height:height)
        self.layer.addSublayer(border)
        return border
    }
    
    func curruntFirstResponder() -> UIResponder? {
        
        if self.isFirstResponder {
            return self
        }
        
        for view in self.subviews {
            if let responder  = view.curruntFirstResponder() {
                return responder
            }
        }
        return nil;
    }
    
    class func fromNib<T : UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
    
    func subviews<T:UIView>(ofType WhatType:T.Type) -> [T] {
        var result = self.subviews.compactMap {$0 as? T}
        for sub in self.subviews {
            result.append(contentsOf: sub.subviews(ofType:WhatType))
        }
        return result
    }
}
extension UIView {
    
    fileprivate struct AssociatedObjectKeys {
        static var tapGestureRecognizer = "MediaViewerAssociatedObjectKey_mediaViewer"
    }
    
    fileprivate typealias Action = (() -> Void)?
    
    fileprivate var tapGestureRecognizerAction: Action? {
        set {
            if let newValue = newValue {
                // Computed properties get stored as associated objects
                objc_setAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            }
        }
        get {
            let tapGestureRecognizerActionInstance = objc_getAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer) as? Action
            return tapGestureRecognizerActionInstance
        }
    }
    
    public func addTapGestureRecognizer(action: (() -> Void)?) {
        self.isUserInteractionEnabled = true
        self.tapGestureRecognizerAction = action
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc fileprivate func handleTapGesture() {
        if let action = self.tapGestureRecognizerAction {
            action?()
        } else {
            print("no action")
        }
    }
    
    func currentFirstResponder() -> UIResponder? {
        
        if self.isFirstResponder {
            
            return self
        }
        
        for view in self.subviews {
            if let responder  = view.currentFirstResponder() {
                return responder
            }
        }
        return nil;
    }
    
    func applyViewShadow(shadowOffset : CGSize? , shadowColor : UIColor?, shadowOpacity : Float?, shdowRadious: CGFloat? = nil) {
        
        if shadowOffset != nil {
            self.layer.shadowOffset = shadowOffset!
        }
        else {
            self.layer.shadowOffset = CGSize(width: 0, height: 0)
        }
        
        if shadowColor != nil {
            self.layer.shadowColor = shadowColor?.cgColor
        } else {
            self.layer.shadowColor = UIColor.clear.cgColor
        }
        
        //For button border width
        if shadowOpacity != nil {
            self.layer.shadowOpacity = shadowOpacity!
        }
        else {
            self.layer.shadowOpacity = 0
        }
        
        if shdowRadious != nil {
            self.layer.shadowRadius = shdowRadious!
        }
        self.layer.masksToBounds = false
    }
    
    func removeShadow() {
        self.layer.shadowOffset = CGSize(width: 0 , height: 0)
        self.layer.shadowColor = UIColor.clear.cgColor
        self.layer.shadowRadius = 0.0
        self.layer.shadowOpacity = 0.0
    }
    
    private static let kLayerNameGradientBorder = "GradientBorderLayer"
    private static let kLayerNameBackgroundLayer = "BackgroundLayer"
    
    func gradientBorder(width: CGFloat,
                        colors: [UIColor],
                        startPoint: CGPoint = CGPoint(x: 1.0, y: 0.0),
                        endPoint: CGPoint = CGPoint(x: 1.0, y: 1.0),
                        andRoundCornersWithRadius cornerRadius: CGFloat = 0,
                        bgColor: UIColor = .white,
                        shadowColor: UIColor = .black,
                        shadowRadius: CGFloat = 5.0,
                        shadowOpacity: Float = 0.75,
                        shadowOffset: CGSize = CGSize(width: 0.0, height: 0.0)
    ) {
        
        let existingBackground = backgroundLayer()
        let bgLayer = existingBackground ?? CALayer()
        
        bgLayer.name = UIView.kLayerNameBackgroundLayer
        
        // set its color
        bgLayer.backgroundColor = bgColor.cgColor
        
        // insert at 0 to not cover other layers
        if existingBackground == nil {
            layer.insertSublayer(bgLayer, at: 0)
        }
        
        // use same cornerRadius as border
        bgLayer.cornerRadius = cornerRadius
        // inset its frame by 1/2 the border width
        bgLayer.frame = bounds.insetBy(dx: width * 0.5, dy: width * 0.5)
        
        // set shadow properties
        layer.shadowColor = shadowColor.cgColor
        layer.shadowRadius = shadowRadius
        layer.shadowOpacity = shadowOpacity
        layer.shadowOffset = shadowOffset
        
        let existingBorder = gradientBorderLayer()
        let border = existingBorder ?? CAGradientLayer()
        
        border.name = UIView.kLayerNameGradientBorder
        
        // don't do this
        //      border.frame = CGRect(x: bounds.origin.x, y: bounds.origin.y,
        //                            width: bounds.size.width + width, height: bounds.size.height + width)
        
        // use this instead
        border.frame = bounds
        
        border.colors = colors.map { $0.cgColor }
        border.startPoint = startPoint
        border.endPoint = endPoint
        
        let mask = CAShapeLayer()
        let maskRect = CGRect(x: bounds.origin.x + width/2, y: bounds.origin.y + width/2,
                              width: bounds.size.width - width, height: bounds.size.height - width)
        
        let path = UIBezierPath(roundedRect: maskRect, cornerRadius: cornerRadius).cgPath
        mask.path = path
        mask.fillColor = UIColor.clear.cgColor
        mask.strokeColor = UIColor.black.cgColor
        mask.backgroundColor = UIColor.black.cgColor
        mask.lineWidth = width
        mask.masksToBounds = false
        border.mask = mask
        
        let exists = (existingBorder != nil)
        if !exists {
            layer.addSublayer(border)
        }
        
    }
    
    private func backgroundLayer() -> CALayer? {
        let aLayers = layer.sublayers?.filter { return $0.name == UIView.kLayerNameBackgroundLayer }
        if aLayers?.count ?? 0 > 1 {
            fatalError()
        }
        return aLayers?.first
    }
    
    private func gradientBorderLayer() -> CAGradientLayer? {
        let borderLayers = layer.sublayers?.filter { return $0.name == UIView.kLayerNameGradientBorder }
        if borderLayers?.count ?? 0 > 1 {
            fatalError()
        }
        return borderLayers?.first as? CAGradientLayer
    }
    
     func applyGradientLayerWith(colors:[CGColor]){
        //https://stackoverflow.com/questions/23074539/programmatically-create-a-uiview-with-color-gradient
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colors
        self.layer.insertSublayer(gradient, at: 0)
        
    }
        func gradientBackColor(colors:[CGColor]){
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = self.bounds
            gradientLayer.colors = colors
            
            UIGraphicsBeginImageContext(gradientLayer.bounds.size)
            gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            self.backgroundColor = UIColor(patternImage: image!)
            
        }
    
}

extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

extension UIView {
    func addBottomDotWithColor(color: UIColor, origin: CGPoint, width: CGFloat, height: CGFloat) -> CALayer {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.cornerRadius = height / 2
        border.frame = CGRect(x: origin.x, y: frame.size.height - height, width: width, height: height)
        layer.addSublayer(border)
        return border
    }
}

extension UIView {
    func addshadow(top: Bool,
                   left: Bool,
                   bottom: Bool,
                   right: Bool,
                   shadowRadius: CGFloat = 2.0, shadowOpacity: Float = 1.0) {
        
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowColor = UIColor.lightGray.cgColor
        
        let path = UIBezierPath()
        var x: CGFloat = 0
        var y: CGFloat = 0
        var viewWidth = self.frame.width
        var viewHeight = self.frame.height
        
        // here x, y, viewWidth, and viewHeight can be changed in
        // order to play around with the shadow paths.
        if (!top) {
            y+=(shadowRadius+1)
        }
        if (!bottom) {
            viewHeight-=(shadowRadius+1)
        }
        if (!left) {
            x+=(shadowRadius+1)
        }
        if (!right) {
            viewWidth-=(shadowRadius+1)
        }
        // selecting top most point
        path.move(to: CGPoint(x: x, y: y))
        // Move to the Bottom Left Corner, this will cover left edges
        /*
         |☐
         */
        path.addLine(to: CGPoint(x: x, y: viewHeight))
        // Move to the Bottom Right Corner, this will cover bottom edge
        /*
         ☐
         -
         */
        path.addLine(to: CGPoint(x: viewWidth, y: viewHeight))
        // Move to the Top Right Corner, this will cover right edge
        /*
         ☐|
         */
        path.addLine(to: CGPoint(x: viewWidth, y: y))
        // Move back to the initial point, this will cover the top edge
        /*
         _
         ☐
         */
        path.close()
        self.layer.shadowPath = path.cgPath
    }
}

extension UIView {
    ///Returns text and UI direction based on current view settings
    var userInterfaceLayoutDirection: UIUserInterfaceLayoutDirection{
        if #available(iOS 9.0, *) {
            return UIView.userInterfaceLayoutDirection(for: self.semanticContentAttribute)
        } else {
            return UIApplication.shared.userInterfaceLayoutDirection
        }
    }
}

extension UIView {
    func enableZoom() {
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(startZooming(_:)))
        isUserInteractionEnabled = true
        addGestureRecognizer(pinchGesture)
    }
    
    @objc
    private func startZooming(_ sender: UIPinchGestureRecognizer) {
        let scaleResult = sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale)
        guard let scale = scaleResult, scale.a > 1, scale.d > 1 else { return }
        sender.view?.transform = scale
        sender.scale = 1
    }
}
