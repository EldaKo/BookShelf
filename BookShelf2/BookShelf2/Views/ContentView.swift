import SwiftUI

struct ContentView: View {
    let context = PersistenceController.shared.container.viewContext

    var body: some View {
        TabView {
            BookListView()
                .environment(\.managedObjectContext, context)
                .tabItem {
                    Label("내 책장", systemImage: "books.vertical.fill")
                }

            StatView()
                .environment(\.managedObjectContext, context)
                .tabItem {
                    Label("통계", systemImage: "chart.bar.fill")
                }
        }
    }
}
