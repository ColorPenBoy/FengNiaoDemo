import Foundation
import CommandLineKit
import Rainbow

print("Hello, Swift Command Line Tool!")


let cli = CommandLineKit.CommandLine()

let projectOption = StringOption(shortFlag: "p", longFlag: "project", required: true, helpMessage: "Path to Project.")

let excludePathsOption = MultiStringOption(shortFlag: "e", longFlag: "exclude", helpMessage: "Excluded paths which should not search in.")

let resourceExtensionOption = MultiStringOption(shortFlag: "r", longFlag: "resource-extensions", helpMessage: "Extension to search.")

let fileExtensionOption = MultiStringOption(shortFlag: "f", longFlag: "file-extensions", helpMessage: "File extensions to search with.")

let help = BoolOption(shortFlag: "h", longFlag: "help", helpMessage: "Prints a help message.")

let verbosity = CounterOption(shortFlag: "v", longFlag: "verbose", helpMessage: "Print verbose messages. Specify multiple times to increase verbosity.")

cli.addOptions(projectOption, resourceExtensionOption, fileExtensionOption, help, verbosity)
cli.formatOutput = { s, type in
    var str: String
    switch(type) {
    case .error:
        str = s.red.bold
    case .optionFlag:
        str = s.green.underline
    case .optionHelp:
        str = s.lightBlue
    default:
        str = s
    }
    
    return cli.defaultFormat(s: str, type: type)
}

do {
    try cli.parse()
} catch {
    cli.printUsage(error)
    exit(EX_USAGE)
}

if help.value {
    cli.printUsage()
    exit(EX_OK)
}

// 项目根目录地址
let project = projectOption.value ?? "."

// 搜索的文件
let resourceExtensions = resourceExtensionOption.value ?? ["png", "jpg", "imageset"]

// 搜索文件后缀
let fileExtensions = fileExtensionOption.value ?? ["swift", "m", "mm", "xib", "storyboard"]

// 排除一些不想搜索的文件路径
let excludedPath = excludePathsOption.value ?? []



