//
//  OrderCard.swift
//  MyOrders
//
//  Created by Hadi Alfian Akbar on 27/04/26.
//

import SwiftUI

struct OrderCard: View {
    let name: String
    let quantity: Int
    let product: String
    let deadline: Date
    let status: OrderStatus
    var body: some View {
        HStack {
            
            VStack(alignment: .leading, spacing: 6) {
                Text(name)
                    .font(.headline)
                    .foregroundColor(Color.black)
                
                Text("\(quantity) x \(product)")
                    .foregroundColor(.gray)
                    .font(.subheadline)
                HStack {
                    Image(systemName: "clock")
                        .font(.caption)
                        .foregroundColor(.gray)// Swapped the calendar icon for a clock!
                        
                        // This automatically respects the user's phone settings (12h vs 24h)
                    Text(formatTimeOnly(deadline))
                        .font(.caption)
                        .foregroundColor(.gray)
                    StatusView(status: status)
                }
                
            }
            
            Spacer()
            
            // Status Icon
            Image(systemName: "chevron.right")
                .foregroundStyle(Color.gray)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
    }
    
    func formatTimeOnly(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm" // 'HH' forces 24-hour time, 'mm' is minutes
        return formatter.string(from: date)
    }
}

#Preview {
    OrderCard(name: "Hadi Alfian", quantity: 2, product: "Hampers",deadline: Date(), status: .new)
}
