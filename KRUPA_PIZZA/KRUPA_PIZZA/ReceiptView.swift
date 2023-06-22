//
//  ReceiptView.swift
//  KRUPA_PIZZA
//
//  Created by Sam 77 on 2023-06-05.
//

import SwiftUI

enum PizzaType {
    case vegetarian
    case nonVegetarian
    
    var description: String {
        switch self {
        case .vegetarian:
            return "Vegetarian"
        case .nonVegetarian:
            return "Non-Vegetarian"
        }
    }
}

enum PizzaSize {
    case small
    case medium
    case large
    
    func getPrice(for type: PizzaType) -> Double {
        switch self {
        case .small:
            return type == .vegetarian ? 5.99 : 6.99
        case .medium:
            return type == .vegetarian ? 7.99 : 8.99
        case .large:
            return type == .vegetarian ? 10.99 : 12.99
        }
    }
    
    var description: String {
        switch self {
        case .small:
            return "Small"
        case .medium:
            return "Medium"
        case .large:
            return "Large"
        }
    }
}

struct ReceiptView: View {
    let order: PizzaOrder
    
    private var subtotal: Double {
        let pizzaPrice = order.pizzaType == .vegetarian ? order.pizzaSize.getPrice(for: .vegetarian) : order.pizzaSize.getPrice(for: .nonVegetarian)
        return Double(order.quantity) * pizzaPrice
    }
    
    private var taxAmount: Double {
        return subtotal * 0.13
    }
    
    private var finalCost: Double {
        return subtotal + taxAmount
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Receipt")
                .font(.title)
                .fontWeight(.bold)
            
            Divider()
            
            VStack(alignment: .leading, spacing: 5) {
                ReceiptItem(title: "Phone", value: order.phoneNumber)
                ReceiptItem(title: "Pizza Size", value: order.pizzaSize.description)
                ReceiptItem(title: "Pizza Type", value: order.pizzaType.description)
                ReceiptItem(title: "Quantity", value: "\(order.quantity)")
                ReceiptItem(title: "Coupon Applied", value: order.couponCode.isEmpty ? "No" : "Yes")
            }
            
            Divider()
            
            HStack {
                Spacer()
                Text("Subtotal:")
                Spacer()
                Text("$\(String(format: "%.2f", subtotal))")
            }
            
            HStack {
                Spacer()
                Text("Tax (13%):")
                Spacer()
                Text("$\(String(format: "%.2f", taxAmount))")
            }
            
            Divider()
            
            HStack {
                Spacer()
                Text("Final Cost:")
                    .font(.headline)
                    .fontWeight(.bold)
                Spacer()
                Text("$\(String(format: "%.2f", finalCost))")
                    .font(.headline)
                    .fontWeight(.bold)
            }
            
            Spacer()
        }
        .padding()
    }
}

struct ReceiptItem: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
            Spacer()
            Text(value)
                .font(.subheadline)
        }
    }
}


struct ReceiptView_Previews: PreviewProvider {
    static var previews: some View {
        ReceiptView(order: PizzaOrder(pizzaType: .vegetarian, pizzaSize: .medium, quantity: 2, phoneNumber: "1234567890", couponCode: "OFFER123"))
    }
}

struct PizzaOrder {
    var pizzaType: PizzaType
    var pizzaSize: PizzaSize
    var quantity: Int
    var phoneNumber: String
    var couponCode: String
}
