//
//  VerificationDataSource.swift
//  Koven
//
//  Created by Adit Sachde on 1/22/21.
//

import SwiftUI
import MatrixSDK

enum VerificationStatus {
    case loading
    case error(Error)
    case canceled(MXTransactionCancelCode)
    case accepted(MXIncomingSASTransaction)
    case waiting
    case complete
}

class VerificationDataSource: ObservableObject {
    @Published var keyVerificationRequest: MXKeyVerificationRequest?
    @Published var verificationStatus: VerificationStatus = .loading
    var matrixState: MatrixState
    var isNewSignIn: Bool
    private var keyVerificationStatusResolver: MXKeyVerificationStatusResolver
    private var keyVerificationStatus: MXKeyVerification?
    
    init(matrixState: MatrixState, isNewSignIn: Bool) {
        self.matrixState = matrixState
        self.isNewSignIn = isNewSignIn
        self.keyVerificationStatusResolver = MXKeyVerificationStatusResolver(manager: matrixState.session.crypto.keyVerificationManager, matrixSession: matrixState.session)
        
        print("loggerlogging \(matrixState.session.crypto.crossSigning.state.rawValue)")
        
        guard matrixState.session.crypto.crossSigning.state == .notBootstrapped ||  matrixState.session.crypto.crossSigning.state == .crossSigningExists else {
            return
        }
        
        self.registerTransactionDidStateChangeNotification()
        self.registerKeyVerificationManagerNewRequestNotification(for: self.matrixState.session.crypto.keyVerificationManager)
        print("loggerlogging got here tho")
        
        if !isNewSignIn {
            
            matrixState.session.crypto.keyVerificationManager.requestVerificationByToDevice(withUserId: matrixState.session.myUserId, deviceIds: nil, methods: [MXKeyVerificationMethodSAS]) { [weak self] (keyVerificationRequest) in
                print(keyVerificationRequest.debugDescription)
                guard let self = self else {
                    return
                }
                DispatchQueue.main.async {
                    self.keyVerificationRequest = keyVerificationRequest
                }
                self.registerKeyVerificationRequestDidChangeNotification(for: keyVerificationRequest)
                
            } failure: { (error) in
                print(error)
                self.verificationStatus = .error(error)
            }
        }
        
    }
    
    func cancelKeyVerificationRequest() {
        self.keyVerificationRequest?.cancel(with: MXTransactionCancelCode.user(), success: nil, failure: nil)
        //self.unregisterCrossSigningStateDidChangeNotification()
        self.verificationStatus = .canceled(MXTransactionCancelCode.user())
    }
    
    func cancelKeyVerificationRequestMismatch() {
        self.keyVerificationRequest?.cancel(with: MXTransactionCancelCode.mismatchedSas(), success: nil, failure: nil)
        self.verificationStatus = .canceled(MXTransactionCancelCode.mismatchedSas())
    }
    
    func verifyKeyVerificationRequest() {
        self.verificationStatus = .waiting
    }
    
    // MARK: MXKeyVerificationRequestDidChange
    
