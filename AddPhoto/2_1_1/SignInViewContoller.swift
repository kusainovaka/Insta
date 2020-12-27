//
//  SignInViewContoller.swift
//  iew
//
//  Created by отмеченные on 31.10.2020.
//  Copyright © 2020 отмеченные. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture



final class CustomButton: UIButton {

    private var shadowLayer: CAShapeLayer!

    override func layoutSubviews() {
        super.layoutSubviews()

        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 8.0).cgPath
            shadowLayer.fillColor = Colors.colors.block_2_1_1_button_disabled.cgColor
            shadowLayer.shadowColor = UIColor.darkGray.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.25).cgColor;
            shadowLayer.shadowOpacity = 4.0
            shadowLayer.shadowOffset = .init(width: 4, height: 4)
            shadowLayer.shadowRadius = 4
            layer.insertSublayer(shadowLayer, at: 0)
            //layer.insertSublayer(shadowLayer, below: nil) // also works
        }
    }

}

final class SignInViewController:UIViewController {
    
    var presenter:SignInPresenter!

    let disposebag = DisposeBag()
    
    let phoneTextLabel:UILabel = {
        let label = UILabel()
        label.text = "RU+7"
        label.textColor = UIColor.black
        label.font = UIFont(name: "Verdana", size: 14)
        label.frame = CGRect(x: 10, y: 10, width: 60, height: 20)
        return label
    }()
    
    let phoneImageIcon:UIImageView = {
        let image_view = UIImageView()
        image_view.frame = CGRect(x: 50, y: 13, width: 18, height: 18)
        image_view.image = UIImage(named: "chevron-down")
        return image_view
    }()
    
    let phoneTextField:UITextField = {
        let text_field = UITextField()
        text_field.keyboardType = .numberPad
        text_field.attributedPlaceholder = NSAttributedString(string: "Номер телефона",attributes: [NSAttributedString.Key.foregroundColor: Colors.colors.block_2_1_1_content_borrom_line])
        text_field.frame = CGRect(x: 80, y: 10, width: 150, height: 20)
        text_field.textColor = .black
        text_field.font = UIFont(name: "Roboto-Regular", size: 16)
        return text_field
    }()
    
    let mailTextField:UITextField = {
        let text_field = UITextField()
        text_field.attributedPlaceholder = NSAttributedString(string: "Почта",attributes: [NSAttributedString.Key.foregroundColor: Colors.colors.block_2_1_1_content_borrom_line])
        text_field.frame = CGRect(x: 10, y: 13, width: 200, height: 20)
        text_field.textColor = .black
        text_field.font = UIFont(name: "Roboto-Regular", size: 16)
        return text_field
    }()
    
    let titleReg:UILabel = {
        let label = UILabel()
        label.text = "Регистрация"
        label.textColor = Colors.colors.block_2_1_stack_registration_title
        label.font = UIFont(name: "Roboto-Medium", size: 18)
        return label
    }()
    
