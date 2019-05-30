//
//  RecordDetailViewModel.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/27/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import Foundation


class RecordDetailViewModel {
    
    var commonService: CommonServiceProtocol!
    
    private var cellViewModels: [Validator] = [Validator]()
    
    var completeDelete: ((Int)->())?
    
    init(commonService: CommonServiceProtocol = CommonService()) {
        self.commonService = commonService
    }
    
    var complete: ((Record)->())?
    
    func initFetchById(id: String) {
        
        commonService.getById(request: "identity/records/", id: id, complete: { (response: Record, statusCode) in
            self.processFetchedLunche(validators: response.validations ?? [])
            self.complete?(response)
            
        }) { (error) in
            
        }
        
    }
    
    func initDeleteById(id: String) {
        
        commonService.deleteById(request: "identity/records/", id: id, complete: { (statusCode) in
            self.completeDelete?(statusCode)
        }) { (error) in
            
        }
        
    }
    
    
    var numberOfCells: Int {
        return cellViewModels.count
    }
    
    func getCellViewModel( at indexPath: IndexPath ) -> Validator {
        return cellViewModels[indexPath.row]
    }
    
    func createCellViewModel( validator: Validator ) -> Validator {
        
        return validator
    }
    
    private func processFetchedLunche( validators: [Validator] ) {
        var vms = [Validator]()
        for validator in validators {
            
            vms.append( createCellViewModel(validator: validator) )
        }
        
        self.cellViewModels = vms.removingDuplicates()
    }
}
