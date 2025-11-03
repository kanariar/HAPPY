import SwiftUI

// MARK: - History Row
struct HappyEntryRow: View {
    let entry: HappyEntry
    var searchText: String = ""
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            iconSection
            contentSection
            Spacer()
        }
        .padding(.vertical, 8)
    }
    
    /// アイコンセクション
    private var iconSection: some View {
        VStack(spacing: 2) {
            if entry.isWithdrawal {
                withdrawalIcon
            } else {
                depositIcon
            }
        }
        .frame(width: 60)
        .padding(.top, 4)
    }
    
    /// 出金アイコン
    private var withdrawalIcon: some View {
        Group {
            Image(systemName: "arrow.down.circle.fill")
                .foregroundColor(.orange)
                .font(.title3)
            
            Text("-\(entry.amount ?? 0)")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.orange)
        }
    }
    
    /// 入金アイコン
    private var depositIcon: some View {
        Group {
            Image(systemName: "heart.fill")
                .foregroundColor(Color.forLevel(entry.level))
                .font(.title3)
            
            Text("\(LevelConfig.displayValue(for: entry.level))")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(Color.forLevel(entry.level, isDark: true))
        }
    }
    
    /// コンテンツセクション
    private var contentSection: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(formattedDate(entry.date))
                .font(.caption)
                .foregroundColor(.gray)
            
            if searchText.isEmpty {
                Text(entry.text)
                    .font(.caption)
                    .fontWeight(.medium)
                    .fixedSize(horizontal: false, vertical: true)
            } else {
                highlightedText(entry.text, searchText: searchText)
                    .font(.caption)
                    .fontWeight(.medium)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
    
    /// ハイライト付きテキスト
    private func highlightedText(_ text: String, searchText: String) -> Text {
        guard !searchText.isEmpty else {
            return Text(text)
        }
        
        var result = Text("")
        let lowercasedText = text.lowercased()
        let lowercasedSearch = searchText.lowercased()
        var searchStartIndex = lowercasedText.startIndex
        
        while let range = lowercasedText.range(
            of: lowercasedSearch,
            range: searchStartIndex..<lowercasedText.endIndex
        ) {
            // マッチ前のテキスト
            if searchStartIndex < range.lowerBound {
                let beforeRange = searchStartIndex..<range.lowerBound
                let beforeText = String(text[beforeRange])
                result = result + Text(beforeText)
            }
            
            // マッチしたテキスト（ハイライト）
            let matchRange = range.lowerBound..<range.upperBound
            let matchText = String(text[matchRange])
            result = result + Text(matchText)
                .foregroundColor(.pink)
                .fontWeight(.bold)
            
            searchStartIndex = range.upperBound
        }
        
        // 残りのテキスト
        if searchStartIndex < text.endIndex {
            let remainingText = String(text[searchStartIndex..<text.endIndex])
            result = result + Text(remainingText)
        }
        
        return result
    }
    
    /// 日付をフォーマット
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter.string(from: date)
    }
}
