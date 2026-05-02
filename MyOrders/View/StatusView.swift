//
//  StatusView.swift
//  MyOrders
//
//  Created by Hadi Alfian Akbar on 16/04/26.
//

import SwiftUI
import Foundation

enum OrderVia: String, Codable, CaseIterable, Identifiable {
    case whatsapp = "Whatsapp"
    case instagram = "Instagram"
    case other = "Other"
    var id: String { self.rawValue }
}

// 1. Pull the enum out and rename it so it makes sense globally
enum OrderStatus: String, Codable, CaseIterable, Identifiable {
    case new = "New"
    case done = "Done"
    case processing = "In Progress"
    var id: String { self.rawValue }
}

struct StatusView: View {
    let status: OrderStatus
    var body: some View {
        switch status {
        case .done:
            Text("Done")
                .font(.footnote)
                .fontWeight(.semibold)
                .foregroundColor(Color.greenTextStatus)
                .frame(height: 20)
                .padding(.horizontal)
                .background(Color.greenStatusBg)
                .cornerRadius(5)
            
        case .processing:
            Text("In Progress")
                .font(.footnote)
                .fontWeight(.semibold)
                .foregroundColor(Color.blueTextStatus)
                .frame(height: 20)
                .padding(.horizontal)
                .background(Color.blueStatusBg)
                .cornerRadius(5)
            
        case .new:
            Text("New")
                .font(.footnote)
                .fontWeight(.semibold)
                .foregroundColor(Color.yellowTextStatus)
                .frame(height: 20)
                .padding(.horizontal)
                .background(Color.yellowStatusBg)
                .cornerRadius(5)
        }
    }
}

#Preview {
    StatusView(status: .done)
    StatusView(status: .new)
    StatusView(status: .processing)
}
