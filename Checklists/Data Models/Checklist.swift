//
//  Checklist.swift
//  Checklists
//
//  Created by Theon.PAN on 2021/9/18.
//

import UIKit

class Checklist: NSObject, Codable {
    var name = ""
    var iconName = "No Icon"
    var items = [ChecklistItem]()
    
    init(name: String, iconName: String = "No Icon"){
        self.name = name
        self.iconName = iconName
        super.init()
    }
    
    func countUncheckedItems() -> Int {
        return items.reduce(0){
            cnt, item in cnt + (item.checked ? 0 : 1)
        }
    }

}
