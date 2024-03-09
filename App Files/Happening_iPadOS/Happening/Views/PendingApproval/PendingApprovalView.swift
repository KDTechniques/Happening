//
//  PendingApprovalView.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2021-11-04.
//

import SwiftUI
import Firebase

struct PendingApprovalView: View {
    
    @EnvironmentObject var pendingApprovalViewModel: PendingApprovalViewModel
    @EnvironmentObject var userDataViewModel: UserDataViewModel
    
    // MARK: BODY
    var body: some View {
        NavigationView {
            if(userDataViewModel.showList) {
                if(!pendingApprovalViewModel.documentsIDArray.isEmpty) {
                    List(pendingApprovalViewModel.documentsIDArray, id: \.self) { item in
                        NavigationLink(item) {
                            UserDataView(item: Binding.constant(item))
                        }
                    }
                    .navigationTitle("Pending Approval")
                } else {
                    VStack {
                        Text("No Pending Approvals Are Available\n😕😕😕")
                            .multilineTextAlignment(.center)
                            .font(.largeTitle.weight(.heavy))
                    }
                }
            } else {
                ProgressView()
                    .scaleEffect(1.2)
            }
        }
        .navigationViewStyle(.stack)
        .refreshable {
            userDataViewModel.showUserDataView()
        }
        .onAppear {
            userDataViewModel.showUserDataView()
        }
        .alert(item: $pendingApprovalViewModel.alertForPendingApprovalView) { alert -> Alert in
            Alert(
                title: Text(alert.title),
                message: Text(alert.message)
            )
        }
    }
}

struct PendingApprovalView_Previews: PreviewProvider {
    static var previews: some View {
        PendingApprovalView()
            .previewInterfaceOrientation(.landscapeLeft)
            .navigationViewStyle(.columns)
            .environmentObject(UserDataViewModel())
            .environmentObject(PendingApprovalViewModel())
    }
}
