//
//  ContentView.swift
//  MyOrders
//
//  Created by Hadi Alfian Akbar on 10/04/26.
//

import SwiftData
import SwiftUI


struct ContentView: View {
    
    @State private var showingAddOptions = false
    @State private var showingManualForm = false
    @State private var showingPastePage = false
    
    @State private var isPresenting: Bool = false
    
    // Fetch all orders and sort them by deadline
    @Query(sort: \Order.deadline) private var savedOrders: [Order]
    
    // Manager to save and delete data
    @Environment(\.modelContext) private var context
    // To close sheet when done
    //    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                VStack() {
                    // MARK: Header
                    //                    Text("Orders")
                    //                        .font(.largeTitle)
                    //                        .fontWeight(.bold)
                    //                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    if savedOrders.isEmpty {
                        EmptyStateView()
                    } else {
                        OrderListView(savedOrders: savedOrders)
                    }
                    //                  OrderListView(savedOrders: savedOrders)
                    
                }
                //                .padding(.horizontal)
                
                // MARK: Floating Button
                VStack {
                    Spacer()
                    
                    Button {
                        showingAddOptions = true
                        //                        isPresenting = true // 2. Flip the switch!
                    } label: {
                        Text("Add Order")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient(
                                    colors: [Color.primaryButton, Color.primaryButton2],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                                
                            )
                            .foregroundColor(.white)
                            .cornerRadius(30)
                    }
                    .padding(.horizontal)
                    
                    .confirmationDialog("How do you want to add the order?", isPresented: $showingAddOptions, titleVisibility: .visible) {
                        
                        Button("Paste Text") {
                            showingPastePage = true
                        }
                        
                        Button("Fill Form Manually") {
                            showingManualForm = true
                        }
                        
                        Button("Cancel", role: .cancel) { }
                    }
                    
                    // 3. Sheet A: The Manual Form
                    .sheet(isPresented: $showingManualForm) {
                        NavigationStack {
                            OrderFormView()
                        }
                        .modelContext(context)
                    }
                    
                    // 4. Sheet B: The Paste Page
                    .sheet(isPresented: $showingPastePage) {
                        // PasteOrderView already has a NavigationStack inside its code!
                        PasteOrderView()
                            .modelContext(context)
                    }
                    
                    //                    .sheet(isPresented: $isPresenting) {
                    //                        // 4. Wrap the form in a NavigationStack so it gets a top toolbar!
                    //                        NavigationStack {
                    ////                            OrderFormView()
                    //                            PasteOrderView()
                    //                        }
                    //                        .modelContext(context)
                    //
                    //
                    //                    }
                    
                    
                }
            }
            .navigationTitle("Pre-Orders")
            //            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        SettingView()
                            .navigationBarBackButtonHidden(true)// Hides the default back button so our Cancel/Save buttons take over
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
        }
        
    }
}

struct SectionHeader: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.headline)
            .foregroundColor(.gray)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}


struct EmptyStateView: View {
    var body: some View {
        Spacer()
        VStack (spacing: 16) {
            Image(systemName: "list.clipboard")
                .font(.system(size: 40))
                .foregroundColor(.secondary)
            Text("No Order")
                .font(.title2)
                .foregroundColor(.secondary)
                .fontWeight(.bold)
            Text("Start by adding an order")
                .font(.title2)
                .foregroundColor(.secondary)
        }
        Spacer()
    }
}


#Preview {
    ContentView()
        .modelContainer(for:  Order.self)
}
