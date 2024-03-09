//
//  QRCodeScannerOverlappingView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-01-04.
//

import SwiftUI

struct QRCodeScannerOverlappingView: View {
    
    // MARK: PROPERTIES
    @EnvironmentObject var qrCodeViewModel: QRCodeViewModel
    
    // MARK: BODY
    var body: some View {
        ZStack {
            // command label
            VStack{
                Text("Find a code to scan")
                    .font(.body.weight(.medium))
                    .foregroundColor(Color.white)
                    .padding()
                    .background(Color.black.opacity(0.6))
                    .background(.ultraThinMaterial)
                    .cornerRadius(15)
                    .padding(.top, 50)
                
                Spacer()
            }
            
            // square image that looks like scanning
            Image(systemName: "viewfinder")
                .font(.system(size: 300).weight(.ultraLight))
                .foregroundColor(Color.white)
                .shadow(color: Color.black.opacity(0.3), radius: 3, x: 0, y: 0)
                .scaleEffect(qrCodeViewModel.qrCodeFinderScale)
                .onAppear {
                    let baseAnimation = Animation.easeInOut(duration: 0.6)
                    let repeated = baseAnimation.repeatForever(autoreverses: true)
                    withAnimation(repeated) {
                        qrCodeViewModel.qrCodeFinderScale = 0.92
                    }
                }
                .onDisappear(perform: { qrCodeViewModel.qrCodeFinderScale = 1.0 })
            
            VStack {
                // xmark button
                HStack{
                    Button {
                        qrCodeViewModel.isPresentedQRCodeScanner = false
                    } label: {
                        Image(systemName: "xmark")
                            .font(.title.weight(.medium))
                            .foregroundColor(Color.white)
                    }
                    
                    Spacer()
                    
                    // flasher button
                    Button {
                        qrCodeViewModel.isQRCodeScannerTorchOn.toggle()
                        torchOperator(on: qrCodeViewModel.isQRCodeScannerTorchOn)
                    } label: {
                        Image(systemName: qrCodeViewModel.isQRCodeScannerTorchOn
                              ? "bolt.fill"
                              : "bolt.slash.fill")
                            .font(.title)
                            .foregroundColor(qrCodeViewModel.isQRCodeScannerTorchOn ? Color.yellow : Color.white)
                    }
                }
                .padding()
                
                Spacer()
                
                // my code button
                Button {
                    qrCodeViewModel.isPresentedQRCodeScanner = false
                } label: {
                    Text("My Code")
                        .fontWeight(.medium)
                        .padding(.vertical)
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(14)
                }
                
                .padding(.horizontal, 60)
                .background(alignment: .leading) {
                    // button to open photo library
                    Button {
                        qrCodeViewModel.isPresentedQRCodeScanner = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            qrCodeViewModel.isPresentedQRCodePhotoPicker = true
                        }
                    } label: {
                        Image(systemName: "photo")
                            .font(.title)
                            .foregroundColor(Color.white)
                    }
                }
                .padding(.bottom, 50)
            }
            .padding()
        }
        .onAppear(perform: { qrCodeViewModel.isQRCodeScannerTorchOn = false })
        .alert(item: $qrCodeViewModel.alertItemForQRCodeScannerOverlappingView) { alert -> Alert in
            Alert(
                title: Text(alert.title),
                message: Text(alert.message),
                dismissButton: alert.dismissButton
            )
        }
    }
}

// MARK: PREVIEWS
struct QRCodeScannerOverlappingView_Previews: PreviewProvider {
    static var previews: some View {
        QRCodeScannerOverlappingView()
            .preferredColorScheme(.dark)
            .environmentObject(QRCodeViewModel())
    }
}
