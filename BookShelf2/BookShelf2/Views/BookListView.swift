import SwiftUI
import CoreData

struct BookListView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Book.createdAt, ascending: false)]
    )
    private var books: FetchedResults<Book>

    @State private var showAddSheet = false
    @State private var selectedFilter = "전체"

    let filters = ["전체", "읽는중", "완독", "읽고싶음"]

    var filteredBooks: [Book] {
        if selectedFilter == "전체" {
            return Array(books)
        } else {
            return books.filter { $0.status == selectedFilter }
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                Picker("상태", selection: $selectedFilter) {
                    ForEach(filters, id: \.self) { filter in
                        Text(filter).tag(filter)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                List {
                    ForEach(filteredBooks, id: \.id) { book in
                        BookRow(book: book)
                    }
                    .onDelete(perform: deleteBooks)
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("BookShelf")
            .navigationBarItems(
                trailing: Button(action: { showAddSheet = true }) {
                    Image(systemName: "plus.circle.fill")
                }
            )
            .sheet(isPresented: $showAddSheet) {
                AddBookView()
                    .environment(\.managedObjectContext, viewContext)
            }
        }
    }

    private func deleteBooks(at offsets: IndexSet) {
        let vm = BookViewModel(context: viewContext)
        for index in offsets {
            vm.deleteBook(book: filteredBooks[index])
        }
    }
}

struct BookRow: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var book: Book

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(book.title ?? "")
                .font(.headline)
            Text(book.author ?? "")
                .font(.subheadline)
                .foregroundColor(.gray)

            HStack {
                Text(book.category ?? "")
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(6)

                Spacer()

                Picker("", selection: Binding(
                    get: { book.status ?? "읽고싶음" },
                    set: { newValue in
                        let vm = BookViewModel(context: viewContext)
                        vm.updateStatus(book: book, newStatus: newValue)
                    }
                )) {
                    Text("읽는중").tag("읽는중")
                    Text("완독").tag("완독")
                    Text("읽고싶음").tag("읽고싶음")
                }
                .pickerStyle(MenuPickerStyle())
            }
        }
        .padding(.vertical, 4)
    }
}
