//
//  DataManager.swift
//  MyOrders
//
//  Created by Hadi Alfian Akbar on 21/04/26.
//

import Foundation
import SwiftData

@Model
class Order {
    var id: UUID
    var status: OrderStatus
    var customerName: String
    var product: String
    var quantity: Int
    var phone: String
    var address: String
    var deadline: Date
    var notes: String
    var orderVia: OrderVia
    
    init(id: UUID = UUID(), status: OrderStatus = .new, customerName: String, product: String, quantity: Int, phone: String, address: String, deadline: Date, notes: String, orderVia: OrderVia) {
        self.id = id
        self.status = status
        self.customerName = customerName
        self.product = product
        self.quantity = quantity
        self.phone = phone
        self.address = address
        self.deadline = deadline
        self.notes = notes
        self.orderVia = orderVia
    }
}