    let stack:UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alignment = .fill
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.spacing = 70
        return stack
    }()
    
    
    let content_view:UIView = {
        let view = UIView()
        //view.backgroundColor = UIColor.cyan
        view.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let bottom_view = UIView()
        bottom_view.backgroundColor = Colors.colors.block_2_1_1_content_borrom_line
        bottom_view.frame = CGRect(x: 0, y: 0, width: 100, height: 2)
        bottom_view.layer.cornerRadius = 1.0
        bottom_view.tag = 101
        view.addSubview(bottom_view)
        bottom_view.translatesAutoresizingMaskIntoConstraints = false
        bottom_view.heightAnchor.constraint(equalToConstant: 2).isActive = true
        bottom_view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 1).isActive = true
        bottom_view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -1).isActive = true
        bottom_view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -2).isActive = true
        
        return view
    }()
    
    
    let left_stack_view:UIView = {
       let v = UIView()
       v.frame = CGRect(x: 0, y: 0, width: 102, height: 40)
       let bottom_view = UIView()
       bottom_view.backgroundColor = Colors.colors.block_2_1_registation_title
       bottom_view.frame = CGRect(x: 0, y: 0, width: 100, height: 2)
       bottom_view.layer.cornerRadius = 1.0
       bottom_view.tag = 101
       v.addSubview(bottom_view)
       bottom_view.translatesAutoresizingMaskIntoConstraints = false
       bottom_view.heightAnchor.constraint(equalToConstant: 2).isActive = true
       bottom_view.leadingAnchor.constraint(equalTo: v.leadingAnchor, constant: 1).isActive = true
       bottom_view.trailingAnchor.constraint(equalTo: v.trailingAnchor, constant: -1).isActive = true
       bottom_view.bottomAnchor.constraint(equalTo: v.bottomAnchor, constant: -2).isActive = true
       let label = UILabel()
       label.text = "Телефон"
       label.textColor = Colors.colors.block_2_1_registation_title
       label.font = UIFont(name: "Roboto-Regular", size: 14)
       label.translatesAutoresizingMaskIntoConstraints = false
       v.addSubview(label)
       label.centerXAnchor.constraint(equalTo: v.centerXAnchor).isActive = true
       label.centerYAnchor.constraint(equalTo: v.centerYAnchor).isActive = true
       return v
    }()
    
    let right_stack_view:UIView = {
       let v = UIView()
       v.frame = CGRect(x: 0, y: 0, width: 102, height: 40)
       let bottom_view = UIView()
       bottom_view.backgroundColor = Colors.colors.block_2_1_registation_title
       bottom_view.frame = CGRect(x: 0, y: 0, width: 100, height: 2)
       bottom_view.layer.cornerRadius = 1.0
       bottom_view.tag = 101
       v.addSubview(bottom_view)
       bottom_view.translatesAutoresizingMaskIntoConstraints = false
       bottom_view.heightAnchor.constraint(equalToConstant: 2).isActive = true
       bottom_view.leadingAnchor.constraint(equalTo: v.leadingAnchor, constant: 1).isActive = true
       bottom_view.trailingAnchor.constraint(equalTo: v.trailingAnchor, constant: -1).isActive = true
       bottom_view.bottomAnchor.constraint(equalTo: v.bottomAnchor, constant: -2).isActive = true
       let label = UILabel()
       label.text = "Почта"
       label.textColor = Colors.colors.block_2_1_registation_title
       label.font = UIFont(name: "Roboto-Regular", size: 14)
       label.translatesAutoresizingMaskIntoConstraints = false
       v.addSubview(label)
       label.centerXAnchor.constraint(equalTo: v.centerXAnchor).isActive = true
       label.centerYAnchor.constraint(equalTo: v.centerYAnchor).isActive = true
       return v
    }()
    
    
    
    let back_button:UIButton = {
       let image = UIButton()
       image.frame = CGRect(x: 0, y: 0, width: 28, height: 28)
       image.setImage(UIImage(named: "arrow-left"), for: .normal)
       return image
    }()
    
    let button_over_layer:UIView = {
       
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.shadowColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.1).cgColor;
        v.layer.shadowOpacity = 4.0
        v.layer.shadowOffset = .init(width: 4, height: 8)
        v.layer.shadowRadius = 16
        v.layer.zPosition = 1
        v.layer.cornerRadius = 8.0
        v.backgroundColor = Colors.colors.block_2_1_view
        return v
    }()
    
    
    let enter_button:UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = false
        button.adjustsImageWhenHighlighted = false
        button.layer.cornerRadius = 8.0
        button.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 18)
        button.setTitle("Отправить код", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = Colors.colors.block_2_1_1_button_disabled
        button.layer.cornerRadius = 8.0
        button.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        //button.layer.masksToBounds =
        button.layer.masksToBounds = true

        
        
        button.layer.shadowColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.25).cgColor;
        button.layer.shadowOpacity = 4.0
        button.layer.shadowOffset = .init(width: 4, height: 4)
        button.layer.shadowRadius = 4
        button.layer.zPosition = 1
        button.setBackgroundColor(Colors.colors.block_2_1_button_active,for: .normal)

        return button
    }()
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupConstraints()
        self.setupInput()
        self.setupOutPut()
    }
}


extension SignInViewController {
    
    
    
    private func setupInput() {
        self.back_button.rx.tap.bind(to: self.presenter.inputs.backTrigger).disposed(by: disposebag)
        
        self.left_stack_view.rx.tapGesture().when(.recognized).asObservable().bind { _ in
            self.presenter.inputs.stackItemTrigger.onNext("phone")
        }.disposed(by: disposebag)
        
        self.right_stack_view.rx.tapGesture().when(.recognized).asObservable().bind { _ in
            self.presenter.inputs.stackItemTrigger.onNext("email")
        }.disposed(by: disposebag)
        
        self.enter_button.rx.controlEvent(.touchUpInside).flatMap { [weak self] _ in
            return (self?.return_observer(block: (self?.enter_button.animate())!))!
        }.flatMap { [weak self] _ in
            return (self?.return_observer(block: (self?.button_over_layer.animate_())!))!
        }.delay(.milliseconds(250), scheduler:  MainScheduler.instance).bind(to:self.presenter.enterNextTrigger).disposed(by: disposebag)
    }
    
