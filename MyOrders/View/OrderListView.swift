//
//  OrderListView.swift
//  MyOrders
//
//  Created by Hadi Alfian Akbar on 27/04/26.
//

import SwiftUI
import SwiftData

struct OrderListView: View {
    //    @State var isSheetPresented: Bool = false
    @State private var selectedFilter: FilterOption = .all
    @State var selectedOrder: Order? = nil
    
    let savedOrders: [Order]
    
    // Manager to save and delete data
    @Environment(\.modelContext) private var context
    
    
    
    enum FilterOption: String, CaseIterable, Identifiable {
        case all = "All"
        case new = "New"
        case inProgress = "In Progress"
        case done = "Done"
        var id: String { self.rawValue }
    }
    
    var filteredOrders: [Order] {
        switch selectedFilter {
        case .all:
            return savedOrders
        case .new:
            return savedOrders.filter {$0.status == .new}
        case .inProgress:
            return savedOrders.filter {$0.status == .processing}
        case .done:
            return savedOrders.filter {$0.status == .done}
        }
    }
    
    var groupedOrders: [(key: Date, value: [Order])] {
        // 1. Group the orders by stripping away the time (Start of Day)
        let grouped = Dictionary(grouping: filteredOrders) { order in
            Calendar.current.startOfDay(for: order.deadline)
        }
        // 2. Sort the groups so the earliest dates show up first!
        return grouped.sorted {$0.key < $1.key}
    }
    
    var body: some View {
        List {
            // 1. The Picker Header
            VStack {
                Picker("Filter", selection: $selectedFilter) {
                    ForEach(FilterOption.allCases, id: \.self) { option in
                        Text(option.rawValue).tag(option)
                    }
                }
                .pickerStyle(.segmented)
            }
            .listRowBackground(Color.clear) // Keeps your background clean!
            .listRowSeparator(.hidden)      // Removes default iOS list lines
            
            // 2. The Nested Loop
            ForEach(groupedOrders, id: \.key) { dateGroup in
                
                Section(header: SectionHeader(title: formatHeaderDate(dateGroup.key))) {
                    
                    ForEach(dateGroup.value) { order in
                        Button {
                            selectedOrder = order
                        } label: {
                            OrderCard(
                                name: order.customerName,
                                quantity: order.quantity,
                                product: order.product,
                                deadline: order.deadline,
                                status: order.status
                            )
                        }
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                        
                        // 👉 THE MAGIC SWIPE ACTION!
                        .swipeActions(edge: .leading, allowsFullSwipe: true) {
                            
                            // We only show the swipe action if the order is NOT done
                            if order.status == .new {
                                Button {
                                    updateStatusOrder(for: order) // Make sure this matches your function name!
                                } label: {
                                    Label("Process", systemImage: "hammer.fill")
                                }
                                .tint(Color.blueTextStatus) // Your Commerce Teal
                                
                            } else {
                                Button {
                                    updateStatusOrder(for: order)
                                } label: {
                                    Label("Done", systemImage: "checkmark.circle.fill")
                                }
                                .tint(.green)
                            }
                        }
                    }
                }
            }
        }
        .listStyle(.plain) // Removes the default grouped gray background
        .sheet(item: $selectedOrder) { unwrappedOrder in
                        OrderDetailView(order: unwrappedOrder)
                    }
        
//        ScrollView {
//            VStack(spacing: 24) {
//
//                //Picker
//                Picker("Filter", selection: $selectedFilter) {
//                    ForEach(FilterOption.allCases, id: \.self) { option in Text(option.rawValue).tag(option)
//                    }
//                }
//                .pickerStyle(.segmented)
//
//                //nested loop for grouping
//                // loop 1 through date
//                ForEach(groupedOrders, id: \.key) { dateGroup in
//                    VStack(spacing: 16) {
//                        // draw section for specific date
//                        SectionHeader(title: formatHeaderDate(dateGroup.key))
//
//                        // loop through the order that belong to this date
//                        ForEach(dateGroup.value) { order in
//                            Button {
//                                selectedOrder = order
//                            } label: {
//                                OrderCard(
//                                    name: order.customerName,
//                                    quantity: order.quantity,
//                                    product: order.product,
//                                    status: order.status
//                                )
//                            }
//                        }
//                    }
//
//                }
//
//
//            }
//            .sheet(item: $selectedOrder) { unwrappedOrder in
//                OrderDetailView(order: unwrappedOrder)
//            }
//
//        }
//        .padding(.bottom, 40)
        //        .scrollContentBackground(.hidden)
    }
    
    // header formatting date
    func formatHeaderDate(_ date: Date) -> String {
        let calendar = Calendar.current
        
        //check if the day today or tomorrow
        if calendar.isDateInToday(date) {
            return "Today"
        } else if calendar.isDateInTomorrow(date) {
            return "Tomorrow"
        } else {
            // Otherwise, show the full date (e.g., "15 Mei 2026")
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "id_ID") //indonesian
            formatter.dateFormat = "dd MMMM yyyy"
            return formatter.string(from: date)
        }
    }
    
    //Update Status Only
    func updateStatusOrder(for order: Order) {
        if order.status == .new {
            order.status = .processing
        } else if order.status == .processing{
            order.status = .done
        }
        
        try? context.save()
    }
    
    
    //Delete
    func deleteOrder(at offsets: IndexSet) {
        for index in offsets {
            let orderToDelete = savedOrders[index]
            context.delete(orderToDelete)
        }
    }
}

//#Preview {
//    OrderListView()
//}
