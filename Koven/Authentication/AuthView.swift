//
//  AuthView.swift
//  Koven
//
//  Created by Adit Sachde on 1/12/21.
//
import SwiftUI
import MatrixSDK

struct AuthView: View {
    @StateObject var matrixAuth = MatrixAuth()
    
    var body: some View {
        
        switch matrixAuth.loginState {
        case .authenticating:
            VStack {
                Text("Syncing!")
                Text("This may take a bit with a lot of rooms")
            }
        case .loggedOut:
            LoginView(authViewDataSource: matrixAuth)
        case .loggedIn:
            OverlayManager {
                RoomListView(roomList: RoomListDataSource(session: matrixAuth.session!)).environmentObject(matrixAuth.state!)
            }
        /*case .sync:
            VStack {
                Text("Syncing Rooms!")
            }*/
        case .crossSign:
            if matrixAuth.state != nil {
                VerificationView(dataSource: VerificationDataSource(matrixState: matrixAuth.state!, isNewSignIn: true), onClose: {
                    matrixAuth.crossSignDone()
                })
            } else {
                //matrixAuth.crossSignOpen = false
                Text("Cross signing failed!")
                Button(action: {
                    matrixAuth.crossSignDone()
                }, label: {
                    Text("Ok")
                })
            }
        case let .failure(error):
            Text(error.localizedDescription)
            LoginView(authViewDataSource: matrixAuth)
        }
        
        /*if matrixAuth.showLoading {
            VStack {
                Text("loading!")
                Button(action: {
                    matrixAuth.failed()
                }, label: {
                    Text("Cancel")
                })
            }
        } else if matrixAuth.loggedIn {
            RoomListView(roomList: RoomListDataSource(session: matrixAuth.matrixState!.session)).environmentObject(matrixAuth.matrixState!)
        } else {
            LoginView(authViewDataSource: matrixAuth)
        }*/
    }
}
