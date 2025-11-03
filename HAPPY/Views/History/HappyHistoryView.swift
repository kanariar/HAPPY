import SwiftUI

// MARK: - History View
struct HappyHistoryView: View {
    @Binding var happyEntries: [HappyEntry]
    @State private var searchText = ""
    @FocusState private var isSearchFocused: Bool
    
    /// フィルタリングされたエントリー
    private var filteredEntries: [HappyEntry] {
        let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmed.isEmpty else {
            return happyEntries
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        
        return happyEntries.filter { entry in
            // テキストで検索
            let textMatch = entry.text.localizedCaseInsensitiveContains(trimmed)
            
            // 日付で検索
            let dateMatch = matchesDateFormats(entry.date, searchText: trimmed, formatter: dateFormatter)
            
            return textMatch || dateMatch
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                searchBar
                searchResultsInfo
                contentArea
            }
            .navigationTitle("履歴")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if !happyEntries.isEmpty && searchText.isEmpty {
                    EditButton()
                }
            }
            .onTapGesture {
                isSearchFocused = false
            }
        }
    }
    
    /// 検索バー
    private var searchBar: some View {
        HStack(spacing: 10) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("内容や日付で検索", text: $searchText)
                    .focused($isSearchFocused)
                
                if !searchText.isEmpty {
                    Button(action: { searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(Color(.systemGray6))
            .cornerRadius(10)
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(Color(.systemBackground))
    }
    
    /// 検索結果情報
    private var searchResultsInfo: some View {
        Group {
            if !searchText.isEmpty {
                HStack {
                    Text("\(filteredEntries.count)件見つかりました")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.vertical, 5)
                .background(Color(.systemGroupedBackground))
            }
        }
    }
    
    /// コンテンツエリア
    private var contentArea: some View {
        ZStack {
            if happyEntries.isEmpty {
                emptyStateView
            } else if filteredEntries.isEmpty {
                noSearchResultsView
            } else {
                entriesList
            }
        }
    }
    
    /// 空の状態ビュー
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "heart.text.square")
                .font(.system(size: 60))
                .foregroundColor(.gray.opacity(0.5))
            
            Text("まだ記録がありません")
                .font(.headline)
                .foregroundColor(.gray)
            
            Text("「貯金」ボタンから\nしあわせを記録しよう!")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 250)
        .padding(.bottom, 180)
    }
    
    /// 検索結果なしビュー
    private var noSearchResultsView: some View {
        VStack(spacing: 20) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 60))
                .foregroundColor(.gray.opacity(0.5))
            
            Text("検索結果がありません")
                .font(.headline)
                .foregroundColor(.gray)
            
            Text("「\(searchText)」に一致する\n記録が見つかりませんでした")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 250)
        .padding(.bottom, 190)
    }
    
    /// エントリーリスト
    private var entriesList: some View {
        List {
            ForEach(filteredEntries) { entry in
                HappyEntryRow(entry: entry, searchText: searchText)
            }
            .onDelete(perform: deleteEntries)
        }
        .listStyle(.insetGrouped)
    }
    
    /// 日付フォーマットとの一致をチェック
    private func matchesDateFormats(
        _ date: Date,
        searchText: String,
        formatter: DateFormatter
    ) -> Bool {
        let formats = ["yyyy/MM/dd", "yyyy年M月d日", "M月d日", "M/d"]
        
        for format in formats {
            formatter.dateFormat = format
            let dateString = formatter.string(from: date)
            if dateString.localizedCaseInsensitiveContains(searchText) {
                return true
            }
        }
        return false
    }
    
    /// エントリーを削除
    private func deleteEntries(at offsets: IndexSet) {
        let entriesToDelete = offsets.map { filteredEntries[$0] }
        happyEntries.removeAll { entry in
            entriesToDelete.contains { $0.id == entry.id }
        }
    }
}
