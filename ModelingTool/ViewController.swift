//
//  ViewController.swift
//  ModelingTool
//
//  Created by Lo Fang Chou on 2020/6/30.
//  Copyright © 2020 JStudio. All rights reserved.
//

import Cocoa
import Firebase

class ViewController: NSViewController {
    @IBOutlet weak var pr1: NSButton!
    @IBOutlet weak var pr2: NSButton!
    @IBOutlet weak var pr3: NSButton!
    @IBOutlet weak var pr4: NSButton!
    @IBOutlet weak var pr5: NSButton!
    @IBOutlet weak var pr6: NSButton!
    @IBOutlet weak var pr7: NSButton!
    @IBOutlet weak var pr8: NSButton!
    @IBOutlet weak var pr9: NSButton!
    @IBOutlet weak var pr10: NSButton!
    @IBOutlet weak var pp1: NSButton!
    @IBOutlet weak var pp2: NSButton!
    @IBOutlet weak var pp3: NSButton!
    @IBOutlet weak var pp4: NSButton!
    @IBOutlet weak var pp5: NSButton!
    @IBOutlet weak var pp6: NSButton!
    @IBOutlet weak var pp7: NSButton!
    @IBOutlet weak var pp8: NSButton!
    @IBOutlet weak var pp9: NSButton!
    @IBOutlet weak var pp10: NSButton!
    
    @IBOutlet weak var textBrandName: NSTextField!
    @IBOutlet weak var textBrandIconImage: NSTextField!
    @IBOutlet weak var textBrandCategory: NSTextField!
    @IBOutlet weak var textBrandSubCategory: NSTextField!
    @IBOutlet weak var textMenuNumber: NSTextField!
    @IBOutlet weak var textUpdateDateTime: NSTextField!
    @IBOutlet weak var textMenuMenuNumber: NSTextField!
    @IBOutlet weak var textCreateTime: NSTextField!
    @IBOutlet weak var templateNameTableView: NSTableView!
    @IBOutlet weak var templateItemTableView: NSTableView!
    @IBOutlet weak var checkboxMandatory: NSButton!
    @IBOutlet weak var checkboxMulti: NSButton!
    @IBOutlet weak var checkboxAlone: NSButton!
    @IBOutlet weak var recipeTemplateTableView: NSTableView!
    @IBOutlet weak var textCategoryName: NSTextField!
    @IBOutlet weak var textProductCount: NSTextField!
    @IBOutlet weak var productCategoryTableView: NSTableView!
    @IBOutlet weak var productNamePriceTableView: NSTableView!
    @IBOutlet weak var imageIcon: NSImageView!
    

    var templateNameIndex: Int = 0
    var productCategoryIndex: Int = 0
    var productItemIndex: Int = 0
    var templateSequence: Int = 0
    var productDeleteIndex: Int = -1
    var templateItemsState: [Bool] = [Bool]()
    var priceButtonArray: [NSButton] = [NSButton]()
    var productButtonArray: [NSButton] = [NSButton]()
    var recipeTemplates: [DetailRecipeTemplate] = [DetailRecipeTemplate]()
    var productCategory: [DetailProductCategory] = [DetailProductCategory]()
    var menuInfo: DetailMenuInformation = DetailMenuInformation()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.templateItemTableView.delegate = self
        self.templateItemTableView.dataSource = self
        self.templateNameTableView.delegate = self
        self.templateNameTableView.dataSource = self
        self.recipeTemplateTableView.delegate = self
        self.recipeTemplateTableView.dataSource = self
        self.productCategoryTableView.delegate = self
        self.productCategoryTableView.dataSource = self
        self.productNamePriceTableView.delegate = self
        self.productNamePriceTableView.dataSource = self
        
