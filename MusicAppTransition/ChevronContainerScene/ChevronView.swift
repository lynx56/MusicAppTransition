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
  
    var leftWing: CAShapeLayer?
    var rightWing: CAShapeLayer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addLayers()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addLayers()
    }
   
    func addLayers() {
        backgroundColor = .clear
        updateLayers()
    }
    
    func updateLayers() {
        layer.sublayers?.removeAll()
        leftWing = layer(from: CGPoint(x: layerRect.minX, y: layerRect.midY),
                         to: CGPoint(x: layerRect.midX, y: layerRect.midY))
        rightWing = layer(from: CGPoint(x: layerRect.midX, y: layerRect.midY),
                          to: CGPoint(x: layerRect.maxX, y: layerRect.midY))
        layer.addSublayer(leftWing!)
        layer.addSublayer(rightWing!)
    }
    
    private var layerRect: CGRect {
        return CGRect(x: bounds.minX + Settings.width/2,
                      y: bounds.minY + Settings.width/2,
                      width: bounds.width - Settings.width,
                      height: bounds.height - Settings.width)
    }
    
    private var angle: CGFloat {
        let w = layerRect.width
        let h = layerRect.height/2
        
        return atan(sqrt(h*h + 0.25*w*w)/w)
    }
    
    private func layer(from startPoint: CGPoint, to endPoint: CGPoint) -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.frame = bounds
        layer.strokeColor = Settings.color.cgColor
        layer.fillColor = Settings.color.cgColor
        layer.lineWidth = Settings.width
        layer.lineCap = kCALineCapRound

        let bezier = UIBezierPath()
        bezier.move(to: startPoint)
        bezier.addLine(to: endPoint)
        
        layer.path = bezier.cgPath
        return layer
    }

    public var down: () -> Void {
        return { [weak self] in
            guard let self = self, let leftWing = self.leftWing, let rightWing = self.rightWing else { return }
            let angle = self.angle
            leftWing.setAffineTransform(CGAffineTransform(rotationAngle: angle))
            rightWing.setAffineTransform(CGAffineTransform(rotationAngle: -angle))
        }
    }
    
    public var neutral: () -> Void {
        return { [weak self] in
            guard let self = self, let leftWing = self.leftWing, let rightWing = self.rightWing else { return }
            leftWing.setAffineTransform(.identity)
            rightWing.setAffineTransform(.identity)
        }
    }
    
    public var up: () -> Void {
        return { [weak self] in
            guard let self = self, let leftWing = self.leftWing, let rightWing = self.rightWing else { return }
            let angle = self.angle
            leftWing.setAffineTransform(CGAffineTransform(rotationAngle: -angle))
            rightWing.setAffineTransform(CGAffineTransform(rotationAngle: angle))
        }
    }
}
