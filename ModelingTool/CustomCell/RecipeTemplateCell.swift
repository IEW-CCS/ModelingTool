//
//  RecipeTemplateCell.swift
//  ModelingTool
//
//  Created by Lo Fang Chou on 2020/7/1.
//  Copyright © 2020 JStudio. All rights reserved.
//

import Cocoa

protocol RecipeTemplateDelegate: class {
    func updateRecipeTemplate(sender: RecipeTemplateCell, index: Int, template: DetailRecipeTemplate)
}

class RecipeTemplateCell: NSTableCellView {
    @IBOutlet weak var checkboxMandatory: NSButton!
    @IBOutlet weak var checkboxMulti: NSButton!
    @IBOutlet weak var checkboxStandAlone: NSButton!
    @IBOutlet weak var labelItem: NSTextField!
    @IBOutlet weak var labelPrice: NSTextField!
    
    var templateIndex: Int = 0
    
    var templateData: DetailRecipeTemplate = DetailRecipeTemplate()
    let MAX_ITEM_NUMBER: Int = 12
    var itemsArray: [NSTextField] = [NSTextField]()
    var priceArray: [NSTextField] = [NSTextField]()
    weak var delegate: RecipeTemplateDelegate?
        
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        setupConstraints()
    }
    
    func setData(item: DetailRecipeTemplate) {
        self.itemsArray.removeAll()
        self.priceArray.removeAll()
        
        self.templateData = item
        if item.mandatoryFlag {
            self.checkboxMandatory.state = .on
        } else {
            self.checkboxMandatory.state = .off
        }

        if item.allowMultiSelectionFlag {
            self.checkboxMulti.state = .on
        } else {
            self.checkboxMulti.state = .off
        }

        if item.standAloneProduct {
            self.checkboxStandAlone.state = .on
        } else {
            self.checkboxStandAlone.state = .off
        }
        
        setupItem()
    }
    
    func setupItem() {
        for subView in self.subviews {
            if subView.tag == -1 {
                subView.removeFromSuperview()
            }
        }
        
        let spacing = 10.0
        let itemsXOffset = self.labelItem.frame.minX + 32.0
        let itemsYOffset = self.labelItem.frame.minY
        let priceXOffset = self.labelPrice.frame.minX + 32.0
        let priceYOffset = self.labelPrice.frame.minY
        
        let width: CGFloat = 50.0
        let height: CGFloat = 20.0
        
        //for i in 0...self.templateData.recipeList.count - 1 {
        for i in 0...MAX_ITEM_NUMBER - 1 {
            let frameItem = NSRect(x: itemsXOffset + width * CGFloat(i) + CGFloat(spacing), y: CGFloat(itemsYOffset), width: width, height: height)
            let itemTextField = NSTextField(frame: frameItem)
            itemTextField.tag = -1
            itemTextField.translatesAutoresizingMaskIntoConstraints = false
            
            if i < self.templateData.recipeList.count {
                itemTextField.stringValue = self.templateData.recipeList[i].itemName
            }
            
            itemTextField.isBordered = true
            itemTextField.layer?.borderWidth = 0.5
            itemTextField.layer?.borderColor = .white
            itemTextField.layer?.cornerRadius = 3
            self.itemsArray.append(itemTextField)
            self.addSubview(itemTextField)

            let framePrice = NSRect(x: priceXOffset + width * CGFloat(i) + CGFloat(spacing), y: CGFloat(priceYOffset), width: width, height: height)
            let priceTextField = NSTextField(frame: framePrice)
            priceTextField.tag = -1
            priceTextField.translatesAutoresizingMaskIntoConstraints = false
            
            if i < self.templateData.recipeList.count {
                priceTextField.stringValue = String(self.templateData.recipeList[i].optionalPrice)
            }

            priceTextField.isBordered = true
            priceTextField.layer?.borderWidth = 0.5
            priceTextField.layer?.borderColor = .white
            priceTextField.layer?.cornerRadius = 3
            self.priceArray.append(priceTextField)
            self.addSubview(priceTextField)
        }
    }
    
    func setupConstraints() {
        for i in 0...self.itemsArray.count - 1 {
            self.itemsArray[i].centerYAnchor.constraint(equalTo: self.labelItem.centerYAnchor).isActive = true
        }

        for i in 0...self.priceArray.count - 1 {
            self.priceArray[i].centerYAnchor.constraint(equalTo: self.labelPrice.centerYAnchor).isActive = true
        }
    }
    
    func getTemplateData() -> DetailRecipeTemplate {
        if self.checkboxMandatory.state == .on {
            self.templateData.mandatoryFlag = true
        } else {
            self.templateData.mandatoryFlag = false
        }

        if self.checkboxMulti.state == .on {
            self.templateData.allowMultiSelectionFlag = true
        } else {
            self.templateData.allowMultiSelectionFlag = false
        }

        if self.checkboxStandAlone.state == .on {
            self.templateData.standAloneProduct = true
        } else {
            self.templateData.standAloneProduct = false
        }
        
        self.templateData.recipeList.removeAll()
        var seq_no: Int = 0
        for i in 0...MAX_ITEM_NUMBER - 1 {
            if self.itemsArray[i].stringValue != "" {
                seq_no = seq_no + 1
                var item: DetailRecipeItem = DetailRecipeItem()
                item.itemCheckedFlag = false
                item.itemName = self.itemsArray[i].stringValue
                item.itemSequence = seq_no
                if self.priceArray[i].stringValue == "" {
                    item.optionalPrice = 0
                } else {
                    item.optionalPrice = Int(self.priceArray[i].stringValue)!
                }
                
                self.templateData.recipeList.append(item)
            }
        }
        
        return self.templateData
    }
}