        self.templateItemsState = Array(repeating: true, count: TEMPLATE_ITEMS[self.templateNameIndex].count)
        setupCategoryButtons()
    }

    override var representedObject: Any? {
        didSet {
        }
    }
    
    @IBAction func loadBrandIconImage(_ sender: NSButton) {
        var path: String = ""
        
        let dialog = NSOpenPanel()
        dialog.title = "Open the Menu Information from JSON file"
        dialog.showsResizeIndicator = false
        dialog.showsHiddenFiles = false;
        dialog.allowsMultipleSelection = false;
        dialog.canChooseFiles = true;
        //dialog.canChooseDirectories = true;
        
        if(dialog.runModal() == NSApplication.ModalResponse.OK) {
            let result = dialog.url
            if result != nil {
                path = result!.path
                print("Selected path = \(path)")
            } else {
                return
            }
        }

        let pathUrl = URL(fileURLWithPath: path)
        let imageData = try! Data(contentsOf: pathUrl)

        self.imageIcon.image = NSImage(data: imageData)
    }
    
    @IBAction func generateBrandProfile(_ sender: NSButton) {
        if self.textBrandName.stringValue != "" {
            self.textBrandCategory.stringValue = "茶飲類"
            self.textBrandIconImage.stringValue = "Brand_Image/\(self.textBrandName.stringValue).jpg"
            self.textMenuNumber.stringValue = "\(self.textBrandName.stringValue)_MENU"
            self.textMenuMenuNumber.stringValue = "\(self.textBrandName.stringValue)_MENU"
            let formatter = DateFormatter()
            formatter.dateFormat = DATETIME_FORMATTER
            let nowString = formatter.string(from: Date())
            self.textUpdateDateTime.stringValue = nowString
            self.textCreateTime.stringValue = nowString
        }
    }
    
    @IBAction func addRecipeTemplate(_ sender: NSButton) {
        var template: DetailRecipeTemplate = DetailRecipeTemplate()
        var items: [DetailRecipeItem] = [DetailRecipeItem]()
        
        self.templateSequence = self.templateSequence + 1
        template.templateSequence = self.templateSequence
        template.templateName = TEMPLATE_NAMES[self.templateNameIndex]
        if self.checkboxMandatory.state == .on {
            template.mandatoryFlag = true
        } else {
            template.mandatoryFlag = false
        }
        if self.checkboxMulti.state == .on {
            template.allowMultiSelectionFlag = true
        } else {
            template.allowMultiSelectionFlag = false
        }
        if self.checkboxAlone.state == .on {
            template.standAloneProduct = true
        } else {
            template.standAloneProduct = false
        }
        
        for i in 0...TEMPLATE_ITEMS[self.templateNameIndex].count - 1 {
            var item: DetailRecipeItem = DetailRecipeItem()
            if self.templateItemsState[i] {
                item.itemName = TEMPLATE_ITEMS[self.templateNameIndex][i]
                item.itemSequence = i + 1
                items.append(item)
            }
        }

        template.recipeList = items
        self.recipeTemplates.append(template)
        self.recipeTemplateTableView.reloadData()
        configCategoryButtons()
    }
    
    func setupCategoryButtons() {
        self.priceButtonArray.append(pr1)
        self.priceButtonArray.append(pr2)
        self.priceButtonArray.append(pr3)
        self.priceButtonArray.append(pr4)
        self.priceButtonArray.append(pr5)
        self.priceButtonArray.append(pr6)
        self.priceButtonArray.append(pr7)
        self.priceButtonArray.append(pr8)
        self.priceButtonArray.append(pr9)
        self.priceButtonArray.append(pr10)
        self.productButtonArray.append(pp1)
        self.productButtonArray.append(pp2)
        self.productButtonArray.append(pp3)
        self.productButtonArray.append(pp4)
        self.productButtonArray.append(pp5)
        self.productButtonArray.append(pp6)
        self.productButtonArray.append(pp7)
        self.productButtonArray.append(pp8)
        self.productButtonArray.append(pp9)
        self.productButtonArray.append(pp10)
    }
    
    func configCategoryButtons() {
        for i in 0...self.priceButtonArray.count - 1 {
            self.priceButtonArray[i].isHidden = true
            self.priceButtonArray[i].state = .off
            self.priceButtonArray[i].isEnabled = false
        }
        for i in 0...self.recipeTemplates.count - 1 {
            self.priceButtonArray[i].isEnabled = true
            self.priceButtonArray[i].isHidden = false
        }
        
        for i in 0...self.productButtonArray.count - 1 {
            self.productButtonArray[i].isHidden = true
            self.productButtonArray[i].state = .off
            self.productButtonArray[i].isEnabled = false
        }
        for i in 0...self.recipeTemplates.count - 1 {
            self.productButtonArray[i].isEnabled = true
            self.productButtonArray[i].state = .on
            self.productButtonArray[i].isHidden = false
        }
    }
    
    @IBAction func openFromFile(_ openMenuItem: NSMenuItem) {
        print("View Controller: Clicked Open From File ...")
        var path: String = ""
        
        let dialog = NSOpenPanel()
        dialog.title = "Open the Menu Information from JSON file"
        dialog.showsResizeIndicator = false
        dialog.showsHiddenFiles = false;
        dialog.allowsMultipleSelection = false;
        dialog.canChooseFiles = true;
        //dialog.canChooseDirectories = true;
        
        if(dialog.runModal() == NSApplication.ModalResponse.OK) {
            let result = dialog.url
            if result != nil {
                path = result!.path
                print("Selected path = \(path)")
            } else {
                return
            }
        }

        let pathUrl = URL(fileURLWithPath: path)
        let jsonData = try! Data(contentsOf: pathUrl)
        let decoder = JSONDecoder()
        
        do {
            self.menuInfo =  try decoder.decode(DetailMenuInformation.self, from: jsonData)
            //print("detailMenuInformation = \(self.menuInfo)")
        }
        catch {
            print("Failed to read JSON data: \(error.localizedDescription)")
        }

        self.recipeTemplates = self.menuInfo.recipeTemplates!
        self.productCategory = self.menuInfo.productCategory!
        
        self.textBrandName.stringValue = self.menuInfo.brandName
        self.textBrandCategory.stringValue = "茶飲類"
        self.textBrandIconImage.stringValue = "Brand_Image/\(self.textBrandName.stringValue).png"
        self.textMenuNumber.stringValue = "\(self.textBrandName.stringValue)_MENU"
        self.textMenuMenuNumber.stringValue = "\(self.textBrandName.stringValue)_MENU"
        //let formatter = DateFormatter()
        //formatter.dateFormat = DATETIME_FORMATTER
        //let nowString = formatter.string(from: Date())
        self.textUpdateDateTime.stringValue = self.menuInfo.createTime
        self.textCreateTime.stringValue =  self.menuInfo.createTime
        configCategoryButtons()
        self.productCategoryIndex = 0
        self.productItemIndex = 0
        let lastIndex = self.menuInfo.recipeTemplates!.count - 1
        self.templateSequence = self.menuInfo.recipeTemplates![lastIndex].templateSequence

        self.recipeTemplateTableView.reloadData()
        self.productCategoryTableView.reloadData()
        self.productNamePriceTableView.reloadData()
    }

    @IBAction func getUpdatedRecipeTemplate(_ sender: NSButton) {
        updateRecipeTemplates()
    }
    
    func updateRecipeTemplates() {
        if self.recipeTemplates.isEmpty {
            return
        }
        
        for i in 0...self.recipeTemplates.count - 1 {
            let cell = self.recipeTemplateTableView.view(atColumn: 2, row: i, makeIfNecessary: true) as! RecipeTemplateCell
            var data = cell.getTemplateData()
            let cellName = self.recipeTemplateTableView.view(atColumn: 1, row: i, makeIfNecessary: true) as! RecipeNameCell
            let name = cellName.getData()
            data.templateName = name
            //print("recipeTemplateData = \(data)")
            self.recipeTemplates[i] = data
        }
    }
    
    @IBAction func addProductCategory(_ sender: NSButton) {
        var category: DetailProductCategory = DetailProductCategory()
        var priceTemplate: DetailRecipeTemplate = DetailRecipeTemplate()
        var priceTemplateIndex: Int = -1
        var productCount: Int = 0
        
        updateRecipeTemplates()
        
        if self.textCategoryName.stringValue == "" || self.textProductCount.stringValue == "" {
            print("Category Name or Product Count error, hust return")
            return
        }
        
        category.categoryName = self.textCategoryName.stringValue
        for i in 0...self.priceButtonArray.count - 1 {
            if self.priceButtonArray[i].state == .on {
                priceTemplateIndex = i
                break
            }
        }
        if priceTemplateIndex == -1 {
            print("Price template not assigned, just return")
            return
        }
        
        priceTemplate = self.recipeTemplates[priceTemplateIndex]
        category.priceTemplate = priceTemplate

        productCount = Int(self.textProductCount.stringValue)!
        category.productItems = [DetailProductItem]()
        for _ in 0...productCount - 1 {
            var item: DetailProductItem = DetailProductItem()

            item.productCategory = self.textCategoryName.stringValue
            item.priceList = [DetailRecipeItemPrice]()
            for j in 0...priceTemplate.recipeList.count - 1 {
                var price: DetailRecipeItemPrice = DetailRecipeItemPrice()
                price.recipeItemName = priceTemplate.recipeList[j].itemName
                price.availableFlag = true
                price.price = 0
                item.priceList?.append(price)
            }
            
            var isRelationExist: Bool = false
            for k in 0...self.productButtonArray.count - 1 {
                if self.productButtonArray[k].state == .on {
                    isRelationExist = true
                    break
                }
            }
            if isRelationExist {
                item.recipeRelation = [DetailRecipeRelation]()
                for k in 0...self.productButtonArray.count - 1 {
                    if self.productButtonArray[k].state == .on {
                        var relation: DetailRecipeRelation = DetailRecipeRelation()
                        relation.templateSequence = self.recipeTemplates[k].templateSequence
                        relation.itemRelation = Array(repeating: true, count: self.recipeTemplates[k].recipeList.count)
                        item.recipeRelation!.append(relation)
                    }
                }
            }
            category.productItems!.append(item)
        }
        
        self.productCategory.append(category)
        self.productCategoryTableView.reloadData()
        self.productNamePriceTableView.reloadData()
    }
    
    func getRecipeTemplateName(sequence_no: [Int]) -> [String] {
        var nameString: [String] = [String]()
        
        for i in 0...sequence_no.count - 1 {
            for j in 0...self.recipeTemplates.count - 1 {
                if self.recipeTemplates[j].templateSequence == sequence_no[i] {
                    nameString.append(self.recipeTemplates[j].templateName)
                    break
                }

            }
        }
        
        return nameString
    }
    
    func getRecipeTemplateItemsName(sequence_no: [Int]) -> [[String]] {
        var nameString: [[String]] = [[String]]()
        
        for i in 0...sequence_no.count - 1 {
            for j in 0...self.recipeTemplates.count - 1 {
                if self.recipeTemplates[j].templateSequence == sequence_no[i] {
                    var tmp: [String] = [String]()
                    for k in 0...self.recipeTemplates[j].recipeList.count - 1 {
                        tmp.append(self.recipeTemplates[j].recipeList[k].itemName)
                    }
                    nameString.append(tmp)
                    break
                }
            }
        }
        
        return nameString
    }
    
    @IBAction func uploadDataToFirebase(_ sender: NSButton) {
        var brandCategory: DetailBrandCategory = DetailBrandCategory()
        var brandProfile: DetailBrandProfile = DetailBrandProfile()

        if self.textBrandName.stringValue == "" {
            print("Brand Name is empty, not uploading information to Firebase, just return")
            _ = dialogInformation(title: "Error", message: "Brand Name CONNOT be blank")
            return
        }
        
        if self.imageIcon.image == nil {
            print("Brand Image is nil, not uploading information to Firebase, just return")
            _ = dialogInformation(title: "Error", message: "Brand Icon Image CONNOT be blank")
            return
        }

        if self.textMenuNumber.stringValue == "" {
            print("Menu Number is empty, not uploading information to Firebase, just return")
            _ = dialogInformation(title: "Error", message: "Menu Number CONNOT be blank")
            return
        }

        brandCategory.brandName = self.textBrandName.stringValue
        brandCategory.brandIconImage = self.textBrandIconImage.stringValue
        brandCategory.brandCategory = self.textBrandCategory.stringValue
        brandCategory.brandSubCategory = self.textBrandSubCategory.stringValue
        brandCategory.updateDateTime = self.textUpdateDateTime.stringValue

        uploadFBBrandCategory(brand_name: brandCategory.brandName, brand_category: brandCategory)

        brandProfile.brandName = self.textBrandName.stringValue
        brandProfile.brandIconImage = self.textBrandIconImage.stringValue
        brandProfile.brandCategory = self.textBrandCategory.stringValue
        brandProfile.brandSubCategory = self.textBrandSubCategory.stringValue
        brandProfile.menuNumber = self.textMenuNumber.stringValue
        brandProfile.updateDateTime = self.textUpdateDateTime.stringValue

        uploadFBDetailBrandProfile(brand_name: brandProfile.brandName, brand_profile: brandProfile)

        self.menuInfo.brandName = self.textBrandName.stringValue
        self.menuInfo.menuNumber = self.textMenuNumber.stringValue
        self.menuInfo.createTime = self.textCreateTime.stringValue
        self.menuInfo.recipeTemplates = self.recipeTemplates
        self.menuInfo.productCategory = [DetailProductCategory]()
        self.menuInfo.productCategory = self.productCategory
        
        uploadFBDetailMenuInformation(menu_number: self.menuInfo.menuNumber, menu_info: self.menuInfo)
        
        uploadFBBrandIconImage(brand_name: self.menuInfo.brandName, image: self.imageIcon.image!)
    }
    
    
    @IBAction func createMenuJSONFile(_ sender: NSButton) {
        var path: String = ""

        if self.textBrandName.stringValue == "" {
            print("Brand Name is empty, not uploading information to Firebase, just return")
            _ = dialogInformation(title: "Error", message: "Brand Name CONNOT be blank")
            return
        }

        self.menuInfo.brandName = self.textBrandName.stringValue
        self.menuInfo.menuNumber = self.textMenuNumber.stringValue
        self.menuInfo.createTime = self.textCreateTime.stringValue
        self.menuInfo.recipeTemplates = self.recipeTemplates
        self.menuInfo.productCategory = [DetailProductCategory]()
        self.menuInfo.productCategory = self.productCategory

        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        if let encodedData = try? encoder.encode(self.menuInfo) {
            //let path = "\(NSHomeDirectory())/\(self.menuInfo.menuNumber).json"
            
            //let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            //let documentsDirectory = paths[0]
            //print("paths = \(paths)")

            let dialog = NSOpenPanel()
            dialog.title = "Save the Menu Information into JSON file"
            dialog.showsResizeIndicator = false
            dialog.showsHiddenFiles = false;
            dialog.allowsMultipleSelection = false;
            dialog.canChooseFiles = false;
            dialog.canChooseDirectories = true;
            
            if(dialog.runModal() == NSApplication.ModalResponse.OK) {
                let result = dialog.url
                if result != nil {
                    path = result!.path
                    print("Selected path = \(path)")
                } else {
                    return
                }
            }
            
            //let file_path = path + "/\(self.menuInfo.menuNumber).json"
            let file_path = path + "/\(self.menuInfo.brandName)_DETAIL_MENU_INFORMATION.json"
            
            let pathAsURL = URL(fileURLWithPath: file_path)
            do {
                try encodedData.write(to: pathAsURL)
            }
            catch {
                print("Failed to write [\(self.menuInfo.brandName)] DETAIL_MENU_INFORMATION JSON data: \(error.localizedDescription)")
            }
        }
        
        createBrandCategoryJSONFile(path: path, name: self.menuInfo.brandName)
        createBrandProfileJSONFile(path: path, name: self.menuInfo.brandName)
    }
    
    func createBrandCategoryJSONFile(path: String, name: String) {
        var brandCategory: DetailBrandCategory = DetailBrandCategory()
        if self.textBrandName.stringValue == "" {
            print("Brand Name is empty, not creating Brand Category JSON file, just return")
            return
        }
        
        brandCategory.brandName = self.textBrandName.stringValue
        brandCategory.brandIconImage = self.textBrandIconImage.stringValue
        brandCategory.brandCategory = self.textBrandCategory.stringValue
        brandCategory.brandSubCategory = self.textBrandSubCategory.stringValue
        brandCategory.updateDateTime = self.textUpdateDateTime.stringValue
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        if let encodedData = try? encoder.encode(brandCategory) {
            let file_path = path + "/\(name)_BRAND_CATEGORY.json"
            let pathAsURL = URL(fileURLWithPath: file_path)
            do {
                try encodedData.write(to: pathAsURL)
            }
            catch {
                print("Failed to write [\(name)] BRAND CATEGORY JSON data: \(error.localizedDescription)")
            }
        }
    }

    func createBrandProfileJSONFile(path: String, name: String) {
        var brandProfile: DetailBrandProfile = DetailBrandProfile()
        if self.textBrandName.stringValue == "" {
            print("Brand Name is empty, not creating Brand Profile JSON file, just return")
            return
        }

        brandProfile.brandName = self.textBrandName.stringValue
        brandProfile.brandIconImage = self.textBrandIconImage.stringValue
        brandProfile.brandCategory = self.textBrandCategory.stringValue
        brandProfile.brandSubCategory = self.textBrandSubCategory.stringValue
        brandProfile.menuNumber = self.textMenuNumber.stringValue
        brandProfile.updateDateTime = self.textUpdateDateTime.stringValue
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        if let encodedData = try? encoder.encode(brandProfile) {
            let file_path = path + "/\(name)_DETAIL_BRAND_PROFILE.json"
            let pathAsURL = URL(fileURLWithPath: file_path)
            do {
                try encodedData.write(to: pathAsURL)
            }
            catch {
                print("Failed to write [\(name)] BRAND PROFILE JSON data: \(error.localizedDescription)")
            }
        }
    }

    @IBAction func addProductItem(_ sender: NSButton) {
        var priceTemplate: DetailRecipeTemplate = DetailRecipeTemplate()
        var priceTemplateIndex: Int = -1

        updateRecipeTemplates()
        
        if self.textCategoryName.stringValue == "" || self.textProductCount.stringValue == "" {
            print("Category Name or Product Count error, hust return")
            return
        }
        
        for i in 0...self.priceButtonArray.count - 1 {
            if self.priceButtonArray[i].state == .on {
                priceTemplateIndex = i
                break
            }
        }
        if priceTemplateIndex == -1 {
            print("Price template not assigned, just return")
            return
        }
        
        priceTemplate = self.recipeTemplates[priceTemplateIndex]

        var item: DetailProductItem = DetailProductItem()

        item.productCategory = self.textCategoryName.stringValue
        item.priceList = [DetailRecipeItemPrice]()
        for j in 0...priceTemplate.recipeList.count - 1 {
            var price: DetailRecipeItemPrice = DetailRecipeItemPrice()
            price.recipeItemName = priceTemplate.recipeList[j].itemName
            price.availableFlag = true
            price.price = 0
            item.priceList?.append(price)
        }
        
        var isRelationExist: Bool = false
        for k in 0...self.productButtonArray.count - 1 {
            if self.productButtonArray[k].state == .on {
                isRelationExist = true
                break
            }
        }
        if isRelationExist {
            item.recipeRelation = [DetailRecipeRelation]()
            for k in 0...self.productButtonArray.count - 1 {
                if self.productButtonArray[k].state == .on {
                    var relation: DetailRecipeRelation = DetailRecipeRelation()
                    relation.templateSequence = self.recipeTemplates[k].templateSequence
                    relation.itemRelation = Array(repeating: true, count: self.recipeTemplates[k].recipeList.count)
                    item.recipeRelation!.append(relation)
                }
            }
        }
        self.productCategory[self.productCategoryIndex].productItems!.append(item)
        self.productNamePriceTableView.reloadData()
    }
    
    @IBAction func deleteProductItem(_ sender: NSButton) {
        print("Delete the selected product category index: \(self.productCategoryIndex)")
        print("Delete the selected product iten index: \(self.productItemIndex)")
        self.productDeleteIndex = self.productItemIndex
        self.productCategory[self.productCategoryIndex].productItems!.remove(at: self.productDeleteIndex)
        self.productItemIndex = 0
        self.productNamePriceTableView.reloadData()
    }
    
}

