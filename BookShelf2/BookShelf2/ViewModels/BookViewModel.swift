import Foundation
import CoreData

class BookViewModel: ObservableObject {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    // 책 추가
    func addBook(title: String, author: String, category: String, status: String) {
        let newBook = Book(context: context)
        newBook.id = UUID()
        newBook.title = title
        newBook.author = author
        newBook.category = category
        newBook.status = status
        newBook.createdAt = Date()

        if status == "완독" {
            newBook.finishedAt = Date()
        }

        save()
    }

    // 상태 변경 (읽는중 -> 완독 등)
    func updateStatus(book: Book, newStatus: String) {
        book.status = newStatus
        if newStatus == "완독" && book.finishedAt == nil {
            book.finishedAt = Date()
        }
        save()
    }

    // 책 삭제
    func deleteBook(book: Book) {
        context.delete(book)
        save()
    }

    private func save() {
        do {
            try context.save()
        } catch {
            print("저장 실패: \(error.localizedDescription)")
        }
    }
}
