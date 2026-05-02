//
//  OrderFormView.swift
//  MyOrders
//
//  Created by Hadi Alfian Akbar on 23/04/26.
//

import SwiftUI
import SwiftData

struct OrderFormView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    // This will hold our "close everything" command!
        var onSaveComplete: (() -> Void)?
    
    @AppStorage("defaultPreOrderDays") private var defaultPreOrderDays = 7
    
    // variable to check if no order, we are adding it, if there is orde, we are update it
    var orderToEdit: Order?
    
    @State private var showingDeleteAlert = false
    
    // all state variables lives in the main view
    @State var currentStatus: OrderStatus
    @State var custName: String
    @State var product: String
    @State var quantity: Int
    @State var phone: String
    @State var address: String
    @State var deadline: Date
    @State var notes: String
    @State var orderVia: OrderVia
    
    
    
    
    // initializer, this decides if we start with blank text, or the existing order's text
    init(orderToEdit: Order? = nil, prefilledData: ExtractedOrder? = nil, onSaveComplete: (() -> Void)? = nil) {
        
        self.orderToEdit = orderToEdit
        self.onSaveComplete = onSaveComplete
        
        let savedDays = UserDefaults.standard.object(forKey: "defaultPreOrderDays") as? Int ?? 7
        let futureDate = Calendar.current.date(byAdding: .day, value: savedDays, to: Date()) ?? Date()
        
        
        // If orderToEdit has data, use it. Otherwise, use the defaults ("", 0, .new, etc.)
        _currentStatus = State(initialValue: orderToEdit?.status ?? .new)
        _custName = State(initialValue: orderToEdit?.customerName ?? prefilledData?.name ?? "")
        _product = State(initialValue: orderToEdit?.product ?? prefilledData?.product ?? "")
        _quantity = State(initialValue: orderToEdit?.quantity ?? prefilledData?.quantity ?? 1)
        _phone = State(initialValue: orderToEdit?.phone ?? prefilledData?.phone ?? "")
        _address = State(initialValue: orderToEdit?.address ?? prefilledData?.address ?? "")
        _deadline = State(initialValue: orderToEdit?.deadline ?? futureDate)
        _notes = State(initialValue: orderToEdit?.notes ?? prefilledData?.notes ?? "")
        _orderVia = State(initialValue: orderToEdit?.orderVia ?? .whatsapp)
    }
    
    var body: some View {
        // 1. We replace the ZStack/ScrollView with a simple Form!
        Form {
            
            // Only show status picker if we are editing
            if orderToEdit != nil {
                Section {
                    // Inside a form, the Picker automatically becomes a beautiful native row!
                    Picker("Order Status", selection: $currentStatus) {
                        ForEach(OrderStatus.allCases) { status in
                            Text(status.rawValue).tag(status)
                        }
                    }
                }
            }
            
            Section(header: Text("Customer Details")) {
                TextField("Name", text: $custName)
                
                TextField("Phone", text: $phone)
                    .keyboardType(.phonePad)
                
                TextField("Address", text: $address)
                
                Picker("Order Source", selection: $orderVia) {
                    ForEach(OrderVia.allCases) { source in
                        Text(source.rawValue).tag(source)
                    }
                }
                .pickerStyle(.menu)
            }
            
            Section(header: Text("Order Details")) {
                TextField("Product", text: $product)
                
                
                Stepper("Quantity: \(quantity)", value: $quantity, in: 1...100)
                
                DatePicker("Deadline", selection: $deadline, in: Date()...)
            }
            
            Section(header: Text("Additional Notes")) {
                TextField("Notes (Optional)", text: $notes, axis: .vertical)
                    .lineLimit(3...6)
            }
            
            if orderToEdit != nil {
                Section {
                    Button(role: .destructive) {
                        // When tapped, show the warning alert!
                        showingDeleteAlert = true
                    } label: {
                        HStack {
                            Spacer()
                            Text("Delete Order")
                            Spacer()
                        }
                    }
                }
            }
        }
        .navigationTitle(orderToEdit == nil ? "New Order" : "Edit Order")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            // native HIG standard: Cancel on the left, Save on the right
            ToolbarItem(placement: .topBarLeading) {
                Button("Cancel", role: .cancel) { dismiss() }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") { saveAction() }
                    .fontWeight(.bold)
            }
        }
        .alert("Delete Order", isPresented: $showingDeleteAlert) {
            // The Cancel button does nothing but close the alert
            Button("Cancel", role: .cancel) {}
            
            // The Destructive button actually deletes the data
            Button("Delete", role: .destructive) {
                if let orderToDelete = orderToEdit {
                    context.delete(orderToDelete)
                    try? context.save()// Force save to the phone instantly
                    dismiss()
                }
            }
            
        } message: {
            Text("Are you sure you want to delete this order? This action cannot be undone.")
        }
        
        //        Button {
        //             // 2. Flip the switch!
        //        } label: {
        //            Text("Delete Order")
        //                .fontWeight(.semibold)
        //                .frame(maxWidth: .infinity)
        //                .padding()
        //                .background(
        //                    LinearGradient(
        //                        colors: [Color.red],
        //                        startPoint: .leading,
        //                        endPoint: .trailing
        //                    )
        //                )
        //                .foregroundColor(.white)
        //                .cornerRadius(30)
        //        }
        //            .padding()
        
    }
    
    func saveAction() {
        if let order = orderToEdit {
            //Edit Mode
            order.status = currentStatus
            order.customerName = custName
            order.product = product
            order.quantity = quantity
            order.phone = phone
            order.address = address
            order.deadline = deadline
            order.notes = notes
            order.orderVia = orderVia
        } else {
            // Add Mode
            let newOrder = Order(id: UUID(), status: currentStatus, customerName: custName, product: product, quantity: quantity, phone: phone, address: address, deadline: deadline, notes: notes, orderVia: orderVia)
            context.insert(newOrder)
            
        }
        
        // 👉 THE MAGIC DISMISS LOGIC
                if let parentCommand = onSaveComplete {
                    // If the Paste screen opened this, tell the Paste screen to close!
                    parentCommand()
                } else {
                    // Otherwise, just close normally
                    dismiss()
                }
        
        dismiss()
    }
}


#Preview {
    OrderFormView()
}