extension ViewController: NSTableViewDelegate, NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        if tableView == self.templateNameTableView {
            return TEMPLATE_NAMES.count
        }
        
        if tableView == self.templateItemTableView {
            return TEMPLATE_ITEMS[self.templateNameIndex].count
        }

        if tableView == self.recipeTemplateTableView {
            if self.recipeTemplates.isEmpty {
                return 0
            } else {
                return self.recipeTemplates.count
            }
        }
        
        if tableView == self.productCategoryTableView {
            if self.productCategory.isEmpty {
                return 0
            } else {
                return self.productCategory.count
            }
        }
        
        if tableView == self.productNamePriceTableView {
            if self.productCategory.isEmpty {
                return 0
            }
            
            if self.productCategory[self.productCategoryIndex].productItems == nil {
                return 0
            }
            
            if self.productCategory[self.productCategoryIndex].productItems!.isEmpty {
                return 0
            } else {
                return self.productCategory[self.productCategoryIndex].productItems!.count
            }
        }
        
        return 0
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if tableView == self.templateNameTableView {
            if tableColumn?.identifier.rawValue == "templateNameColumn" {
                let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "templateNameCell")
                guard let cellView = tableView.makeView(withIdentifier: cellIdentifier, owner: self) as? NSTableCellView else { return nil }
                cellView.textField?.stringValue = TEMPLATE_NAMES[row]
                return cellView
            }
            
            return nil
        }
        
        if tableView == self.templateItemTableView {
            if tableColumn?.identifier.rawValue == "templateItemColumn" {
                let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "TemplateItemCell")
                guard let cellView = tableView.makeView(withIdentifier: cellIdentifier, owner: self) as? TemplateItemCell else { return nil }
                cellView.checkboxItem.state = .on
                cellView.checkboxItem.title = TEMPLATE_ITEMS[self.templateNameIndex][row]
                cellView.stateIndex = row
                cellView.delegate = self
                return cellView
            }
            
            return nil
        }

        
        if tableView == self.recipeTemplateTableView {
            if tableColumn?.identifier.rawValue == "addedTemplateSequenceColumn" {
                let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "addedTemplateSequenceCell")
                //guard let cellView = tableView.makeView(withIdentifier: cellIdentifier, owner: self) as? NSTableCellView else { return nil }
                guard let cellView = tableView.makeView(withIdentifier: cellIdentifier, owner: self) as? TemplateSequenceCell else { return nil }
                cellView.textField?.stringValue = String(self.recipeTemplates[row].templateSequence)
                cellView.setData(index: row)
                cellView.delegate = self
                return cellView
            } else if tableColumn?.identifier.rawValue == "addedTemplateNameColumn" {
                let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "RecipeNameCell")
                //guard let cellView = tableView.makeView(withIdentifier: cellIdentifier, owner: self) as? NSTableCellView else { return nil }
                guard let cellView = tableView.makeView(withIdentifier: cellIdentifier, owner: self) as? RecipeNameCell else
                { return nil }
                //cellView.textField?.stringValue = self.recipeTemplates[row].templateName
                cellView.setData(name: self.recipeTemplates[row].templateName)
                return cellView
            } else {
                let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "RecipeTemplateCell")
                guard let cellView = tableView.makeView(withIdentifier: cellIdentifier, owner: self) as? RecipeTemplateCell else { return nil }
                //cellView.textField?.stringValue = String(self.recipeTemplates[row].templateSequence)
                cellView.setData(item: self.recipeTemplates[row])
                return cellView
            }
        }
        
        if tableView == self.productCategoryTableView {
            if tableColumn?.identifier.rawValue == "productCategoryColumn" {
                let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "productCategoryCell")
                guard let cellView = tableView.makeView(withIdentifier: cellIdentifier, owner: self) as? NSTableCellView else { return nil }
                cellView.textField?.stringValue = String(self.productCategory[row].categoryName)
                return cellView
            }
        }

        if tableView == self.productNamePriceTableView {
            if tableColumn?.identifier.rawValue == "productNamePriceColumn" {
                let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "ProductNamePriceCell")
                guard let cellView = tableView.makeView(withIdentifier: cellIdentifier, owner: self) as? ProductNamePriceCell else { return nil }
                //cellView.textField?.stringValue = String(self.productCategory[row].categoryName)
                cellView.delegate = self
                cellView.productIndex = row
                cellView.setData(item: self.productCategory[self.productCategoryIndex].productItems![row])
                return cellView

            }
            
            if tableColumn?.identifier.rawValue == "recipeItemsColumn" {
                if self.productCategory[self.productCategoryIndex].productItems![self.productItemIndex].recipeRelation == nil {
                    return nil
                }
                
                let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "RecipeItemsCell")
                
                guard let cellView = tableView.makeView(withIdentifier: cellIdentifier, owner: self) as? RecipeItemsCell else { return nil }
                var seq_array: [Int] = [Int]()
                for i in 0...self.self.productCategory[self.productCategoryIndex].productItems![self.productItemIndex].recipeRelation!.count - 1 {
                    let seq_no = self.productCategory[self.productCategoryIndex].productItems![self.productItemIndex].recipeRelation![i].templateSequence
                    seq_array.append(seq_no)
                }
                let templateName = self.getRecipeTemplateName(sequence_no: seq_array)
                let templateItemsName = self.getRecipeTemplateItemsName(sequence_no: seq_array)
                cellView.setData(template_name: templateName, item_name: templateItemsName, item: self.productCategory[self.productCategoryIndex].productItems![row].recipeRelation!)
                return cellView
            }
        }
        
        return nil
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        guard let table = notification.object as? NSTableView else {
            return
        }
        
        if table == self.templateNameTableView {
            self.templateNameIndex = table.selectedRow
            self.templateItemsState.removeAll()
            self.templateItemsState = Array(repeating: true, count: TEMPLATE_ITEMS[self.templateNameIndex].count)
            self.templateItemTableView.reloadData()
        }
        
        if table == self.productCategoryTableView {
            self.productCategoryIndex = table.selectedRow
            self.productItemIndex = 0
            self.productNamePriceTableView.reloadData()
        }
        
        if table == self.productNamePriceTableView {
            //print("self.productNamePriceTableView -> tableViewSelectionDidChange")
            //print("self.productNamePriceTableView -> self.productItemIndex = \(self.productItemIndex)")
            //print("self.productNamePriceTableView -> table.selectedRow = \(table.selectedRow)")
            self.productItemIndex = table.selectedRow
        }
    }
        
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        if tableView == self.recipeTemplateTableView {
            return 55
        }
        
        if tableView == self.productNamePriceTableView {
            return 100
        }
        
        
        return 17
    }
}

extension ViewController: TemplateItemDelegate {
    func updateTemplateItemState(sender: TemplateItemCell, index: Int, state: Bool) {
        self.templateItemsState[index] = state
    }
}

extension ViewController: ProductNamePriceDelegate {
    func updateProductItem(sender: ProductNamePriceCell, category_index: Int, product_index: Int, product: DetailProductItem) {
        print("updateProductItem for category: [\(category_index)], product item: [\(product_index)]")
        var data = product
        
        let cell = self.productNamePriceTableView.view(atColumn: 1, row: product_index, makeIfNecessary: true) as! RecipeItemsCell
        data.recipeRelation! = cell.getRecipeRelation()

        self.productCategory[self.productCategoryIndex].productItems![self.productItemIndex] = data
    }
}

extension ViewController: TemplateSequenceDelegate {
    func deleteRecipeTemplate(sender: TemplateSequenceCell, index: Int) {
        self.recipeTemplates.remove(at: index)
        //if !self.recipeTemplates.isEmpty {
        //    for i in 0...self.recipeTemplates.count - 1 {
        //        self.recipeTemplates[i].templateSequence = i + 1
        //    }
        //}
        
        self.recipeTemplateTableView.reloadData()
    }
}
