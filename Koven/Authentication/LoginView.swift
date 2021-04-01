//
//  LoginView.swift
//  Koven
//
//  Created by Adit Sachde on 1/13/21.
//

import SwiftUI

struct LoginView: View {
    var authViewDataSource: MatrixAuth
    @State private var username = "@aditsachde:matrix.org"
    @State private var password = ""
    @State private var homeserver = "https://matrix.org"
    
    var body: some View {
        VStack {
            TextField("Username", text: self.$username)
            SecureField("Password", text: self.$password)
            TextField("Homeserver", text: self.$homeserver)
            Button(action: {
                guard let homeserverUrl = URL(string: self.homeserver) else { return }
                authViewDataSource.login(username: username, password: password, homeserver: homeserverUrl)
            }) {
                Text("Sign In")
            }
        }
    }
}
