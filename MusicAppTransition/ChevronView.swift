//
//  ChevronView.swift
//  MusicAppTransition
//
//  Created by lynx on 09/09/2018.
//  Copyright © 2018 Gulnaz. All rights reserved.
//

import UIKit

class ChevronView: UIView, InteractiveViewDelegate{
    class Settings {
        static var width: CGFloat = 4.67
        static var angleCoefficient: CGFloat = 42.5714286
        static var color = UIColor.lightGray
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    var color: UIColor = Settings.color
    var width = Settings.width

    
    func commonInit(){
        self.isUserInteractionEnabled = false
    }
    
    var leftView: UIView?
    var rightView: UIView?
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if leftView == nil {
            leftView = UIView(frame: CGRect.zero)
            leftView!.backgroundColor = color
            rightView = UIView(frame: CGRect.zero)
            rightView!.backgroundColor = color
            
            addSubview(leftView!)
            addSubview(rightView!)
        }
        
        var leftFrame = CGRect.zero
        var rightFrame = CGRect.zero
        
        let (slice, reminder) = bounds.divided(atDistance: bounds.size.width * 0.5, from: .minXEdge)
        leftFrame = slice
        rightFrame = reminder
        
        leftFrame.size.height = width
        rightFrame.size.height = leftFrame.size.height
        
        var angle: CGFloat = bounds.size.height / bounds.size.width * Settings.angleCoefficient
        var dx: CGFloat = leftFrame.size.width * (1 - cos(angle * .pi / 180.0)) / 2.0
        
        leftFrame = leftFrame.offsetBy(dx: width / 2 + dx - 0.75, dy: 0.0)
        rightFrame = rightFrame.offsetBy(dx: -(width / 2) - dx + 0.75, dy: 0.0)
        
        leftView!.bounds = leftFrame
        rightView!.bounds = rightFrame
        leftView!.center = CGPoint(x: leftFrame.midX, y: bounds.midY)
        
        leftView!.center = CGPoint(x: leftFrame.midX, y: bounds.midY)
        rightView!.center = CGPoint(x: rightFrame.midX, y: bounds.midY)
        
        leftView!.layer.cornerRadius = width / 2.0
        rightView!.layer.cornerRadius = width / 2.0
        
        if isConfigured == false{
            update(0)
            isConfigured = true
        }
    }
    
    var isConfigured: Bool = false
    var x: CGFloat = 0.1
    
    func cancel() {
        update(0)
    }
    
    func update(_ percentComplete: CGFloat) {
        var k: CGFloat
        if percentComplete >= x{
            k = 0
        }else if percentComplete == 0{
            k = -1
        }else{
            k = -1 + percentComplete/x
        }
        
        let angle = self.bounds.size.height / self.bounds.size.width * Settings.angleCoefficient
        
        self.leftView?.transform = CGAffineTransform(rotationAngle: -k * angle * CGFloat.pi / 180.0);
        self.rightView?.transform = CGAffineTransform(rotationAngle: k * angle * CGFloat.pi / 180.0);
        
    }
}
