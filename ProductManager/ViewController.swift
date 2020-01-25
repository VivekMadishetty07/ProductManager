//
//  ViewController.swift
//  ProductManager
//
//  Created by Vivek Madishetty on 2020-01-24.
//  Copyright © 2020 Vivek Madishetty. All rights reserved.
//

import UIKit
import CoreData

 class ViewController: UIViewController {

     var product: [Product]?
   
     @IBOutlet var textFields: [UITextField]!
     override func viewDidLoad() {
         super.viewDidLoad()
         // Do any additional setup after loading the view.
 //        loadData()
         loadCoreData()
         
 //        NotificationCenter.default.addObserver(self, selector: #selector(saveData), name: UIApplication.willResignActiveNotification, object: nil)
         
         NotificationCenter.default.addObserver(self, selector: #selector(saveCoreData), name: UIApplication.willResignActiveNotification, object: nil)
     }
     
     func getFilePath() -> String {
         let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
         if documentPath.count > 0 {
             let documentDirectory = documentPath[0]
             let filePath = documentDirectory.appending("/product.txt")
             return filePath
         }
         return ""
     }
     
     func loadData() {
         let filePath = getFilePath()
         product = [Product]()
         if FileManager.default.fileExists(atPath: filePath) {
             do {
                 // extract data
                 let fileContents = try String(contentsOfFile: filePath)
                 let contentArray = fileContents.components(separatedBy: "\n")
                 for content in contentArray {
                     let productInfo = content.components(separatedBy: ",")
                     if productInfo.count == 4 {
                        let products = Product(ID: productInfo[0], Price: Int(productInfo[1])!, Description: productInfo[2], Name: productInfo[3])
                         product?.append(products)
                     }
                 }
             } catch {
                 print(error)
             }
         }
     }

     @IBAction func addBook(_ sender: UIBarButtonItem) {
         let id = textFields[0].text ?? ""
         let price =  Int(textFields[1].text ?? "0") ?? 0
         let description = textFields[2].text ?? ""
         let name = textFields[3].text ?? ""
         
        let products = Product(ID: id, Price: price, Description: description, Name: name)
         product?.append(products)
         
         for textField in textFields {
             textField.text = ""
             textField.resignFirstResponder()
         }
     }
     
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if let ProductTable = segue.destination as? productsTableViewController {
             ProductTable.product = self.product
         }
     }
     
     @objc func saveData() {
         let filePath = getFilePath()
         var savePath = ""
         for items in product! {
             savePath = "\(savePath)\(items.ID),\(items.Price),\(items.Description),\(items.Name)\n"
         }
         // write to path
         do {
             try savePath.write(toFile: filePath, atomically: true, encoding: .utf8)
         } catch {
             print(error)
         }
     }
     
     @objc func saveCoreData() {
         // call clear core data
         clearCoreData()
         // create an instance of app delegate
         let appDelegate = UIApplication.shared.delegate as! AppDelegate
         // second step is context
         let managedContext = appDelegate.persistentContainer.viewContext
         
         for items in product! {
             let ProductEntity = NSEntityDescription.insertNewObject(forEntityName: "Products", into: managedContext)
             ProductEntity.setValue(items.ID, forKey: "productID")
             ProductEntity.setValue(items.Price, forKey: "productPrice")
             ProductEntity.setValue(items.Name, forKey: "productName")
             ProductEntity.setValue(items.Description, forKey: "productDescription")
             
             // save context
             do {
                 try managedContext.save()
             } catch {
                 print(error)
             }
         }
     }
     
     func loadCoreData() {
         product = [Product]()
         // create an instance of app delegate
         let appDelegate = UIApplication.shared.delegate as! AppDelegate
         // second step is context
         let managedContext = appDelegate.persistentContainer.viewContext
         
         let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ProductModel")
         
         do {
             let results = try managedContext.fetch(fetchRequest)
             if results is [NSManagedObject] {
                 for result in results as! [NSManagedObject] {
                     let id = result.value(forKey: "productID") as! String
                     let price = result.value(forKey: "productPrice") as! Int
                     let description = result.value(forKey: "productDescription") as! String
                     let name = result.value(forKey: "productName") as! String
                     
                    product?.append(Product(ID: id, Price: price, Description: description, Name: name))
                 }
             }
         } catch {
             print(error)
         }
         
     }
     
     func clearCoreData() {
         // create an instance of app delegate
         let appDelegate = UIApplication.shared.delegate as! AppDelegate
         // second step is context
         let managedContext = appDelegate.persistentContainer.viewContext
         // create a fetch request
         let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ProductModel")
         
         fetchRequest.returnsObjectsAsFaults = false
         
         do {
             let results = try managedContext.fetch(fetchRequest)
             for managedObjects in results {
                 if let managedObjectData = managedObjects as? NSManagedObject {
                     managedContext.delete(managedObjectData)
                 }
             }
         } catch {
             print(error)
         }
         
     }
     
 }
    



