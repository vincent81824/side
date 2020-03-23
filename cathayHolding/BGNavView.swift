//
//  BGNavView.swift
//  cathayHolding
//
//  Created by wei on 2020/3/23.
//  Copyright © 2020 orange. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class BGNavView: UIView {

    @IBOutlet weak var title: UILabel?
    @IBOutlet weak var money: UILabel?
    @IBOutlet weak var segment: UISegmentedControl?
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        addXibView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func addXibView() {
        if let view = Bundle(for: BGNavView.self).loadNibNamed("BGNavView", owner: nil, options: nil)?.first as? UIView {
        addSubview(view)
        view.frame = bounds

            }
        }
}

