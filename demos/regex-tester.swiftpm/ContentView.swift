import SwiftUI

struct ContentView: View {
    let search1 = /My name is (.+?) and I'm (\d+) years old./
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .onAppear(perform: {
            Test()
        })
    }
    func Test() {
        
        let search1 = /My name is (.+?) and I'm (\d+) years old./
        //let search1 = try! Regex("My name is [.+?] and I'm [\\d+] years old.")
        let greeting1 = "My name is Taylor and I'm 26 years old."
        
        if let result = try? search1.wholeMatch(in: greeting1) {
            print("Name: \(result.1)")
            print("Age: \(result.2)")
            //    print(result)
        }

    }
}
