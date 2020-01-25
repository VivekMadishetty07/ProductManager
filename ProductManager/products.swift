//
//  products.swift
//  ProductManager
//
//  Created by Vivek Madishetty on 2020-01-24.
//  Copyright © 2020 Vivek Madishetty. All rights reserved.
//

import Foundation

class Product{
    internal init(ID: String, Price: Int, Description: String, Name: String) {
        self.ID = ID
        self.Price = Price
        self.Description = Description
        self.Name = Name
    }
    
    var ID:String
    var Price:Int
    var Description:String
    var Name:String
}
