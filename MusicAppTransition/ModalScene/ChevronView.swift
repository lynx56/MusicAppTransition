//
//  ChevronView.swift
//  MusicAppTransition
//
//  Created by lynx on 09/09/2018.
//  Copyright © 2018 Gulnaz. All rights reserved.
//

import UIKit

class ChevronView: UIView{
    class Settings {
        static var width: CGFloat = 4.67
        static var color = UIColor.lightGray
    }
  
    let leftWing = CAShapeLayer()
    let rightWing = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
   
    func setup() {
        backgroundColor = .clear
        leftWing.path = ChevronView.preparePath(in: bounds).0.cgPath
        rightWing.path = ChevronView.preparePath(in: bounds).1.cgPath
        
        let setupLayer: (CAShapeLayer) -> Void = {
            $0.strokeColor = Settings.color.cgColor
            $0.fillColor = Settings.color.cgColor
            $0.lineWidth = Settings.width
            $0.lineCap = kCALineCapRound
        }
        
        setupLayer(leftWing)
        setupLayer(rightWing)
        leftWing.frame = bounds
        rightWing.frame = bounds
        
        self.layer.addSublayer(leftWing)
        self.layer.addSublayer(rightWing)
    }
    
    private static func preparePath(in rect: CGRect) -> (UIBezierPath, UIBezierPath) {
        let leftPath = UIBezierPath()
        let rightPath = UIBezierPath()
        let lineRect = CGRect(x: rect.minX + Settings.width/2,
                              y: rect.minY + Settings.width/2,
                              width: rect.width - Settings.width,
                              height: rect.height - Settings.width
        )

        leftPath.move(to: CGPoint(x: lineRect.minX, y: lineRect.midY))
        leftPath.addLine(to: CGPoint(x: lineRect.midX, y: lineRect.midY))
        rightPath.move(to: CGPoint(x: lineRect.midX, y: lineRect.midY))
        rightPath.addLine(to: CGPoint(x: lineRect.maxX, y: lineRect.midY))

        return (leftPath, rightPath)
    }
    
    private func calculateAngle() -> CGFloat {
        let lineRect = CGRect(x: bounds.minX + Settings.width/2,
                              y: bounds.minY + Settings.width/2,
                              width: bounds.width - Settings.width,
                              height: bounds.height - Settings.width)
        let w = lineRect.width
        let h = lineRect.height/2
    
        return atan(sqrt(h*h + 0.25*w*w)/w)
    }
    
    public var down: () -> Void {
        return { [weak self] in
            guard let self = self else { return }
            let angle = self.calculateAngle()
          
            self.leftWing.setAffineTransform(CGAffineTransform(rotationAngle: angle))
            self.rightWing.setAffineTransform(CGAffineTransform(rotationAngle: -angle))
        }
    }
    
    public var neutral: () -> Void {
        return { [weak self] in
            guard let self = self else { return }
            
            self.leftWing.setAffineTransform(.identity)
            self.rightWing.setAffineTransform(.identity)
        }
    }
    
    public var up: () -> Void {
        return { [weak self] in
            guard let self = self else { return }
            let angle = self.calculateAngle()
            
            self.leftWing.setAffineTransform(CGAffineTransform(rotationAngle: -angle))
            self.rightWing.setAffineTransform(CGAffineTransform(rotationAngle: angle))
        }
    }
}
