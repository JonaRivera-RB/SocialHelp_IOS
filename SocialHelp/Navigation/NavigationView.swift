
//  Copyright © 2019 Misael Rivera. All rights reserved.
//

import UIKit

class NavigationView: UIView {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        return view == self ? nil : view
    }
}
