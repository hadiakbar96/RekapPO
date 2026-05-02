//
//  OrderDetailView.swift
//  MyOrders
//
//  Created by Hadi Alfian Akbar on 15/04/26.
//

import SwiftUI
import SwiftData

struct OrderDetailView: View {
    let order: Order
//    @Binding var isSheetPresented: Bool
    // To close sheet when done
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                VStack (alignment: .leading, spacing: 30) {
                    HStack {
                        VStack (alignment: .leading, spacing: 10) {
                            Text("Status")
                            Text("Due date")
                            Text("Source")
                        }
                        .padding(.horizontal)
                        .foregroundColor(.secondary)
                        VStack (alignment: .leading, spacing: 10) {
                            StatusView(status: order.status)
                            Text(formatExactDate(order.deadline))
//                            Text(order.deadline, style: .date)
                            Text(order.orderVia.rawValue)
                        }
                        .padding(.leading)
                        Spacer()
                    }
                    .padding(.vertical)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .strokeBorder(Color.gray.secondary, lineWidth: 2)
                    )
                    
                    
                    VStack (alignment: .leading){
                        Text("Customer Details")
                            .fontWeight(.medium)
                            .font(.title3)
                            .foregroundColor(.secondary)
                            .padding([.horizontal, .bottom])
                        HStack (alignment: .top) {
                            VStack (alignment: .leading, spacing: 10) {
                                Text("Name")
                                Text("Phone")
                                Text("Address")
                            }
                            .foregroundColor(.secondary)
                            VStack (alignment: .leading, spacing: 10) {
                                Text(order.customerName)
                                Text(order.phone)
                                Text(order.address)
                            }
                            .padding(.leading, 36)
                            Spacer()
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .strokeBorder(Color.gray.secondary, lineWidth: 2))
                    
                    VStack (alignment: .leading){
                        Text("Product Details")
                            .fontWeight(.medium)
                            .font(.title3)
                            .foregroundColor(.secondary)
                            .padding([.horizontal, .bottom])
                        HStack (alignment: .top) {
                            VStack (alignment: .leading, spacing: 10) {
                                Text("Items")
                                Text("Notes")
                            }
                            .foregroundColor(.secondary)
                            VStack (alignment: .leading, spacing: 10) {
                                Text("\(order.quantity) x \(order.product)")
                                Text(order.notes)
                            }
                            .padding(.leading, 55)
                            Spacer()
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .strokeBorder(Color.gray.secondary, lineWidth: 2))
                    Spacer()
                }
                .padding()
                .navigationTitle("Order Detail")
                .toolbar {
                    // Dismiss Button on the Left
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Dismiss", systemImage: "xmark") {
//                            isSheetPresented = false
                            dismiss()
                        }
                    }
                    
                    // Edit Button on the Right
                    ToolbarItem(placement: .topBarTrailing) {
                        NavigationLink(destination: OrderFormView(orderToEdit: order)) {
                            Text("Edit")
                                .fontWeight(.semibold)
                        }
                    }
                }
            }
        }
        
        
        
        
        
    }
    // Date formatter
    func formatExactDate(_ date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd MMM yyyy HH:mm"
            return formatter.string(from: date)
        }
}

#Preview {
    let ex: Order = Order(id: UUID(), customerName: "Hadi Alfian", product: "Cake", quantity: 2, phone: "123413221", address: "Batam", deadline: Date(), notes: "tes", orderVia: .whatsapp)
    OrderDetailView(order: ex)
}
