//
//  ContentView.swift
//  OtpCodeView
//
//  Created by Zafran on 22/07/2024.
//

import SwiftUI

struct ContentView: View {
    @State var Otptext : String
    
    var body: some View {
        ZStack {
            Color.primarybackground
                .ignoresSafeArea(.all)
            
            OneTimeCodeView(otpText: $Otptext, length: 6, doSomething: { value in
                print(value)
            })
            .padding()
        }
    }
}

#Preview {
    ContentView(Otptext: "")
}
