import SwiftUI

struct AddBookView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) private var viewContext

    @State private var title = ""
    @State private var author = ""
    @State private var category = "소설"
    @State private var status = "읽고싶음"

    let categories = ["소설", "자기계발", "에세이", "IT/기술", "인문", "기타"]
    let statuses = ["읽고싶음", "읽는중", "완독"]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("책 정보")) {
                    TextField("제목", text: $title)
                    TextField("저자", text: $author)
                }
                Section(header: Text("분류")) {
                    Picker("카테고리", selection: $category) {
                        ForEach(categories, id: \.self) { Text($0) }
                    }
                    Picker("독서 상태", selection: $status) {
                        ForEach(statuses, id: \.self) { Text($0) }
                    }
                }
            }
            .navigationTitle("책 추가")
            .navigationBarItems(
                leading: Button("취소") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("저장") {
                    saveBook()
                }
                .disabled(title.isEmpty || author.isEmpty)
            )
        }
    }

    private func saveBook() {
        let vm = BookViewModel(context: viewContext)
        vm.addBook(title: title, author: author, category: category, status: status)
        presentationMode.wrappedValue.dismiss()
    }
}
