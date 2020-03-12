//
//  LoginInteractor.swift
//  DailyRewards
//
//  Created by Joao Gabriel Medeiros Perei on 23/11/19.
//  Copyright (c) 2019 Globile. All rights reserved.
//
import GoogleSignIn
import FirebaseAuth
import JewFeatures
import SwiftyRSA

protocol LoginInteractorProtocol {
    func setupSignInFirebase()
    func setupSignInBackend()
}

class LoginInteractor: LoginInteractorProtocol {
    var presenter: LoginPresenterProtocol?
    var workerFirebase: LoginFirebaseWorkerProtocol? = LoginFirebaseWorker()
    var workerPublicKey: LoginPublicKeyWorkerProtocol? = LoginPublicKeyWorker()
    var workerAccessToken: LoginAccessTokenWorkerProtocol? = LoginAccessTokenWorker()
    var workerSignIn: LoginSignInWorkerProtocol? = LoginSignInWorker()
    func setupSignInFirebase() {
        GIDSignIn.sharedInstance()?.delegate = workerFirebase as? GIDSignInDelegate
        getFirebase(userCompletion: {
            self.presenter?.presentLoginFirebase()
        }) { (error) in
            self.presenter?.presentHideLoading()
            self.presenter?.presentLogin(error: error)
        }
    }
    
    private func getFirebase(userCompletion: @escaping () -> (), errorCompletion: @escaping (ConnectorError) -> ()) {
        savedFirebaseUser(userCompletion: {
            userCompletion()
        }) { (error) in
            errorCompletion(error)
        }
        getServerFirebaseUser(userCompletion: {
            self.presenter?.presentShowLoading()
            userCompletion()
        }) { (error) in
            errorCompletion(error)
        }
    }
    
    private func savedFirebaseUser(userCompletion: @escaping () -> (), errorCompletion: @escaping (ConnectorError) -> ()) {
        let currentUser = Auth.auth().currentUser
        if(currentUser != nil) {
            presenter?.presentShowLoading()
            workerFirebase?.create(user: currentUser, success: { (user) in
                JEWSession.session.user = user
                userCompletion()
            }, error: { (error) in
                errorCompletion(error)
            })
            return
        }
        presenter?.presentHideLoading()
    }
    
    private func getServerFirebaseUser(userCompletion: @escaping () -> (), errorCompletion: @escaping (ConnectorError) -> ()) {
        workerFirebase?.successCallback = { (user) in
            JEWSession.session.user = user
            userCompletion()
        }
        workerFirebase?.errorCallback = { (error) in
            errorCompletion(error)
        }
    }
    
    func setupSignInBackend() {
        self.authentication()
    }
    
    private func authentication() {
        getPublicKey(successCompletion: {
            self.getAccessToken()
        }) { (error) in
            self.presenter?.presentHideLoading()
            self.presenter?.presentLogin(error: error)
        }
    }
    
    private func getPublicKey(successCompletion: @escaping () -> (), errorCompletion: @escaping (ConnectorError) -> ()) {
        workerPublicKey?.get(successCompletion: { responsePublicKey in
            JEWSession.session.services.publicKey = responsePublicKey.data.publicKey
            self.getAccessToken()
        }, errorCompletion: { (error) in
            self.presenter?.presentHideLoading()
            self.presenter?.presentLogin(error: error)
        })
    }
    
    private func getAccessToken() {
        if let aesCrypto = AES256Crypter.create(), let encryptedAESCryptoString = RSACrypto.encrypt(data: aesCrypto) {
            workerAccessToken?.post(aesCryptoEncrypted: encryptedAESCryptoString, successCompletion: { (accessToken) in
                if let accessTokenString = accessToken.data.accessToken {
                    self.signIn(accessToken: accessTokenString)
                }
            }, errorCompletion: { (error) in
                self.presenter?.presentHideLoading()
                self.presenter?.presentLogin(error: error)
            })
        }
    }
    
    private func signIn(accessToken: String) {
        let currentUser = Auth.auth().currentUser
        let signIn = SignInModel(name: currentUser?.displayName ?? "User Without Name", email: currentUser?.email ?? "User Without Email", picture: currentUser?.photoURL?.absoluteString ?? "User Without Photo")
        if let signInData = getData(signIn: signIn), let encryptedSignInString = AES256Crypter.crypto.encrypt(signInData) {
            workerSignIn?.post(accessToken: accessToken, signInEncrypted: encryptedSignInString, successCompletion: { (sessionToken) in
                guard let user = JEWSession.session.user else {
                    self.presenter?.presentHideLoading()
                    self.presenter?.presentLogin(error: (ConnectorError.handleError(error: ConnectorError.customError())))
                    return
                }
                JEWSession.session.services.token = sessionToken.data.sessionToken
                self.presenter?.presentLogin(user: user)
            }, errorCompletion: { (error) in
                self.presenter?.presentHideLoading()
                self.presenter?.presentLogin(error: error)
            })
        }
    }
    
    private func getData(signIn: SignInModel) -> Data? {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(signIn)
            return data
        } catch let error {
            JEWLogger.error(error.localizedDescription)
            return nil
        }
    }
    
}
