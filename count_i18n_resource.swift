import AppKit
import Foundation

if !(NSPasteboard.general.types?.contains(NSPasteboard.PasteboardType.string) ?? false) {
    print("请将待解析的原始数据拷贝到剪切板")
    exit(-1)
}

class I18nKeyCount: NSObject, Comparable {
    let key: String
    var files: [String]

    init(key: String, files: [String]) {
        self.key = key
        self.files = files
        super.init()
    }

    override var description: String {
        let distinceFiles = Set(files)
            .compactMap { $0.split(separator: ":").first }
            .sorted()
        return "\(key) \(files.count)\n    \(distinceFiles.joined(separator: "\n    "))"
    }

    static func < (lhs: I18nKeyCount, rhs: I18nKeyCount) -> Bool {
        return lhs.files.count < rhs.files.count
    }
}

let texts = (NSPasteboard.general.string(forType: NSPasteboard.PasteboardType.string) ?? "")
    .split(separator: "\n")
    .map { "\($0)".trimmingCharacters(in: .whitespacesAndNewlines) }
    .filter { !$0.isEmpty }

var allI18ns = [I18nKeyCount]()

var currentI18n: I18nKeyCount!

for i in texts {
    if i.hasPrefix("##") {
        if let current = allI18ns.first(where: { $0.key == i }) {
            currentI18n = current
        } else {
            currentI18n = I18nKeyCount(
                key: i,
                files: []
            )
            allI18ns.append(currentI18n)
        }
    } else {
        currentI18n.files.append(i)
    }
}

for i in allI18ns.sorted(by:>) {
    print(i.description)
}
