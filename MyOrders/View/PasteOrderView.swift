//
//  PasteOrderView.swift
//  MyOrders
//
//  Created by Hadi Alfian Akbar on 27/04/26.
//

//
//import SwiftUI
//
//struct PasteOrderView: View {
//    @State var pasteText: String = ""
//    @Environment(\.dismiss) private var dismiss
//    
//    @State private var extractedData: ExtractedOrder? = nil
//    
//    var body: some View {
//        
//        Form {
//            Section(header: Text("Paste Text")) {
//                TextField("Notes (Optional)", text: $pasteText, axis: .vertical)
//                    .lineLimit(3...6)
//            }
//        }
//        .navigationTitle("Paste")
//        .navigationBarTitleDisplayMode(.inline)
//        .toolbar {
//            // native HIG standard: Cancel on the left, Save on the right
//            ToolbarItem(placement: .topBarLeading) {
//                Button("Cancel", role: .cancel) { dismiss() }
//            }
//            
//            ToolbarItem(placement: .topBarTrailing) {
//                Button("Convert") { convertData() }
//                    .fontWeight(.bold)
//            }
//        }
//        .sheet(item: $extractedData) { data in
//                        NavigationStack {
//                            OrderFormView(prefilledData: data)
//                        }
//                    }
//    }
//    func convertData() {
//        let messyText = """
//Nama : Hadi Alfian
//        No. hp : 085487455930
//        Alamat : Kabil, Nongsa
//        Pesanan : 1 pcs Hampers
//        Catatan : Tambah kartu ucapan
//"""
//        
//        let parsedData = HeuristicOrderParser.parse(text: messyText)
//        self.extractedData = parsedData
//        self.showingForm = true
//    }
//}

import SwiftUI

struct PasteOrderView: View {
    @State var pasteText: String = ""
    @Environment(\.dismiss) private var dismiss
    
    // 1. We deleted the showingForm boolean. We only need this one variable now!
    @State private var extractedData: ExtractedOrder? = nil
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Paste Text")) {
                    // UX Tweak: Made the placeholder text more helpful
                    TextField("Paste WhatsApp order here...", text: $pasteText, axis: .vertical)
                        .lineLimit(6...12) // Made it taller so it's easier to paste into!
                }
            }
            .navigationTitle("Paste Order")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel", role: .cancel) { dismiss() }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Convert") { convertData() }
                        .fontWeight(.bold)
                }
            }
            // 2. The Magic Fix!
            // This waits until extractedData has data, then creates a perfectly fresh form.
            .sheet(item: $extractedData) { data in
                NavigationStack {
                    OrderFormView(prefilledData: data, onSaveComplete: {
                        dismiss()
                    })
                }
            }
        }
    }
    
    func convertData() {
        // 3. Make sure they actually pasted something before converting
        guard !pasteText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        // 4. Use the ACTUAL text from the text box, not the hardcoded string!
        let parsedData = HeuristicOrderParser.parse(text: pasteText)
        print(parsedData)
        
        // 5. Assigning this triggers the sheet to open automatically!
        self.extractedData = parsedData
    }
}

#Preview {
    PasteOrderView(pasteText: "tes aja")
}
