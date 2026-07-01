//
//  Item.swift
//  moto46
//
//  Created by Maanas Krishna on 01/07/26.
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
