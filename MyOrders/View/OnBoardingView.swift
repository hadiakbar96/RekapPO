//
//  OnBoardingView.swift
//  MyOrders
//
//  Created by Hadi Alfian Akbar on 26/04/26.
//

import SwiftUI

struct OnBoardingView: View {
    // set the appState to onboarding
    @AppStorage("appState") private var appState: String = "onboarding"
    
    var body: some View {
        VStack {
            //            Spacer()
            Image("onBoardingImage")
                .resizable()
                .scaledToFit()
                .padding(50)
            //                .frame()
            Text("Welcome to")
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
            
            Text("RekapPO")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color.primaryButton)
                .padding(.bottom, 16)
            
            Text("Simplify your business, manage every pre-order, and meet every deadline, right from your phone.")
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
            Spacer()
            HStack {
                Spacer()
                Button {
                    // update the appState to settings
                    appState = "settings"
                    
                } label: {
                    Text("Next")
                }
                
            }
            .padding()
            // logging
            .onAppear {
                print("the appState : ", appState)}
        }
        .padding()
    }
        
}

#Preview {
    OnBoardingView()
}
