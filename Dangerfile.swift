import Danger
import Foundation

let danger = Danger()

SwiftLint.lint(.modifiedAndCreatedFiles(directory: nil), inline: true, configFile: ".swiftlint.yml")
