import AppKit
import Foundation

if !(NSPasteboard.general.types?.contains(NSPasteboard.PasteboardType.string) ?? false) {
    print("请将待解析的原始数据拷贝到剪切板")
    exit(-1)
}

struct DumplicatedImages: Comparable {
    let key: String

    var size: Int {
        return Int(String(key.split(separator: " ")[0]))!
    }

    var totalSize: Int { files.count * size }

    var files: [String]

    var description: String {
        let distinceFiles = files
            .compactMap { $0.split(separator: ":").first }
            .sorted()
        return "\(key) \(files.count)*\(size)=\(totalSize)\n    \(distinceFiles.joined(separator:("\n    ")))"
    }

    static func <(lhs: DumplicatedImages, rhs: DumplicatedImages) -> Bool {
        return lhs.totalSize < rhs.totalSize
    }
}

let texts = (NSPasteboard.general.string(forType: NSPasteboard.PasteboardType.string) ?? "")
    .split(separator: "\n")
    .map {"\($0)".trimmingCharacters(in: .whitespacesAndNewlines)}
    .filter {!$0.isEmpty}

var allDumplicatedImages = [DumplicatedImages]()

var current: DumplicatedImages!

for i in texts {
    if i.contains("each:") {
        if current != nil {
            allDumplicatedImages.append(current)
        }
        current = DumplicatedImages(
            key: i,
            files: []
        )
    } else {
        current.files.append(i)
    }
}

allDumplicatedImages.append(current)

// for i in allDumplicatedImages.sorted(by:>) {
//     print(i.description, "\n")
// }

print("totalcount: \(allDumplicatedImages.reduce(0) { $0 + $1.files.count })")

print("totalSize: \(allDumplicatedImages.reduce(0) { $0 + $1.totalSize })")


let x = allDumplicatedImages.filter {
    $0.files.count != Set($0.files).count
}

for i in x.sorted(by:>) {
    print(i.description, "\n")
}