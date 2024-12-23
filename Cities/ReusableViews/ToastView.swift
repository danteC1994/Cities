//
//  ToastView.swift
//  Cities
//
//  Created by dante canizo on 22/12/2024.
//

import SwiftUI

struct ToastView: View {
    var message: String
    @Binding var isShowing: Bool

    var body: some View {
        if isShowing {
            Text(message)
                .padding()
                .background(Color.red.opacity(0.7))
                .foregroundColor(.white)
                .cornerRadius(8)
                .transition(.move(edge: .bottom))
                
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            isShowing = false
                        }
                    }
                }
                .padding(.horizontal)
        }
    }
}


#Preview {
    ToastView(message: "Oops! Something went wrong.", isShowing: .constant(true))
}
