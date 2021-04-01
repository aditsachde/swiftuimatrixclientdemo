//
//  GlobalSettingsView.swift
//  Koven
//
//  Created by Adit Sachde on 1/16/21.
//

import SwiftUI

struct GlobalSettingsView: View {
    @EnvironmentObject var matrixState: MatrixState
    @State var showingVerification = false
    
    var body: some View {
        List {
            Button(action: {
                matrixState.logout()
            }, label: {
                Text("Logout").foregroundColor(.red)
            })
            Button(action: {
                showingVerification = true
            }, label: {
                Text("Verify!")
            }).sheet(isPresented: $showingVerification, content: {
                VerificationView(dataSource: VerificationDataSource(matrixState: matrixState, isNewSignIn: false), onClose: {
                    self.showingVerification = false
                })
            })
        }
        .navigationTitle("Settings")
    }
}
