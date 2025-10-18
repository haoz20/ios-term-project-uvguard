//
//  SettingsManager.swift
//  UVGuard
//
//  Created on Settings Management Implementation
//

import Foundation
import SwiftUI

@Observable
class SettingsManager {
    static let shared = SettingsManager()
    
    // MARK: - Keys
    private enum Keys {
        static let appearance = "appearance"
        static let is24HourTime = "is24HourTime"
        static let language = "language"
    }
    
    // MARK: - Settings Properties
    var appearance: AppearanceOption {
        didSet {
            UserDefaults.standard.set(appearance.rawValue, forKey: Keys.appearance)
            applyAppearance()
        }
    }
    
    var is24HourTime: Bool {
        didSet {
            UserDefaults.standard.set(is24HourTime, forKey: Keys.is24HourTime)
        }
    }
    
    var language: LanguageOption {
        didSet {
            UserDefaults.standard.set(language.rawValue, forKey: Keys.language)
        }
    }
    
    // MARK: - Initialization
    private init() {
        // Load appearance
        if let savedAppearance = UserDefaults.standard.string(forKey: Keys.appearance),
           let appearance = AppearanceOption(rawValue: savedAppearance) {
            self.appearance = appearance
        } else {
            self.appearance = .system
        }
        
        // Load 24-hour time preference
        self.is24HourTime = UserDefaults.standard.bool(forKey: Keys.is24HourTime)
        
        // Load language
        if let savedLanguage = UserDefaults.standard.string(forKey: Keys.language),
           let language = LanguageOption(rawValue: savedLanguage) {
            self.language = language
        } else {
            self.language = .english
        }
        
        // Apply the saved appearance on init
        applyAppearance()
    }
    
    // MARK: - Helper Methods
    private func applyAppearance() {
        DispatchQueue.main.async {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.first else {
                return
            }
            
            switch self.appearance {
            case .system:
                window.overrideUserInterfaceStyle = .unspecified
            case .light:
                window.overrideUserInterfaceStyle = .light
            case .dark:
                window.overrideUserInterfaceStyle = .dark
            }
        }
    }
    
    // MARK: - Reset
    func resetToDefaults() {
        appearance = .system
        is24HourTime = false
        language = .english
    }
}
