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
        static var angleCoefficient: CGFloat = 42.5714286
        static var color = UIColor.lightGray
    }
    
    var direction: Direction = .up {
        didSet {
            animatableLayer.path = ChevronView.preparePath(for: direction, in: bounds).cgPath
        }
    }
    let animatableLayer = CAShapeLayer()
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
        animatableLayer.path = ChevronView.preparePath(for: direction, in: bounds).cgPath
        animatableLayer.strokeColor = Settings.color.cgColor
        animatableLayer.fillColor = Settings.color.cgColor
        animatableLayer.lineWidth = Settings.width
        animatableLayer.lineCap = kCALineCapRound
        self.layer.addSublayer(animatableLayer)
    }
    
    private static func preparePath(for direction: Direction, in rect: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        let lineRect = CGRect(x: rect.minX + Settings.width/2,
                              y: rect.minY + Settings.width/2,
                              width: rect.width - Settings.width,
                              height: rect.height - Settings.width)
        
        
        switch  direction {
        case .neutral:
            path.move(to: CGPoint(x: lineRect.minX, y: lineRect.midY))
            path.addLine(to: CGPoint(x: lineRect.maxX, y: lineRect.midY))
        case .down:
            path.move(to: CGPoint(x: lineRect.minX, y: lineRect.midY))
            path.addLine(to: CGPoint(x: lineRect.midX, y: lineRect.minY))
            path.move(to: CGPoint(x: lineRect.midX, y: lineRect.minY))
            path.addLine(to: CGPoint(x: lineRect.maxX, y: lineRect.midY))
        case .up:
            path.move(to: CGPoint(x: lineRect.minX, y: lineRect.midY))
            path.addLine(to: CGPoint(x: lineRect.midX, y: lineRect.maxY))
            path.move(to: CGPoint(x: lineRect.midX, y: lineRect.maxY))
            path.addLine(to: CGPoint(x: lineRect.maxX, y: lineRect.midY))
        }
        
        return path
    }
    
    public var cancelAnimation: () -> Void {
        return { [weak self] in
            guard let self = self else { return }
            let animation = CABasicAnimation(keyPath: "path")
            animation.toValue = ChevronView.preparePath(for: .up, in: self.bounds)
            self.animatableLayer.add(animation, forKey: nil)
        }
    }
    
    public func finishAnimation() -> () -> Void {
        return { [weak self] in
            guard let self = self else { return }
            let animation = CABasicAnimation(keyPath: "path")
            animation.fromValue = ChevronView.preparePath(for: self.direction, in: self.bounds).cgPath
            animation.toValue = ChevronView.preparePath(for: self.direction == .up ? .down : .up, in: self.bounds).cgPath
            animation.duration = 0.2
            self.animatableLayer.add(animation, forKey: nil)
            self.direction = self.direction == .up ? .down : .up
        }
    }
    
    enum Direction {
        case up
        case down
        case neutral
    }
}
