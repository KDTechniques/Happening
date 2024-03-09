//
//  QRCodeViewModel.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-02-15.
//

import Foundation
import SwiftUI
import Firebase

class QRCodeViewModel: ObservableObject {
    
    // MARK: PROPERTIES
    
    // singleton
    static let shared = QRCodeViewModel()
    
    // reference to viewController class
    let viewController = ViewController()
    
    // reference to CurrentUser class
    let currentUser = CurrentUser.shared
    
    // reference to NetworkManager class
    let networkManager = NetworkManger.shared
    
    // referene to UserDefaults
    let defaults = UserDefaults.standard
    
    // reference to Firestore
    let db = Firestore.firestore()
    
    // a key to identify happening qr code from other qr codes
    let happeningQRIdentityData: String = "https://happening.me/qr/"
    
    // a code that's unique to every user
    @Published var privateCode: String = ""
    
    // controls the generated qr code image
    @Published var generatedQRCodeImage: UIImage?
    
    // image that can be shared among other users that contains the private code
    @Published var readyShareImage: UIImage?
    
    // controls the scanned qr code text
    @Published var scannedQRCodeText: String = ""
    
    // controls the share sheet of the qr code ready share image
    @Published var isPresentedQRCodeShareSheet: Bool = false
    
    // present an action sheet to user to get confirmation whether to reset the private code or not
    @Published var isPresentedQRCodeResetActionSheet: Bool = false
    
    // present am alert item for MyQRCodeView
    @Published var alertItemForMyQRCodeView: AlertItemModel?
    
    @Published var alertItemForQRCodeFromImageSheetView: AlertItemModel?
    
    @Published var isPresentedQRCodeImageErrorAlert: Bool = false {
        didSet {
            if(isPresentedQRCodeImageErrorAlert) {
                alertItemForMyQRCodeView = AlertItemModel(title: "Unable To Load Image", message: "Please try again in a moment.")
            }
        }
    }
    
    // user defaults key name to save the private code
    @Published var privateCodeUserDefaultsKeyName: String = "privateCode"
    
    // present a resetting progress view while resetting the qr code
    @Published var isPresentedResettingProgress: Bool = false
    
    // MARK: ScanQRCodeFromImageSheetView <<-----
    // image from the photo library to scan a qr code
    @Published var QRCodeImageFromPhotoLibrary: UIImage?
    
    // MARK: QRCodeCardView
    // decide whether the background of the qr code card changes or not
    enum QRCodeCardBackgroundColorType {
        case staticColor
        case dynamicColor
    }
    
    // MARK: QRCodeScannerOverlappingView <<-----
    // controls the scanning rectangle effect image scale size
    @Published var qrCodeFinderScale: CGFloat = 1.0
    
    // status of the qr code image added from the photo library
    @Published var isQRCodeImageAddedSucessful: Bool = false
    
    // present a qr code scanner to scan qr codes
    @Published var isPresentedQRCodeScanner = false
    
    // controls the torch status of the qr code scanner
    @Published var isQRCodeScannerTorchOn: Bool = false
    
    // present a photo picker to pick a qr code image from the photo library
    @Published var isPresentedQRCodePhotoPicker = false
    
    // present a sheet to follow a new user
    @Published var isPresentedSheetForFollowingUsers: Bool = false
    
    // present an alert item for PublicProfileInfoSheet
    @Published var isPresentedAlertItemForPublicProfileInfoSheet: AlertItemModel?
    
    // present an alert item for QRCodeScannerOverlappingView
    @Published var alertItemForQRCodeScannerOverlappingView: AlertItemModel?
    
    // firestore snapshot listner register that helps to remove the previous snapshot listener before initializing a new one
    var firestoreListener: ListenerRegistration?
    
    // MARK: FUNCTIONS
    
    
    
