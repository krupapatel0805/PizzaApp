//
//  ContentView.swift
//  KRUPA_PIZZA
//
//  Created by Sam 77 on 2023-06-05.
//

import SwiftUI

struct ContentView: View {
    @State private var pizzaType = PizzaType.nonVegetarian
    @State private var pizzaSize = PizzaSize.medium
    @State private var quantity = 1
    @State private var phoneNumber = ""
    @State private var couponCode = ""
    @State private var showReceipt = false
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationView {
            VStack {
                Text("KRUPA PIZZA")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 50)
                
                Image("pizzaImage")
                    .resizable()
                    .frame(width: 200, height: 200)
                
                Picker("Pizza Type", selection: $pizzaType) {
                    Text("Vegetarian").tag(PizzaType.vegetarian)
                    Text("Non-Vegetarian").tag(PizzaType.nonVegetarian)
                }
                .pickerStyle(SegmentedPickerStyle())
                
                Picker("Pizza Size", selection: $pizzaSize) {
                    Text("Small").tag(PizzaSize.small)
                    Text("Medium").tag(PizzaSize.medium)
                    Text("Large").tag(PizzaSize.large)
                }
                .pickerStyle(SegmentedPickerStyle())
                
                Stepper("Quantity: \(quantity)", value: $quantity, in: 1...5)
                
                TextField("Phone Number", text: $phoneNumber)
                    .keyboardType(.numberPad)
                
                TextField("Coupon Code", text: $couponCode)
                    .keyboardType(.default)
                
                Button("PLACE ORDER") {
                    if validateOrder() {
                        showReceipt = true
                    } else {
                        showErrorAlert = true
                    }
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.green)
                .cornerRadius(10)
                .padding(.top, 20)
            }
            .padding()
            .alert(isPresented: $showErrorAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text(errorMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
            .background(
                NavigationLink(
                    destination: ReceiptView(order: createPizzaOrder()),
                    isActive: $showReceipt,
                    label: { EmptyView() }
                )
                .hidden()
            )
        }
    }
    
    private func validateOrder() -> Bool {
        guard !phoneNumber.isEmpty else {
            errorMessage = "Please enter your phone number."
            return false
        }
        
        if !couponCode.isEmpty {
            if !isValidCouponCode(couponCode) {
                errorMessage = "Invalid coupon code. Please try again."
                return false
            }
        }
        
        return true
    }
    
    private func isValidCouponCode(_ code: String) -> Bool {
        return code.hasPrefix("OFFER")
    }
    
    private func createPizzaOrder() -> PizzaOrder {
        return PizzaOrder(
            pizzaType: pizzaType,
            pizzaSize: pizzaSize,
            quantity: quantity,
            phoneNumber: phoneNumber,
            couponCode: couponCode
        )
    }
}
