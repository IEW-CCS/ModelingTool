//
//  RecipeItemsCell.swift
//  ModelingTool
//
//  Created by Lo Fang Chou on 2020/7/2.
//  Copyright © 2020 JStudio. All rights reserved.
//

import Cocoa

class RecipeItemsCell: NSTableCellView {
    
    var itemsData: [DetailRecipeRelation] = [DetailRecipeRelation]()
    var templateName: [String] = [String]()
    var itemsName: [[String]] = [[String]]()
    var itemsArray: [[NSButton]] = [[NSButton]]()
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
    }
    
    func setData(template_name: [String], item_name: [[String]], item: [DetailRecipeRelation]) {
        //print("RecipeItemsCell template name: \(template_name), item name: \(item_name)")
        self.itemsArray.removeAll()
        
        self.itemsData = item
        self.templateName = template_name
        self.itemsName = item_name
        
        setupItem()
    }
    
    func setupItem() {
        for subView in self.subviews {
           if subView.tag == -1 {
               subView.removeFromSuperview()
           }
        }
        
        let spacing: CGFloat = CGFloat(5.0)
        let width: CGFloat = CGFloat(75.0)
        let height: CGFloat = CGFloat(18.0)
        let nameWidth: CGFloat = CGFloat(75.0)
        
        let viewFrame = self.frame
        let itemsXOffset: CGFloat = CGFloat(5.0)
        let itemsYOffset: CGFloat = CGFloat(viewFrame.maxY - CGFloat(5.0) - height)
        
        for i in 0...self.templateName.count - 1 {
            let nameFrame = NSRect(x: itemsXOffset, y: CGFloat(itemsYOffset - CGFloat(i) * height - spacing * CGFloat(i)), width: width, height: height)
            let textName = NSTextField(frame: nameFrame)
            textName.stringValue = self.templateName[i]
            textName.tag = -1
            textName.isEditable = false
            textName.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(textName)
            
            var tmpArray: [NSButton] = [NSButton]()
            for j in 0...self.itemsName[i].count - 1 {
                let itemFrame = NSRect(x: itemsXOffset + nameWidth + CGFloat(j) * width, y: CGFloat(itemsYOffset - CGFloat(i) * height - spacing * CGFloat(i)), width: width, height: height)
                let itemCheckBox = NSButton(checkboxWithTitle: self.itemsName[i][j], target: nil, action: nil)
                itemCheckBox.frame = itemFrame
                itemCheckBox.tag = -1
                itemCheckBox.state = .off
                if self.itemsData[i].itemRelation[j] {
                    itemCheckBox.state = .on
                } else {
                    itemCheckBox.state = .off
                }
                tmpArray.append(itemCheckBox)
                self.addSubview(itemCheckBox)
            }
            self.itemsArray.append(tmpArray)
        }
    }
    
    func getRecipeRelation() -> [DetailRecipeRelation] {
        var indexArray: [Int] = [Int]()
        for i in 0...self.itemsArray.count - 1 {
            var isFound: Bool = false
            for j in 0...self.itemsArray[i].count - 1 {
                if self.self.itemsArray[i][j].state == .on {
                    self.itemsData[i].itemRelation[j] = true
                    isFound = true
                } else {
                    self.itemsData[i].itemRelation[j] = false
                }
            }
            
            if isFound {
                indexArray.append(i)
            }
        }
        
        var returnData: [DetailRecipeRelation] = [DetailRecipeRelation]()
        if !indexArray.isEmpty {
            for k in 0...indexArray.count - 1 {
                returnData.append(self.itemsData[indexArray[k]])
            }
        }
        //return self.itemsData
        return returnData
    }
}
