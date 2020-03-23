//
//  NewNavView.swift
//  cathayHolding
//
//  Created by wei on 2020/3/23.
//  Copyright © 2020 orange. All rights reserved.
//

import Foundation
import UIKit
@IBDesignable class NewNavView: UIView {

    @IBOutlet weak var newNavTitle: UILabel?
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        addXibView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func addXibView() {
        if let view = Bundle(for: NewNavView.self).loadNibNamed("NewNavView", owner: nil, options: nil)?.first as? UIView {
        addSubview(view)
        view.frame = bounds

            }
        }
}
