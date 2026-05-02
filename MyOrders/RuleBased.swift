//
//  RuleBased.swift
//  MyOrders
//
//  Created by Hadi Alfian Akbar on 27/04/26.
//

import Foundation

//structure to hold the extracted data before sending it to your form
struct ExtractedOrder: Identifiable {
    var id = UUID()
    var name: String = ""
    var phone: String = ""
    var address: String = ""
    var product: String = ""
    var quantity: Int = 1
    var notes: String = ""
}

struct HeuristicOrderParser {
    static func parse(text: String) -> ExtractedOrder {
        var result = ExtractedOrder()
        let lines = text.components(separatedBy: .newlines)
        
        //1. Extract phone number using regex
        //scans the whole text, regardless of where the phone number is place
        if let phoneMatch = text.range(of: "(08|62)[0-9]{8,12}", options: .regularExpression) {
            result.phone = String(text[phoneMatch])
        }
        
        for line in lines {
            let lowerLine = line.lowercased()
            
            //2. keyword hunter for name
            if lowerLine.contains("nama") || lowerLine.contains("pemesan") {
                result.name = cleanExtractedValue(from: line, removing: ["nama", "pemesan"])
            }
            
            if lowerLine.contains("notes") || lowerLine.contains("catatan") {
                result.notes = cleanExtractedValue(from: line, removing: ["notes", "catatan"])
            }
            
            //3. keyword hunter for address
            else if lowerLine.contains("alamat") || lowerLine.contains("kirim ke") {
                result.address = cleanExtractedValue(from: line, removing: ["alamat","kirim ke"])
            }
            
            //4. keyword hunter & quantity regex for product
            else if lowerLine.contains("pesanan") || lowerLine.contains("order") || lowerLine.contains("pesen") {
                //first, grab the whole product text
                let rawProduct = cleanExtractedValue(from: line, removing:["pesanan","order","pesen"])
                result.product = rawProduct
                
                //then use regex to see if they included a quantity like "2x" or "3 pcs"
                if let qtyMatch = rawProduct.range(of: "[0-9]+\\s*(x|pcs|buah)", options: .regularExpression) {
                    let qtyText = String(rawProduct[qtyMatch])
                    //extract just the number from that match
                    let numbersOnly = qtyText.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
                    result.quantity = Int(numbersOnly) ?? 1
                    
                    //Optional: clean the 2x out of the product name, so it just says "Hampers"
                    result.product = rawProduct.replacingOccurrences(of: qtyText, with: "").trimmingCharacters(in: .whitespaces)
                }
            }
        }
        return result
    }
    
    // MARK: - Helper Function to clean up the text
        // This removes the keyword, and strips away annoying colons or dashes!
    
    private static func cleanExtractedValue(from line: String, removing keywords: [String]) -> String {
        var cleaned = line
        
        //remove the keyword itself (case insensitive)
        for keyword in keywords {
            if let range = cleaned.range(of: keyword, options: .caseInsensitive) {
                cleaned.removeSubrange(range)
            }
        }
        
        //remove left-over colons, dashes, or equeal signs at the start
        cleaned = cleaned.trimmingCharacters(in: .whitespaces)
        while cleaned.hasPrefix(":") || cleaned.hasPrefix("-") || cleaned.hasPrefix("=") {
            cleaned.removeFirst()
            cleaned = cleaned.trimmingCharacters(in: .whitespaces)
        }
        
        return cleaned
    }
}
