//
//  PendingApprovalViewModel.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-02-16.
//

import Foundation
import Firebase

class PendingApprovalViewModel: ObservableObject {
    
    // MARK: PROPERTIES
    
    // singleton
    static let shared = PendingApprovalViewModel()
    
    // reference to firestore datatbase
    let db = Firestore.firestore()
    
    // shows an alert in the PendingApproalView
    @Published var alertForPendingApprovalView: AlertItemModel?
    
    // store all the document ids where isApproved field is false
    @Published var documentsIDArray = [String]()
    // store all the documents of one purticular documentID
    @Published var documentsDataArray = [PendingApprovalModel]()
    
    // MARK: FUNCTIONS
    
    
    
    // MARK: getDocumentsID
    func getDocumentIDs(completionHandler: @escaping (_ status: Bool) ->()) {
        
        let reference = db
            .collection("Users")
            .whereField("isApproved", isEqualTo: false)
        
        reference.addSnapshotListener { querySnapshot, error in
            if let error = error {
                self.alertForPendingApprovalView = AlertItemModel(title: "Unable to Get Documents", message: error.localizedDescription)
                print("Error: \(error.localizedDescription)")
                completionHandler(false)
            } else {
                guard let querySnapshot = querySnapshot else { return }
                
                self.documentsIDArray.removeAll() // for safty reasons
                for document in querySnapshot.documents {
                    self.documentsIDArray.append(document.documentID)
                }
                completionHandler(true)
            }
        }
    }
    
    // MARK: getDocumentsData
    func getDocumetsData(docID: String, completionHandler: @escaping (_ status: Bool) ->()) {
        
        let reference = db.collection("Users/\(docID)/PendingApprovalData")
        
        reference.getDocuments { querySnapshot, error in
            if let error = error {
                self.alertForPendingApprovalView = AlertItemModel(title: "Unable to Get Document Data", message: error.localizedDescription)
                print("Error: \(error.localizedDescription)")
                completionHandler(false)
            } else {
                guard let querySnapshot = querySnapshot else { return }
                
                for document in querySnapshot.documents {
                    // data of a given document ID
                    let data = document.data()
                    UserDataViewModel.shared.data = data
                    
                    self.documentsDataArray.removeAll() // for safty reasons
                    let object = PendingApprovalModel(data: data)
                    
                    self.documentsDataArray.append(object)
                }
                completionHandler(true)
            }
        }
    }
}
