//
//  MenuPercentDrivenInteractiveTransition+Gestures.swift
//  HamburgerMenu
//
//  Created by lynx on 02/09/2018.
//  Copyright © 2018 Gulnaz. All rights reserved.
//

import UIKit

extension VerticalInteractiveTransition{
    func update(for gesture: UIPanGestureRecognizer, in view: UIView, andBeginAction action: (()->Void)?){
        let translation = gesture.translation(in: view)
        
        var progress: CGFloat = abs(translation.y/(view.bounds.height/3))
        progress = min(max(progress, 0.01), 0.99)
        switch gesture.state {
        case .began:
            action?()
        case .changed:
            self.update(progress)
        case .cancelled:
            self.cancel()
        case .ended:
            if self.shouldFinish{
                self.finish()
            }else{
                self.cancel()
            }
        default:
            break
        }
    }
}
