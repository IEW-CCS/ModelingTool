//
//  TemplateSequenceCell.swift
//  ModelingTool
//
//  Created by Lo Fang Chou on 2020/7/5.
//  Copyright © 2020 JStudio. All rights reserved.
//

import Cocoa

protocol TemplateSequenceDelegate: class {
    func deleteRecipeTemplate(sender: TemplateSequenceCell, index: Int)
}

class TemplateSequenceCell: NSTableCellView {
    
    var recipeTemplateIndex: Int = 0
    weak var delegate: TemplateSequenceDelegate?
    
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    func setData(index: Int) {
        self.recipeTemplateIndex = index
    }
    
    @IBAction func deleteRecipeTemplate(_ sender: NSButton) {
        delegate?.deleteRecipeTemplate(sender: self, index: self.recipeTemplateIndex)
    }
}
