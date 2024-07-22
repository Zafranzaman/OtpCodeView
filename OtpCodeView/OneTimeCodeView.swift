//
//  OneTimeCodeView.swift
//  OtpCodeView
//
//  Created by Zafran on 22/07/2024.
//

import Foundation
import SwiftUI

public struct OneTimeCodeView: View {
    @Binding var otpText: String
    private let doSomething: (String) -> Void
    private let length: Int
    
    @FocusState private var isKeyboardShowing: Bool
    
    public init(otpText: Binding<String>, length: Int, doSomething: @escaping (String) -> Void) {
        self._otpText = otpText
        self.length = length
        self.doSomething = doSomething
    }
    
    public var body: some View {
        HStack(spacing: 9) {
            ForEach(0..<length, id: \.self) { index in
                OTPTextBox(index)
            }
        }
        .background {
            TextField("", text: $otpText.limitAndFilter(to: length))
                .keyboardType(.numberPad)
                .textContentType(.oneTimeCode)
                .frame(width: 1, height: 1)
                .opacity(0.001)
                .blendMode(.screen)
                .focused($isKeyboardShowing)
                .onChange(of: otpText) { newValue in
                    if newValue.count == length {
                        doSomething(newValue)
                    }
                }
                .onAppear {
                    DispatchQueue.main.async {
                        isKeyboardShowing = true
                    }
                }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            isKeyboardShowing = true
        }
    }
    
    @ViewBuilder
    private func OTPTextBox(_ index: Int) -> some View {
        ZStack {
            if otpText.count > index {
                let startIndex = otpText.startIndex
                let charIndex = otpText.index(startIndex, offsetBy: index)
                let charToString = String(otpText[charIndex])
                Text(charToString)
                    .font(.system(size: 18, weight: .bold))
            } else {
                Text("-")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.gray)
            }
        }
        .frame(width: 53, height: 53)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .strokeBorder((isKeyboardShowing && otpText.count == index) ? Color.blue : .gray.opacity(0.2), lineWidth: (isKeyboardShowing && otpText.count == index) ? 1.5 : 1)
                .animation(.easeInOut(duration: 0.2), value: isKeyboardShowing && otpText.count == index)
        )
    }
}

extension Binding where Value == String {
    func limitAndFilter(to length: Int) -> Self {
        return Binding(
            get: {
                return self.wrappedValue
            },
            set: { newValue in
                let filtered = newValue.filter { "0123456789".contains($0) }
                if filtered.count <= length {
                    self.wrappedValue = filtered
                }
            }
        )
    }
}

struct OTPView_Previews: PreviewProvider {
    static var previews: some View {
        OneTimeCodeView(otpText: .constant(""), length: 6, doSomething: { value in
            print(value)
        })
        .padding()
    }
}
