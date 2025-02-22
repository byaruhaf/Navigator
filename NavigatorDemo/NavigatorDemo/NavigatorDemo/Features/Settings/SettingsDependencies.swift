//
//  SettingsModuleDependencies.swift
//  NavigatorDemo
//
//  Created by Michael Long on 1/24/25.
//

import Navigator
import SwiftUI

//
// SETTINGS MODULE/FEATURE DEPENDENCIES
//

// Specify everything this module needs
public typealias SettingsDependencies = CoreDependencies
    & SettingsModuleDependencies

// Specify everything specific to this module
public protocol SettingsModuleDependencies {
    var settingsKey: String { get }
    func settingsProvider() -> any Loading
}

// Construct defaults, including defaults that depend on other modules
extension SettingsModuleDependencies where Self: CoreDependencies {
    // Using where Self: CoreDependencies illustrates accessing default dependencies from known dependencies.
    public func settingsProvider() -> any Loading {
        Loader(networker: networker())
    }
}

// Define our module's mock protocol
public protocol MockSettingsDependencies: SettingsDependencies, MockCoreDependencies {}

// Extend as needed
extension MockSettingsDependencies {
    public var settingsKey: String { "mock" }
}

// Make our mock resolver
public struct MockSettingsResolver: MockSettingsDependencies {}

// Illustrate making a test resolver that overrides default behavior
public struct TestSettingsResolver: MockSettingsDependencies {
    public var settingsKey: String { "test" }
}

// Make our environment entry
extension EnvironmentValues {
    @Entry public var settingsDependencies: SettingsDependencies = MockSettingsResolver()
}

