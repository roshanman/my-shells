import AppKit
import Foundation

if !(NSPasteboard.general.types?.contains(NSPasteboard.PasteboardType.string) ?? false) {
    print("请将待解析的原始数据拷贝到剪切板")
    exit(-1)
}

let base64HRString = (NSPasteboard.general.string(forType: NSPasteboard.PasteboardType.string) ?? "")
    .trimmingCharacters(in: CharacterSet.whitespaces)
    .trimmingCharacters(in: CharacterSet.newlines)

guard let data = Data(base64Encoded: base64HRString), data.count == 1440 else {
    print("无效的输入数据")
    exit(-1)
}

func formatedIndex(_ index: Int) -> String {
    return String(format: "%2d:%02d", index / 60, index % 60)
}

for (index, element) in data.enumerated() {
    let s = String(format: "%@> %d", formatedIndex(Int(index)), element)
    print(s)
}

