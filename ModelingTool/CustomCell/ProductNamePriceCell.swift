//
//  ProductNamePriceCell.swift
//  ModelingTool
//
//  Created by Lo Fang Chou on 2020/7/1.
//  Copyright © 2020 JStudio. All rights reserved.
//

import Cocoa

protocol ProductNamePriceDelegate: class {
    func updateProductItem(sender: ProductNamePriceCell, category_index: Int, product_index: Int, product: DetailProductItem)
}

class ProductNamePriceCell: NSTableCellView {
    @IBOutlet weak var textProductName: NSTextField!
    @IBOutlet weak var labelItem: NSTextField!
    @IBOutlet weak var labelPrice: NSTextField!
    @IBOutlet weak var textDescription: NSTextField!
    
    var productData: DetailProductItem = DetailProductItem()
    var itemsArray: [NSButton] = [NSButton]()
    var priceArray: [NSTextField] = [NSTextField]()
    var categoryIndex: Int = 0
    var productIndex: Int = 0
    weak var delegate: ProductNamePriceDelegate?
    
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        setupConstraints()
    }
    
    @IBAction func updateProductItem(_ sender: Any) {
        let data = getProductItemData()
        delegate?.updateProductItem(sender: self, category_index: self.categoryIndex, product_index: self.productIndex, product: data)
    }
    
    func setData(item: DetailProductItem) {
        self.itemsArray.removeAll()
        self.priceArray.removeAll()
        
        self.productData = item
        
        setupItem()
    }
    
    func setupItem() {
        for subView in self.subviews {
            if subView.tag == -1 {
                subView.removeFromSuperview()
            }
        }
        
        textProductName.stringValue = self.productData.productName
        textDescription.stringValue = self.productData.productDescription ?? ""
        
        
        let spacing: CGFloat = CGFloat(5.0)
        let width: CGFloat = CGFloat(50.0)
        let height: CGFloat = CGFloat(18.0)
        
        let itemsXOffset = self.labelItem.frame.minX + 15
        let itemsYOffset = self.labelItem.frame.minY
        let priceXOffset = self.labelPrice.frame.minX + 15
        let priceYOffset = self.labelPrice.frame.minY

        for i in 0...self.productData.priceList!.count - 1 {
            let frameItem = NSRect(x: itemsXOffset + width * CGFloat(i) + CGFloat(spacing), y: CGFloat(itemsYOffset), width: width, height: height)

            let itemCheckBox = NSButton(checkboxWithTitle: self.productData.priceList![i].recipeItemName, target: nil, action: nil)
            itemCheckBox.frame = frameItem
            itemCheckBox.tag = -1
            if self.productData.priceList![i].availableFlag {
                itemCheckBox.state = .on
            } else {
                itemCheckBox.state = .off
            }
            
            itemCheckBox.translatesAutoresizingMaskIntoConstraints = false
            self.itemsArray.append(itemCheckBox)
            self.addSubview(itemCheckBox)
            
            let framePrice = NSRect(x: priceXOffset + width * CGFloat(i) + CGFloat(spacing), y: CGFloat(priceYOffset), width: width, height: height)
            let priceTextField = NSTextField(frame: framePrice)
            priceTextField.tag = -1
            priceTextField.translatesAutoresizingMaskIntoConstraints = false

            priceTextField.stringValue = String(self.productData.priceList![i].price)
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

    /*
     var productName: String = ""
     var productCategory: String?
     var productSubCategory: String?
     var productDescription: String?
     var productImageURL: [String]?
     var productBasicPrice: Int = 0
     var recipeRelation: [DetailRecipeRelation]?
     var priceList: [DetailRecipeItemPrice]?
     */
    
    func getProductItemData() -> DetailProductItem{
        self.productData.productName = self.textProductName.stringValue
        self.productData.productDescription = self.textDescription.stringValue
        for i in 0...self.itemsArray.count - 1 {
            if self.itemsArray[i].state == .on {
                self.productData.priceList![i].availableFlag = true
            } else {
                self.productData.priceList![i].availableFlag = false
            }
            
            self.productData.priceList![i].price = Int(self.priceArray[i].stringValue)!
        }
        
        return self.productData
    }
}
