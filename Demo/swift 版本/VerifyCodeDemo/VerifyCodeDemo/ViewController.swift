//
//  ViewController.swift
//  VerifyCodeDemo
//
//  Created by 罗礼豪 on 2022/10/19.
//

import UIKit
import VerifyCode

class ViewController: UIViewController {
    
    let manager = NTESVerifyCodeManager.getInstance()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        let button = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
        button.backgroundColor = UIColor.red
        button.addTarget(self, action: #selector(buttonDidTipped), for: .touchUpInside)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.setTitle("加载验证码", for: .normal)
        self.view.addSubview(button)
    }

    @objc func buttonDidTipped() {
        manager?.configureVerifyCode("请输入易盾业务ID", timeout: 10)
        manager?.delegate = self
        manager?.lang = .CN
        manager?.alpha = 0.3
        manager?.userInterfaceStyle = .dark
        manager?.color = UIColor.black
        manager?.protocol = .https
        manager?.openFallBack = true
        manager?.fallBackCount = 3
        manager?.openVerifyCodeView()
    }

}

extension ViewController: NTESVerifyCodeManagerDelegate {
    func verifyCodeInitFinish() {
        
    }
    
    func verifyCodeInitFailed(_ error: [Any]?) {
        
    }
    
    func verifyCodeCloseWindow(_ close: NTESVerifyCodeClose) {
        
    }
    
    func verifyCodeValidateFinish(_ result: Bool, validate: String?, message: String!) {
        if result {
            print( "验证码成功：\(validate ?? "")")
        } else {
            print( "验证码失败：\(validate ?? "")")
        }
       
    }
}



