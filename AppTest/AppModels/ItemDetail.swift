//
//  ItemDetail.swift
//  AppTest
//
//  Created by macvillanda on 30/01/2020.
//  Copyright © 2020 macvillanda. All rights reserved.
//

import Foundation
import Unrealm

struct ItemDetail: Realmable {
    var selectedItemResult: ItemResult = ItemResult()
    var identifier = "ItemDetail"
    static func primaryKey() -> String? {
        return "identifier"
    }
}

extension ItemDetail {
    init(result: ItemResult) {
        selectedItemResult = result
    }
}
