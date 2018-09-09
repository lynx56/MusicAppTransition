//
//  MenuInteractiveTransition
//  HamburgerMenu
//
//  Created by lynx on 02/09/2018.
//  Copyright © 2018 Gulnaz. All rights reserved.
//

import UIKit

class VerticalInteractiveTransition: UIPercentDrivenInteractiveTransition{
    var maxHeight: CGFloat = 0
    var shouldFinish: Bool{
        return self.percentComplete > 0.3
    }
    
    var subscribers: [InteractiveViewDelegate] = []
    
    override func update(_ percentComplete: CGFloat) {
        super.update(percentComplete)
        
        subscribers.forEach { $0.update(percentComplete) }
    }
    
    override func cancel() {
        super.cancel()
        subscribers.forEach { $0.cancel() }
    }
}

protocol InteractiveViewDelegate: class{
    func update(_ percentComplete: CGFloat)
    func cancel()
}
