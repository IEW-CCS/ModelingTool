//
//  TemplateItemCell.swift
//  ModelingTool
//
//  Created by Lo Fang Chou on 2020/7/1.
//  Copyright © 2020 JStudio. All rights reserved.
//

import Cocoa

protocol TemplateItemDelegate: class {
    func updateTemplateItemState(sender: TemplateItemCell, index: Int, state: Bool)
}

class TemplateItemCell: NSTableCellView {
    @IBOutlet weak var checkboxItem: NSButton!
    weak var delegate: TemplateItemDelegate?
    var stateIndex: Int = 0
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

    }
    
    @IBAction func changeState(_ sender: NSButton) {
        var state: Bool = false
        if self.checkboxItem.state == .on {
            state = true
        } else {
            state = false
        }
        
        self.delegate?.updateTemplateItemState(sender: self, index: self.stateIndex, state: state)
    }
}
