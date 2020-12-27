//
//  SignInRouter.swift
//  iew
//
//  Created by отмеченные on 31.10.2020.
//  Copyright © 2020 отмеченные. All rights reserved.
//

import Foundation
import UIKit


final class SignInRouterInput {    
    func view() -> SignInViewController {
        let story_board = UIStoryboard.init(name:"SignIn", bundle: nil)
        let view = SignInViewController.instantiate(from: story_board)
        let interactor = SignInInteractor()
        let dependencies = SignInPresenterDependencies(interactor: interactor, router: SignInRouterOutput(view))
        let presenter = SignInPresenter(dependencies: dependencies)
        view.presenter = presenter
        return view
    }

    func push(from: View) {
         let view = self.view()
         from.push(view, animated: false)
    }

    func present(from: View) {
         let nav = UINavigationController(rootViewController: view())
         from.present(nav, animated: false)
    }
}


final class SignInRouterOutput:Router{
    
    private(set) weak var view: View!

    init(_ view: View) {
        self.view = view
    }
    
    func showPhoneConfirmModule() {
        PhoneConfirmRouterInput_().push(from: self.view)

    }
    
    func showEmailConfirmModule() {
        MailConfirmRouterInput().push(from: self.view)
    }
    
}
