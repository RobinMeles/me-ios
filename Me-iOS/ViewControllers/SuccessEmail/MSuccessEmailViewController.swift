//
//  MSuccessEmailViewController.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/8/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import UIKit

class MSuccessEmailViewController: UIViewController {
    
    lazy var successEmailViewModel: SuccessEmailViewModel = {
        return SuccessEmailViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(authorizeToken(notifcation:)),
            name: NotificationName.AuthorizeTokenEmail,
            object: nil)
    }
    
    @objc func authorizeToken(notifcation: Notification){
        
        successEmailViewModel.complete = { [weak self] (token) in
            
            DispatchQueue.main.async {
                
                UserDefaults.standard.set(token, forKey: UserDefaultsName.Token)
                UserDefaults.standard.set(true, forKey: UserDefaultsName.UserIsLoged)
                CurrentSession.shared.token = token
                self?.addShortcuts(application: UIApplication.shared)
                UserDefaults.standard.synchronize()
                self?.performSegue(withIdentifier: "goToMain", sender: self)
                
            }
        }
        
        if let token = notifcation.userInfo?["authToken"] as? String {
            
          successEmailViewModel.initCheckAuthorize(token: token)
            
        }
        
        
    }
    
    @IBAction func openMailApp(_ sender: Any) {
        if let mailURL = NSURL(string: "message://") {
            if UIApplication.shared.canOpenURL(mailURL as URL) {
                UIApplication.shared.open(mailURL as URL, options: [:],
                                          completionHandler: {
                                            (success) in }) }
            
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let barVC = segue.destination as? UITabBarController
        let nVC = barVC!.viewControllers![0] as? HiddenNavBarNavigationController
        let vc = nVC?.topViewController as? MVouchersViewController
        vc?.isFromLogin = true
    }
    
}
