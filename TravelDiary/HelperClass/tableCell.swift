//
//  tableCell.swift
//  TravelDiary
//
//  Created by Siddhant Mishra on 21/02/19.
//  Copyright © 2019 Siddhant Mishra. All rights reserved.
//

import Foundation
import UIKit

class tableCell: UITableViewCell{
    override var frame: CGRect {
        get {
            return super.frame
        }
        set (newFrame) {
            var frame =  newFrame
            frame.origin.y += 10
            frame.size.height -= 2 * 5
            super.frame = frame
        }
    }
}
