//
//  CloudKitManager.swift
//  Golgi-Splash
//
//  Created by Marwan Zaarab on 2021-01-01.
//

import CloudKit

class CloudKitManager {
    // MARK: - Properties
    var recordID: CKRecord.ID? {
        CKRecord.ID(recordName: UUID().uuidString)
    }
       private let container = CKContainer.default()

       // MARK: -

       private(set) var accountStatus: CKAccountStatus = .couldNotDetermine

       // MARK: - Initialization

       init() {
           // Request Account Status
        CKContainer.default().discoverUserIdentity(withUserRecordID: self.recordID!) { identity, error in
            guard let components = identity?.nameComponents, error == nil else {
                // more error handling magic
                return
            }

            DispatchQueue.main.async {
                let fullName = PersonNameComponentsFormatter().string(from: components)
                print("The user's full name is \(fullName)")
            }
        }
        isCloudAccountAvailableASync()
        print("iCloud available")
           requestAccountStatus()
        
        // Setup Notification Handling
          setupNotificationHandling()
       }

       // MARK: - Helper Methods

       private func requestAccountStatus() {
           // Request Account Status
           container.accountStatus { [unowned self] (accountStatus, error) in
               // Print Errors
               if let error = error { print(error) }

               // Update Account Status
               self.accountStatus = accountStatus
           }
       }
    // MARK: - Notification Handling

    @objc private func accountDidChange(_ notification: Notification) {
        // Request Account Status
        DispatchQueue.main.async { self.requestAccountStatus() }
    }
    
    fileprivate func setupNotificationHandling() {
        // Helpers
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(accountDidChange(_:)), name: Notification.Name.CKAccountChanged, object: nil)
    }
    
    func reactToiCloudloginChanges() {
        NotificationCenter.default.addObserver(self,  selector: #selector(accountDidChange(_:)),
                                               name: Notification.Name.CKAccountChanged,
                                               object: nil)
    }
    
    //EXTRA added from https://sagar-r-kothari.github.io/icloud/2020/01/28/Swift-iCloud-check.html
    
    func isCloudAccountAvailableASync() {
        container.accountStatus { (accountStatus, error) in

        switch accountStatus {
        case .available:
          print("INFO: iCloud Available!")
          // begin sync process by finding the current iCloud user
            CKContainer.default().fetchUserRecordID { recordID, error in
                guard let recordID = recordID, error == nil else {
                    // error handling magic
                    return
                }
               
                print("Got user record ID \(recordID.recordName).")
            }
            // `recordID` is the record ID returned from CKContainer.fetchUserRecordID
            CKContainer.default().publicCloudDatabase.fetch(withRecordID: self.recordID!) { record, error in
                guard let record = record, error == nil else {
                    // show off your error handling skills
                    return
                }

                print("The user record is: \(record)")
            }
            CKContainer.default().requestApplicationPermission(.userDiscoverability) { status, error in
                guard status == .granted, error == nil else {
                    // error handling voodoo
                    
                    return
                }

                CKContainer.default().discoverUserIdentity(withUserRecordID: self.recordID!) { identity, error in
                    guard let components = identity?.nameComponents, error == nil else {
                        // more error handling magic
                        return
                    }

                    DispatchQueue.main.async {
                        let fullName = PersonNameComponentsFormatter().string(from: components)
                        print("The user's full name is \(fullName)")
                    }
                }
            }
          return
        case .noAccount:
          print("INFO: No iCloud account")
        case .restricted:
        print("WARNING: iCloud restricted")
        case .couldNotDetermine:
          print("WARNING: Unable to determine iCloud status")
        @unknown default:
            print("Uknown error: isCloudAccountAvailableSync")
        }

        // if you get here, no sync happened so make sure to exec the callback
        
      }
    }
    
}


