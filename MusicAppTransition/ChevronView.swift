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
    
    override func draw(_ rect: CGRect) {
        backgroundColor = .clear
        let path = preparePath(for: .up, in: rect)
        path.stroke()
        path.fill()
    }
 
    private func preparePath(for direction: Direction, in rect: CGRect) -> UIBezierPath {
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
        
        path.lineWidth = Settings.width
        path.lineCapStyle = .round
        Settings.color.setStroke()
        Settings.color.setFill()
        return path
    }
    
    public func cancel() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "path")
        animation.toValue = preparePath(for: .up, in: self.bounds)
        return animation
    }
    
    public func finish(for direction: Direction) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "path")
        animation.toValue = preparePath(for: direction == .up ? .down : .up, in: self.bounds)
        return animation
    }
    
    public func inMid() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "path")
        animation.toValue = preparePath(for: .neutral, in: self.bounds)
        return animation
    }
    
    enum Direction {
        case up
        case down
        case neutral
    }
}
