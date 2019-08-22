//
//  MProductReservationViewController.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 8/22/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import UIKit

class MProductReservationViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    lazy var qrViewModel: QRViewModel = {
        return QRViewModel()
    }()
    
    var voucherTokens: [Transaction]! = []
    var voucher: Voucher!
    var vc: MQRViewController!
    var selectedProduct: Voucher!
    var tabBar: UITabBarController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        qrViewModel.vcAlert = self
        

        qrViewModel.getVoucher = { [weak self] (voucher, statusCode) in
            DispatchQueue.main.async {
                self?.selectedProduct = voucher
                self?.performSegue(withIdentifier: "goToPaymentFromSelected", sender: nil)
            }
            
        }
           
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToPaymentFromSelected" {
        if let paymentVC = segue.destination as? MPaymentViewController {
            
            paymentVC.voucher = selectedProduct
            paymentVC.tabBar = self.tabBarController
            
        }
        }else if segue.identifier == "goToPaymentSimple" {
            if let paymentVC = segue.destination as? MPaymentViewController {
                
                paymentVC.voucher = voucher
                paymentVC.tabBar = self.tabBarController
                
            }
        }
    }
 

}

extension MProductReservationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return voucherTokens.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProductReservationTableViewCell
        
        cell.productReservation = voucherTokens[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.qrViewModel.initVoucherAddress(address: voucherTokens[indexPath.row].address ?? "")
       
    }
}
