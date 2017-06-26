// Generated automatically by Perfect Assistant Application
// Date: 2017-06-25 22:23:08 +0000
import PackageDescription
let package = Package(
    name: "MyServer",
    targets: [],
    dependencies: [
        .Package(url: "https://github.com/PerfectlySoft/Perfect-HTTPServer.git", majorVersion: 2),
        .Package(url: "https://github.com/PerfectlySoft/Perfect-Turnstile-MongoDB.git", majorVersion: 1),
        .Package(url: "https://github.com/PerfectlySoft/Perfect-FileMaker.git", majorVersion: 2),
        .Package(url: "https://github.com/PerfectlySoft/Perfect-Notifications.git", majorVersion: 2),
        .Package(url: "https://github.com/PerfectlySoft/Perfect-COpenSSL.git", majorVersion: 2),
        .Package(url: "https://github.com/PerfectlySoft/Perfect-RequestLogger.git", majorVersion: 1),
        .Package(url: "https://github.com/PerfectlySoft/Perfect-Logger.git", majorVersion: 1),
        .Package(url: "https://github.com/PerfectlySoft/Perfect-SysInfo.git", majorVersion: 1),
        .Package(url: "https://github.com/rymcol/SwiftCron.git", majorVersion:0),
    ]
)