    private func setupOutPut() {
        
        self.presenter.inputs.stackItemTrigger.asObservable().subscribe(onNext: { [weak self] value in
            
            guard let self = self else {return}
            
            if value == "phone" {
                self.stack.setOpacityForBottomLine(tag: 101, opacity: 0.0, stackItemIndex: 1)
                self.stack.setOpacityForBottomLine(tag: 101, opacity: 1.0, stackItemIndex: 0)
                for (_,e) in self.content_view.subviews.enumerated(){
                    if let _ = e as? UITextField {
                        e.removeFromSuperview()
                    } else if let _ = e as? UIImageView {
                        e.removeFromSuperview()
                    } else if let _ = e as? UILabel {
                        e.removeFromSuperview()
                        }
                    }
                self.content_view.addSubview(self.phoneTextLabel)
                self.content_view.addSubview(self.phoneImageIcon)
                self.content_view.addSubview(self.phoneTextField)
                self.enter_button.setTitle("Отправить код", for: .normal)
                self.presenter.email_driver = nil
                self.presenter.phone_driver = self.phoneTextField.rx.text.orEmpty.asDriver()
                self.presenter.setup_observer(telephone: true)
                self.presenter.can_login?.asObservable().bind(to: self.enter_button.rx.isEnabled).disposed(by: self.disposebag)
            
            } else {
                self.stack.setOpacityForBottomLine(tag: 101, opacity: 0.0, stackItemIndex: 0)
                self.stack.setOpacityForBottomLine(tag: 101, opacity: 1.0, stackItemIndex: 1)
                for (_,e) in self.content_view.subviews.enumerated(){
                    if let _ = e as? UITextField {
                        e.removeFromSuperview()
                    } else if let _ = e as? UILabel {
                        e.removeFromSuperview()
                    } else if let _ = e as? UIImageView {
                        e.removeFromSuperview()
                    }
                }
                self.content_view.addSubview(self.mailTextField)
                self.enter_button.setTitle("Зарегистрироваться", for: .normal)
                self.presenter.phone_driver = nil
                self.presenter.email_driver = self.mailTextField.rx.text.orEmpty.asDriver()
                self.presenter.setup_observer(telephone: false)
                self.presenter.can_login?.asObservable().bind(to: self.enter_button.rx.isEnabled).disposed(by: self.disposebag)
            }
        }).disposed(by: disposebag)
        
        
        self.view.rx.tapGesture().when(.recognized).asObservable().subscribe(onNext: { [weak self] _ in
            self?.phoneTextField.resignFirstResponder()
            self?.mailTextField.resignFirstResponder()
        }).disposed(by: disposebag)
        
        
    }
    
    private func setupConstraints() {
        self.view.backgroundColor = Colors.colors.block_2_1_view
        self.view.addSubview(titleReg)
        titleReg.translatesAutoresizingMaskIntoConstraints = false
        titleReg.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        titleReg.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 25).isActive = true
        self.view.addSubview(back_button)
        back_button.translatesAutoresizingMaskIntoConstraints = false
        back_button.widthAnchor.constraint(equalToConstant: 28).isActive = true
        back_button.heightAnchor.constraint(equalToConstant: 28).isActive = true
        back_button.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 21).isActive = true
        back_button.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 26).isActive = true
        self.stack.addArrangedSubview(left_stack_view)
        self.stack.addArrangedSubview(right_stack_view)
        left_stack_view.widthAnchor.constraint(equalToConstant: 102).isActive = true
        left_stack_view.heightAnchor.constraint(equalToConstant: 40).isActive = true
        right_stack_view.widthAnchor.constraint(equalToConstant: 102).isActive = true
        right_stack_view.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.view.addSubview(self.stack)
        stack.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        stack.topAnchor.constraint(equalTo: self.titleReg.bottomAnchor, constant: 40).isActive = true
        
        self.view.addSubview(content_view)
        content_view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 45).isActive = true
        content_view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -45).isActive = true
        content_view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        content_view.topAnchor.constraint(equalTo: self.stack.bottomAnchor, constant: 30).isActive = true
        
        
        
        self.view.addSubview(button_over_layer)
        button_over_layer.translatesAutoresizingMaskIntoConstraints = false
        button_over_layer.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 28).isActive = true
        button_over_layer.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -28).isActive = true
        button_over_layer.heightAnchor.constraint(equalToConstant: 67).isActive = true
        button_over_layer.topAnchor.constraint(equalTo: content_view.bottomAnchor, constant: 38).isActive = true
        
        self.view.addSubview(enter_button)
        enter_button.translatesAutoresizingMaskIntoConstraints = false
        enter_button.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 28).isActive = true
        enter_button.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -28).isActive = true
        enter_button.heightAnchor.constraint(equalToConstant: 67).isActive = true
        enter_button.topAnchor.constraint(equalTo: content_view.bottomAnchor, constant: 38).isActive = true
        
       
    
        
    }
}


extension SignInViewController:View {}



