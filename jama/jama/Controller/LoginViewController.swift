//
//  LoginViewController.swift
//  jama
//
//  Created by Mark Brightman on 09/03/2018.
//  Copyright © 2018 Mark Brightman. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    private var navigator: LoginNavigator
    
    init(navigator: LoginNavigator) {
        self.navigator = navigator
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = UIColor.orange
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let btn = UIButton(type: .infoLight)
        btn.center = self.view.center
        btn.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        self.view.addSubview(btn)

    }
    
    @objc func buttonTapped() {
        handleLoginButtonTap()
    }
    
    private func handleLoginButtonTap() {
        performLogin { [weak self] result in
            switch result {
            case .Success(let user):
                self?.navigator.navigate(to: .loginCompleted(user: user))
            case .Failure(let error):
                print(error)
                self?.navigator.navigate(to: .forgotPassword)
            }
        }
    }
    
    private func handleForgotPasswordButtonTap() {
        navigator.navigate(to: .forgotPassword)
    }
    
    private func handleSignUpButtonTap() {
        navigator.navigate(to: .signup)
    }
    
    func performLogin(completion: @escaping (ResultType<User>) -> Void) {
        completion(ResultType.Failure(APIError.urlError))
    }
}
