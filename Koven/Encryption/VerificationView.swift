//
//  VerificationView.swift
//  Koven
//
//  Created by Adit Sachde on 1/22/21.
//

import SwiftUI
import MatrixSDK

struct VerificationView: View {
    @EnvironmentObject var matrixState: MatrixState
    @StateObject var dataSource: VerificationDataSource
    @State var reload = false
    //@Binding var paneOpen: Bool
    var onClose: () -> Void
    
    var body: some View {
        switch dataSource.verificationStatus {
        
        case .loading:
            return AnyView(VStack {
                Text("Confirm your identity by verifying this login from one of your other sessions, granting it access to encrypted messages.")
                if dataSource.isNewSignIn {
                    Text("Without completing security on this session, it won’t have access to encrypted messages.")
                    Button(action: {
                        dataSource.cancelKeyVerificationRequest()
                        onClose()
                    }, label: {
                        Text("Skip")
                    })
                } else {
                    Button(action: {
                        dataSource.cancelKeyVerificationRequest()
                    }, label: {
                        Text("Cancel")
                    })
                }
            })
        case let .error(error):
            return AnyView(VStack {
                Text("\(error.localizedDescription)")
            })
            
        case let .canceled(reason):
            let text: String
            if (reason.value == "m.mismatched_sas") {
                text = "Verification canceled because emojis did not match!"
            } else if (reason.value == "m.user") {
                text = "You canceled verification."
            } else {
                text = "Verification was canceled."
            }
            
            return AnyView(VStack {
                Text(text)
                Button(action: {
                    //self.paneOpen = false
                    self.onClose()
                }, label: {
                    Text("Close")
                })
            })
            
        case let .accepted(sasTransaction):
            return AnyView(VStack {
                Text("\(sasTransaction.sasDecimal ?? "error")")
                HStack {
                    ForEach(sasTransaction.sasEmoji ?? [], id: \.self) { representation in
                        VStack {
                            Text(representation.emoji)
                            Text(representation.name)
                        }
                    }
                }
                Button(action: {
                    sasTransaction.confirmSASMatch()
                    dataSource.verifyKeyVerificationRequest()
                }, label: {
                    Text("Matches!")
                })
                Button(action: {
                    sasTransaction.cancel(with: MXTransactionCancelCode.mismatchedSas())
                    dataSource.cancelKeyVerificationRequestMismatch()
                }, label: {
                    Text("Does Not Match!")
                })

            })
            
        case .waiting:
            return AnyView(VStack {
                Text("Waiting For Other Device")
                Button(action: {
                    dataSource.cancelKeyVerificationRequest()
                }, label: {
                    Text("Cancel!")
                })
            })
            
        case .complete:
            return AnyView(VStack {
                Text("Verification Complete!")
                Button(action: {
                    //self.paneOpen = false
                    self.onClose()
                }, label: {
                    Text("Close")
                })
            })
        }
    }
}
