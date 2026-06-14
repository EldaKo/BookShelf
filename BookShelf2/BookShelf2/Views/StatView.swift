import SwiftUI
import CoreData

struct StatView: View {
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Book.createdAt, ascending: true)]
    )
    private var books: FetchedResults<Book>

    var totalCount: Int { books.count }
    var finishedCount: Int { books.filter { $0.status == "완독" }.count }
    var readingCount: Int { books.filter { $0.status == "읽는중" }.count }
    var wishCount: Int { books.filter { $0.status == "읽고싶음" }.count }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {

                    HStack(spacing: 12) {
                        StatCard(title: "전체", value: "\(totalCount)", color: .blue)
                        StatCard(title: "완독", value: "\(finishedCount)", color: .green)
                    }
                    HStack(spacing: 12) {
                        StatCard(title: "읽는중", value: "\(readingCount)", color: .orange)
                        StatCard(title: "읽고싶음", value: "\(wishCount)", color: .gray)
                    }
                    .padding(.horizontal)

                    // 완독 비율 바
                    VStack(alignment: .leading, spacing: 8) {
                        Text("완독률")
                            .font(.headline)

                        let ratio = totalCount == 0 ? 0.0 : Double(finishedCount) / Double(totalCount)

                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(height: 20)
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color.green)
                                    .frame(width: geo.size.width * CGFloat(ratio), height: 20)
                            }
                        }
                        .frame(height: 20)

                        Text("\(Int(ratio * 100))%")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal)

                    Spacer()
                }
                .padding(.top)
            }
            .navigationTitle("통계")
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let color: Color

    var body: some View {
        VStack(spacing: 6) {
            Text(value)
                .font(.title)
                .bold()
                .foregroundColor(color)
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}

