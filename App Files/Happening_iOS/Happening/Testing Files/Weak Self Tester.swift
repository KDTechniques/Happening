//
//  Testing 3.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-01-27.
//

import SwiftUI

struct Testing_3: View {
    
    @AppStorage("count") var count: Int?
    
    var body: some View {
        NavigationView {
            NavigationLink("Navigate") {
                WeakSelfSecondScreen()
            }
            .navigationTitle("Screen 1")
        }
        .overlay(
            Text("\(count ?? 0)")
                .font(.largeTitle)
                .padding()
                .background(Color.green.cornerRadius(10))
            , alignment: .topTrailing)
    }
}

struct WeakSelfSecondScreen: View {
    
    @StateObject var vm = WeakSelfSecondScreenViewModel()
    
    var body: some View {
        VStack {
            Text("Second View")
                .font(.largeTitle)
                .foregroundColor(.red)
            
            if let data = vm.data {
                Text(data)
            }
        }
    }
}

class WeakSelfSecondScreenViewModel: ObservableObject {
    @Published var data: String? = nil
    
    init() {
        print("INITIALIZED")
        let currentCount = UserDefaults.standard.integer(forKey: "count")
        UserDefaults.standard.set(currentCount + 1, forKey: "count")
        getData()
    }
    
    deinit {
        print("DEINITIALIZED")
        let currentCount = UserDefaults.standard.integer(forKey: "count")
        UserDefaults.standard.set(currentCount - 1, forKey: "count")
    }
    
    func getData() {
        DispatchQueue.global().asyncAfter(deadline: .now() + 10) { [weak self] in
            let data = "New Data Set"
            print("Excecuted in the background tread")
            DispatchQueue.main.async {
                self?.data = data
                print("data 2: \(self?.data ?? "nil")")
            }
        }
    }
}

struct Testing_3_Previews: PreviewProvider {
    static var previews: some View {
        Testing_3()
    }
}