    // MARK: fetchPrivateCodeFromFirestore
    func fetchPrivateCodeFromFirestore() {
        
        guard let docID = currentUser.currentUserUID else {
            alertItemForMyQRCodeView = AlertItemModel(title: "Unable To Retrieve Private Code", message: "Please try again in a moment.")
            return
        }
        
        firestoreListener?.remove()
        firestoreListener = db
            .collection("Users")
            .document(docID)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print(error.localizedDescription)
                    self.alertItemForMyQRCodeView = AlertItemModel(title: "Unable To Retrieve Private Code", message: error.localizedDescription)
                    return
                } else {
                    guard let document = snapshot else {
                        self.alertItemForMyQRCodeView = AlertItemModel(title: "Unable To Retrieve Private Code", message: "Please try again in a moment.")
                        return
                    }
                    
                    let code = document.get("privateQRCode") as? String
                    
                    self.defaults.set(code, forKey: self.privateCodeUserDefaultsKeyName)
                    
                    self.privateCode = self.defaults.string(forKey: self.privateCodeUserDefaultsKeyName) ?? ""
                    
                    self.generatedQRCodeImage = UIImage(data: self.getQRCodeData(text: self.privateCode)!)
                    
                    self.renderImage()
                    
                    print("Private QR Code Has Been Fetched From Firestore Successfully. 👨🏻‍💻👨🏻‍💻👨🏻‍💻")
                }
            }
    }
    
    // MARK: updatePrivateCodeInFirestore
    func updatePrivateCodeInFirestore(completionHandler: @escaping (_ status: Bool, _ code: String) -> ()) {
        var code: String = happeningQRIdentityData
        code.append("\(UUID())")
        
        guard let docID = currentUser.currentUserUID else {
            isPresentedResettingProgress = false
            alertItemForMyQRCodeView = AlertItemModel(title: "Unable to Reset QR Code", message: "Please try again in a moment.")
            completionHandler(false, "")
            return
        }
        
        db
            .collection("Users")
            .document(docID)
            .updateData(["privateQRCode":code]) { error in
                if let error = error {
                    print(error.localizedDescription)
                    self.isPresentedResettingProgress = false
                    self.alertItemForMyQRCodeView = AlertItemModel(title: "Unable to Reset QR Code", message: error.localizedDescription)
                    completionHandler(false, "")
                    return
                } else {
                    self.isPresentedResettingProgress = false
                    print("Private QR Code Has Been Upated In  Firestore Successfully. 👍🏻👍🏻👍🏻")
                    completionHandler(true, code)
                }
            }
    }
    
    // MARK: readQRCodeFromImage
    func readQRCodeFromImage(_ image: UIImage?) -> [CIFeature]? {
        if let image = image, let ciImage = CIImage.init(image: image){
            var options: [String: Any]
            let context = CIContext()
            options = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
            let qrDetector = CIDetector(ofType: CIDetectorTypeQRCode, context: context, options: options)
            if ciImage.properties.keys.contains((kCGImagePropertyOrientation as String)){
                options = [CIDetectorImageOrientation: ciImage.properties[(kCGImagePropertyOrientation as String)] ?? 1]
            } else {
                options = [CIDetectorImageOrientation: 1]
            }
            let features = qrDetector?.features(in: ciImage, options: options)
            return features
        }
        return nil
    }
    
    // MARK: onAppearAction
    func onAppearActions() {
        privateCode = defaults.string(forKey: privateCodeUserDefaultsKeyName) ?? ""
        renderImage()
        viewController.viewDidAppear(true)
        fetchPrivateCodeFromFirestore()
    }
    
    // MARK: getQRCodeData
    // this function will generate image data from a qr code text string
    func getQRCodeData(text: String) -> Data? {
        guard let filter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        let data = text.data(using: .ascii, allowLossyConversion: false)
        filter.setValue(data, forKey: "inputMessage")
        guard let ciimage = filter.outputImage else { return nil }
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let scaledCIImage = ciimage.transformed(by: transform)
        let uiimage = UIImage(ciImage: scaledCIImage)
        return uiimage.pngData()!
    }
    
    // MARK: renderImage
    func renderImage() {
        readyShareImage = QRCodeShareCardView().asImage()
    }
    
    // MARK: handleScan
    func handleScan(result: Result<String, CodeScannerView.ScanError>) {
        if(networkManager.connectionStatus == .noConnection) {
            alertItemForQRCodeScannerOverlappingView = AlertItemModel(
                title: "Couldn't Scan",
                message: "Please check your phone's conection and try again.",
                dismissButton: .cancel(Text("OK")) {
                    self.isPresentedQRCodeScanner = false
                }
            )
        } else {
            self.isPresentedQRCodeScanner = false
            switch result {
            case .success(let code):
                if(code.contains(happeningQRIdentityData)){
                    print("Found code: \(code)")
                    scannedQRCodeText = code
                    
                    PublicProfileInfoViewModel.shared.followUserByQRCode(privateQRCodeData: scannedQRCodeText)
                    
                    isPresentedQRCodeScanner = false
                    
                    isPresentedSheetForFollowingUsers = true
                } else {
                    print("Found code is not valid!")
                    isPresentedQRCodeScanner = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.alertItemForMyQRCodeView = AlertItemModel(title: "Invalid QR Code", message: "Please scan a valid QR code.")
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
