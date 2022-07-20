import AppKit
import Foundation

let path = CommandLine.arguments[1]
let key = (CommandLine.arguments[2] as NSString).replacingOccurrences(of: "\"", with: "")

guard let dic = NSDictionary(contentsOf: URL(fileURLWithPath: path)) else {
    exit(-1)
}

var value = dic[key] as? String ?? ""
value=value.replacingOccurrences(of: "\n", with: "\\n")
value=value.replacingOccurrences(of: "\t", with: "\\t")

debugPrint(value)