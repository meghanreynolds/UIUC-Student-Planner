import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Text("home")
                    Image(systemName: "house.fill")
                }
            CourseView()
                .tabItem {
                    Text("course")
                    Image(systemName: "book.fill")
                        .foregroundColor(.blue)
                }
            Settings()
                .tabItem {
                    Text("settings")
                    Image(systemName: "gear")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