    private func registerKeyVerificationRequestDidChangeNotification(for keyVerificationRequest: MXKeyVerificationRequest) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyVerificationRequestDidChange(notification:)), name: .MXKeyVerificationRequestDidChange, object: keyVerificationRequest)
    }
    
    private func unregisterKeyVerificationRequestDidChangeNotification(for keyVerificationRequest: MXKeyVerificationRequest) {
        NotificationCenter.default.removeObserver(self, name: .MXKeyVerificationRequestDidChange, object: keyVerificationRequest)
    }
    
    @objc private func keyVerificationRequestDidChange(notification: Notification) {
        guard let verificationRequest = notification.object as? MXKeyVerificationRequest else {
            return
        }
        print("loggerlogging verification request \(verificationRequest.debugDescription)")
        objectWillChange.send()
        if (verificationRequest.state.rawValue == 5) {
            verificationStatus = .complete
        }
    }
    
    
    // MARK: MXKeyVerificationNewRequest
    
    private func acceptKeyVerificationRequest(_ keyVerificationRequest: MXKeyVerificationRequest) {
        
        keyVerificationRequest.accept(withMethods: [MXKeyVerificationMethodSAS], success: { [weak self] in
            guard let self = self else {
                return
            }
            
            self.keyVerificationRequest?.cancel(with: MXTransactionCancelCode.user(), success: nil, failure: nil)
            if (self.keyVerificationRequest != nil) {
                self.unregisterKeyVerificationRequestDidChangeNotification(for: self.keyVerificationRequest!)
            }
            self.keyVerificationRequest = keyVerificationRequest
            if (self.keyVerificationRequest != nil) {
                self.registerKeyVerificationRequestDidChangeNotification(for: self.keyVerificationRequest!)
            }
            
        }, failure: { [weak self] (error) in
            guard let self = self else {
                return
            }
        })
    }
    
    private func registerKeyVerificationManagerNewRequestNotification(for verificationManager: MXKeyVerificationManager) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyVerificationManagerNewRequestNotification(notification:)), name: .MXKeyVerificationManagerNewRequest, object: verificationManager)
    }
    
    private func unregisterKeyVerificationManagerNewRequestNotification() {
        NotificationCenter.default.removeObserver(self, name: .MXKeyVerificationManagerNewRequest, object: nil)
    }
    
    @objc private func keyVerificationManagerNewRequestNotification(notification: Notification) {
        guard let userInfo = notification.userInfo, let keyVerificationRequest = userInfo[MXKeyVerificationManagerNotificationRequestKey] as? MXKeyVerificationByToDeviceRequest else {
            return
        }
        
        guard keyVerificationRequest.isFromMyUser,
              keyVerificationRequest.isFromMyDevice == false,
              keyVerificationRequest.state == MXKeyVerificationRequestStatePending else {
            return
        }
        
        self.unregisterKeyVerificationManagerNewRequestNotification()
        self.acceptKeyVerificationRequest(keyVerificationRequest)
    }
    
    // MARK: MXKeyVerificationTransactionDidChange
    
    private func registerTransactionDidStateChangeNotification() {
        print("loggerlogging did register observer")
        NotificationCenter.default.addObserver(self, selector: #selector(transactionDidStateChange(notification:)), name: .MXKeyVerificationTransactionDidChange, object: nil)
    }
    
    private func unregisterTransactionDidStateChangeNotification() {
        NotificationCenter.default.removeObserver(self, name: .MXKeyVerificationTransactionDidChange, object: nil)
    }
    
    @objc private func transactionDidStateChange(notification: Notification) {
        print("loggerlogging notification did change \(notification.debugDescription)")
        guard let sasTransaction = notification.object as? MXIncomingSASTransaction,
              sasTransaction.otherUserId == self.matrixState.session.myUserId else {
            return
        }
        self.sasTransactionDidStateChange(sasTransaction)
    }
    
    private func sasTransactionDidStateChange(_ transaction: MXIncomingSASTransaction) {
        print("loggerlogging transasction state did change \(transaction.state)")
        switch transaction.state {
        case MXSASTransactionStateIncomingShowAccept:
            transaction.accept()
        case MXSASTransactionStateShowSAS:
            //self.unregisterTransactionDidStateChangeNotification()
            self.verificationStatus = .accepted(transaction)
            self.keyVerificationStatus = self.keyVerificationStatusResolver.keyVerification(from: self.keyVerificationRequest, andTransaction: transaction)
        case MXSASTransactionStateCancelled:
            guard let reason = transaction.reasonCancelCode else {
                return
            }
            print("loggerlogging 1 cancel \(reason)")
            
            self.unregisterTransactionDidStateChangeNotification()
            //self.unregisterCrossSigningStateDidChangeNotification()
            self.verificationStatus = .canceled(reason)
        case MXSASTransactionStateCancelledByMe:
            guard let reason = transaction.reasonCancelCode else {
                return
            }
            print("loggerlogging 2 cancel \(reason)")
            
            self.unregisterTransactionDidStateChangeNotification()
            //self.unregisterCrossSigningStateDidChangeNotification()
            self.verificationStatus = .canceled(reason)
        case MXSASTransactionStateVerified:
            self.unregisterTransactionDidStateChangeNotification()
            self.verificationStatus = .complete
        default:
            break
        }
    }
    
    /*// MARK: KMXEventTypeStringKeyVerificationDone
     
     private func registerCrossSigningStateDidChangeNotification() {
     NotificationCenter.default.addObserver(self, selector: #selector(transactionDidStateChange(notification:)), name: NSNotification.Name(rawValue: kMXEventTypeStringKeyVerificationDone), object: nil)
     }
     
     private func unregisterCrossSigningStateDidChangeNotification() {
     NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: kMXEventTypeStringKeyVerificationDone), object: nil)
     }
     
     @objc private func crossSigningStateDidChange(notification: Notification) {
     print("loggerlogging cross signing done")
     print(notification.object.debugDescription)
     guard let device = notification.object as? MXKeyVerificationDone else {
     return
     }
     self.verificationStatus = .complete
     self.unregisterCrossSigningStateDidChangeNotification()
     }*/
    
}
