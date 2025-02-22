//
//  AppDependencies.swift
//  NavigatorDemo
//
//  Created by Michael Long on 1/24/25.
//

import Navigator
import SwiftUI

//
// APPLICATION DEPENDENCY RESOLVER
//

// Application aggregates all known module dependencies
typealias AppDependencies = CoreDependencies
    & HomeDependencies
    & SettingsDependencies

// Make the application's dependency resolver
class AppResolver: AppDependencies {

    // root view type
    let rootViewType: RootViewType

    // root navigator
    let navigator: Navigator

    // application router
    let router: any NavigationRouting<KnownRoutes>

    // initializer
    init(rootViewType: RootViewType, navigator: Navigator) {
        self.rootViewType = rootViewType
        self.navigator = navigator
        self.router = rootViewType.router(navigator)
    }

    // need one per app
    let analyticsService = ThirdPartyAnalyticsService()

    // Missing default dependencies forces app to provide them.
    func analytics() -> any AnalyticsService {
        analyticsService
    }

    // Home needs an external view from somewhere. Provide it.
    @MainActor func homeExternalViewProvider() -> any NavigationViewProviding<HomeExternalViews> {
        NavigationViewProvider {
            switch $0 {
            case .external:
                SettingsDestinations.external()
            }
        }
    }

    // Home feature wants to be able to route to settings feature, app knows how app is structured, so...
    @MainActor func homeExternalRouter() -> any NavigationRouting<HomeExternalRoutes> {
        NavigationRouter {
            // Map external routes required by Home feature to internal routes
            switch $0 {
            case .settingsPage2:
                self.router.route(to: .settingsPage2)
            case .settingsPage3:
                self.router.route(to: .settingsPage3)
            }
        }
    }
    
    // Missing default provides proper key
    var settingsKey: String { "actual" }
}
