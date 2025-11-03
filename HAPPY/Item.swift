//
//  Item.swift
//  HAPPY
//
//  Created by 田中悠乃 on 2025/10/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
