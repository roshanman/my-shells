import AppKit
import Foundation

if !(NSPasteboard.general.types?.contains(NSPasteboard.PasteboardType.string) ?? false) {
    print("请将待解析的原始数据拷贝到剪切板")
    exit(-1)
}

let base64String = (NSPasteboard.general.string(forType: NSPasteboard.PasteboardType.string) ?? "")
    .trimmingCharacters(in: CharacterSet.whitespaces)
    .trimmingCharacters(in: CharacterSet.newlines)

guard let data = Data(base64Encoded: base64String), data.count == 1440 * 8 else {
    print("无效的输入数据")
    exit(-1)
}

func formatedIndex(_ index: Int) -> String {
    return String(format: "%2d:%02d", index / 60, index % 60)
}

// https://confluence.huami.com/pages/viewpage.action?pageId=63977491
print(String(format: "\t%@ \t%@ \t%@ \t%@ \t%@ \t%@ \t%@ \t%@ \t%@", "time", "mode", "Active", "step", "hr", "ext1", "ext2", "ext3", "ext4"))

func splitArray<T>(_ array: [T], size: Int) -> [[T]] {
    Dictionary(grouping: array.enumerated(), by: { $0.offset / size })
        .sorted { $0.key < $1.key }
        .map { $0.value.map { $0.element } }
}

for (index, element) in splitArray(data.map { $0 }, size: 8).enumerated() {
    let s = String(format: "\t%@\t%4d\t%4d\t%4d\t%4d\t%4d\t%4d\t%4d\t%4d ", formatedIndex(Int(index)), element[0], element[1], element[2], element[3], element[4], element[5], element[6], element[7])
    print(s)
}

let totalStep = splitArray(data.map { $0 }, size: 8).map { Int($0[2]) }.reduce(0, +)

print("totalStep: \(totalStep)")
