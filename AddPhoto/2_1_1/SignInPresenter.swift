//
//  SignInPresenter.swift
//  iew
//
//  Created by отмеченные on 31.10.2020.
//  Copyright © 2020 отмеченные. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

typealias SignInPresenterDependencies = (
    interactor: SignInInteractor,
    router: SignInRouterOutput
)

protocol SignInPresenterInputs {
    var backTrigger: PublishSubject<Void> {get}
    var stackItemTrigger: BehaviorSubject<String> {get}
    var enterNextTrigger: PublishSubject<Void> {get}
    var can_login:Observable<Bool>? {get set}
    var phone_driver:Driver<String>? {get set}
    var email_driver:Driver<String>? {get set}
}

protocol SignInPresenterOutputs {
    
}

protocol SignInPresenterInterface {
    var inputs: SignInPresenterInputs { get }
    var outputs: SignInPresenterOutputs { get }
}

final class SignInPresenter:SignInPresenterInputs, SignInPresenterOutputs, SignInPresenterInterface  {
    
    var phone_driver: Driver<String>?
    
    var email_driver: Driver<String>?

    var can_login: Observable<Bool>?
    
    var inputs: SignInPresenterInputs {return self}
    
    var outputs: SignInPresenterOutputs {return self}
    
    let disposeBag = DisposeBag()
    
    var backTrigger: PublishSubject<Void> = PublishSubject<Void>()
    
    var stackItemTrigger: BehaviorSubject<String> = BehaviorSubject<String>(value:"phone")
    
    var enterNextTrigger: PublishSubject<Void> = PublishSubject<Void>()
    

    
    let dependencies:SignInPresenterDependencies
    
    init(dependencies: SignInPresenterDependencies) {
        
        self.dependencies = dependencies
        
        self.backTrigger.asObservable().bind { [weak self] _ in
            self?.dependencies.router.pop(animated: true)
        }.disposed(by: disposeBag)
        
        self.enterNextTrigger.withLatestFrom(self.stackItemTrigger).asObservable().bind { [weak self] value in
            
            if value == "email" {
                 self?.dependencies.router.showEmailConfirmModule()
            } else {
                 self?.dependencies.router.showPhoneConfirmModule()
            }
        }.disposed(by: disposeBag)
        
    }
    
    
    func setup_observer(telephone:Bool) {
        if telephone == true {
            self.email_driver = nil
            self.can_login = nil
            self.can_login = self.phone_driver?.asObservable().map { return $0.count > 9}
        } else {
            self.phone_driver = nil
            self.can_login = nil
            self.can_login = self.email_driver?.asObservable().map { [weak self] in
                return self?.validate($0) == true && !$0.isEmpty
            }
        }
    }
    
    
    func validate(_ input: String) -> Bool {
             guard
                 let regex = try? NSRegularExpression(
                     pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}",
                     options: [.caseInsensitive]
                 )
             else {
                 assertionFailure("Regex not valid")
                 return false
             }

             let regexFirstMatch = regex
                 .firstMatch(
                     in: input,
                     options: [],
                     range: NSRange(location: 0, length: input.count)
                 )

             return regexFirstMatch != nil
       }
       
    
    
}


