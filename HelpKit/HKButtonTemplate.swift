//
//  HKButtonTemplate.swift
//  HelpKit
//
//  Created by Patrick Hanna on 7/17/18.
//  Copyright © 2018 Patrick Hanna. All rights reserved.
//

import UIKit


open class HKButtonTemplate: UIControl{
    
    public init(){
        super.init(frame: CGRect.zero)
        addTarget(self, action: #selector(tapBegan), for: [.touchDown])
        addTarget(self, action: #selector(tapEnded), for: [.touchUpInside,])
        addTarget(self, action: #selector(tapCancelled), for: [.touchCancel, .touchDragExit, .touchDragOutside])
        addTarget(self, action: #selector(carryOutButtonAction), for: .touchUpInside)
    }

    
   
    /// The bounds that is returned is used in the point inside method to determine whether the point occured inside the view. If nil is returned, the bounds of the view is used instead.
    public final lazy var activationArea: () -> CGRect? = {return nil}
    
    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        self.layoutIfNeeded()
        return activationArea()?.contains(point) ?? bounds.contains(point)
    }
    
    /// This is done to prevent subviews from receiving touch information.
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if self.point(inside: point, with: event) &&
            isUserInteractionEnabled &&
            !isHidden &&
            alpha > 0{
            return self
        }
        return nil
    }
    
    
    
    private var actions = [() -> Void]()
    
    public func addAction(_ action: @escaping () -> Void){
        self.actions.append(action)
    }
    

    
    @objc private func carryOutButtonAction(){
        actions.forEach{ $0() }
    }

    
    @objc open func tapBegan() {}
    
    @objc open func tapEnded() {}
    
    @objc open func tapCancelled() {}
    
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
