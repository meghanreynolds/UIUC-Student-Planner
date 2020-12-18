import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Text("Home")
                    Image(systemName: "house.fill")
                }
            CourseView()
                .tabItem {
                    Text("Courses")
                    Image(systemName: "book.fill")
                        .foregroundColor(.blue)
                }
            Settings()
                .tabItem {
                    Text("Settings")
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

