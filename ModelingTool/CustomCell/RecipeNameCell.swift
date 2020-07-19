//
//  RecipeNameCell.swift
//  ModelingTool
//
//  Created by Lo Fang Chou on 2020/7/18.
//  Copyright © 2020 JStudio. All rights reserved.
//

import Cocoa

class RecipeNameCell: NSTableCellView {

    @IBOutlet weak var textRecipeName: NSTextField!
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
    func setData(name: String) {
        self.textRecipeName.stringValue = name
    }
    
    func getData() -> String {
        return self.textRecipeName.stringValue
    }
}
