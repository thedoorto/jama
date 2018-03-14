//
//  LoginNavigator.swift
//  jama
//
//  Created by Mark Brightman on 09/03/2018.
//  Copyright © 2018 Mark Brightman. All rights reserved.
//

import UIKit

class LoginNavigator: Navigator {
    // Here we define a set of supported destinations using an
    // enum, and we can also use associated values to add support
    // for passing arguments from one screen to another.
    enum Destination {
        case loginCompleted(user: User)
        case forgotPassword
        case signup
    }
    
    // In most cases it's totally safe to make this a strong
    // reference, but in some situations it could end up
    // causing a retain cycle, so better be safe than sorry :)
    private weak var navigationController: UINavigationController?
    
    // MARK: - Initializer
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Navigator
    
    func navigate(to destination: Destination) {
        let viewController = makeViewController(for: destination)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    // MARK: - Private
    
    private func makeViewController(for destination: Destination) -> UIViewController {
        switch destination {
        case .loginCompleted(let user):
            return WelcomeViewController(user: user)
        case .forgotPassword:
            return PasswordResetViewController()
        case .signup:
            return SignUpViewController()
        }
    }
}
