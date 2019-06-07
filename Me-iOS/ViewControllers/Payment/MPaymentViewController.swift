//
//  MPaymentViewController.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/8/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import UIKit

class MPaymentViewController: UIViewController {
    @IBOutlet weak var voucherNameLabel: UILabel!
    @IBOutlet weak var organizationLabel: UILabel!
    @IBOutlet weak var voucherIcon: CornerImageView!
    @IBOutlet weak var organizationIcon: UIImageView!
    @IBOutlet weak var allowedOriganizationLabel: UILabel!
    @IBOutlet weak var amountField: UITextField!
    @IBOutlet weak var notesField: UITextField!
    @IBOutlet weak var notesView: CustomCornerUIView!
    @IBOutlet weak var chooseOrganizationButton: UIButton!
    @IBOutlet weak var heightFieldsConstraint: NSLayoutConstraint!
    @IBOutlet weak var arrowIcon: UIImageView!
    
    var voucher: Voucher!
    var tabBar: UITabBarController!
    var selectedAllowerdOrganization: AllowedOrganization!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        
    }
    
    
    @IBAction func send(_ sender: Any) {
        
        if amountField.text != "" {
            
            let vc = ConfirmPaymentPopUp()
            vc.voucher = voucher
            vc.organizationId = selectedAllowerdOrganization?.id ?? 0
            vc.note = notesField.text
            vc.amount = amountField.text
            vc.tabBar = tabBar
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: true)
            
        }else {
            
            showSimpleAlert(title: "Warning".localized(), message: "Please enter the amount".localized())
            
        }
    }
    
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        
        self.view.endEditing(true)
        
    }
    
    
}

extension MPaymentViewController {
    
    func initView(){
        
        if voucher?.product != nil {
            
            arrowIcon.isHidden = true
            chooseOrganizationButton.isHidden = true
            voucherNameLabel.text = voucher.product?.name ?? ""
            voucherIcon.loadImageUsingUrlString(urlString: voucher.product?.photo?.sizes?.thumbnail ?? "", placeHolder: #imageLiteral(resourceName: "Resting"))
            organizationLabel.text = voucher.product?.organization?.name ?? ""
            allowedOriganizationLabel.text = voucher.product?.organization?.name ?? ""
            organizationIcon.loadImageUsingUrlString(urlString: voucher.product?.photo?.sizes?.thumbnail ?? "", placeHolder: #imageLiteral(resourceName: "Resting"))
            
            var rectNote = self.notesView.frame
            rectNote.origin.y = 70
            self.notesView.frame = rectNote
            heightFieldsConstraint.constant = 160
            
        }else {
            
            voucherNameLabel.text = voucher.fund?.name ?? ""
            voucherIcon.loadImageUsingUrlString(urlString: voucher.fund?.logo?.sizes?.thumbnail ?? "", placeHolder: #imageLiteral(resourceName: "Resting"))
            organizationLabel.text = voucher.fund?.organization?.name ?? ""
            allowedOriganizationLabel.text = voucher.allowed_organizations?.first?.name ?? ""
            organizationIcon.loadImageUsingUrlString(urlString: voucher.allowed_organizations?.first?.logo?.sizes?.thumbnail ?? "", placeHolder: #imageLiteral(resourceName: "Resting"))
            selectedAllowerdOrganization = voucher.allowed_organizations?.first
        }
        
    }
    
    @IBAction func showOrganizations(_ sender: UIButton) {
        let popOverVC = AllowedOrganizationsViewController(nibName: "AllowedOrganizationsViewController", bundle: nil)
        popOverVC.allowedOrganizations = self.voucher.allowed_organizations
        popOverVC.delegate = self
        popOverVC.selectedOrganizations = selectedAllowerdOrganization
        self.addChild(popOverVC)
        popOverVC.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.view.addSubview(popOverVC.view)
    }
    
    
    
}

extension MPaymentViewController: AllowedOrganizationsViewControllerDelegate {
    
    func didSelectAllowedOrganization(organization: AllowedOrganization) {
        
        selectedAllowerdOrganization = organization
        
    }
    
}

extension MPaymentViewController: UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var dotString = ""
        if self.getLanguageISO() == "en"{
            
            dotString = "."
            
        }else if self.getLanguageISO() == "nl" {
            
            dotString = ","
        }
        
        if let text = textField.text {
            let isDeleteKey = string.isEmpty
            
            if !isDeleteKey {
                if text.contains(dotString) {
                    let countdots = textField.text!.components(separatedBy: dotString).count - 1
                    
                    if countdots > 0 && string == dotString
                    {
                        return false
                    }
                    
                    if text.components(separatedBy: dotString)[1].count == 2 {
                        
                        return false
                    }
                }
            }
        }
        return true
    }
    
}
