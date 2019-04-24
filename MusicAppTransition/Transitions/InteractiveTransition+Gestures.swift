//
//  MenuPercentDrivenInteractiveTransition+Gestures.swift
//  HamburgerMenu
//
//  Created by lynx on 02/09/2018.
//  Copyright © 2018 Gulnaz. All rights reserved.
//

import UIKit

extension UIPercentDrivenInteractiveTransition{
    func update(for gesture: UIPanGestureRecognizer, in view: UIView, andBeginAction action: (()->Void)?){
        guard let view = gesture.view?.superview
            else { assertionFailure("Invalid view"); return }
        
        let translation = gesture.translation(in: view)
        
        var progress: CGFloat = translation.y/view.bounds.height
        progress = min(max(progress, 0.01), 0.99)
        switch gesture.state {
        case .began:
            action?()
            self.update(progress)
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

extension UIPercentDrivenInteractiveTransition {
    var shouldFinish: Bool { return percentComplete > 0.5 }
}
