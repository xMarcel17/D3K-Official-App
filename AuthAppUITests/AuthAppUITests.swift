//
//  AuthAppUITests.swift
//  AuthAppUITests
//
//  Created by Marcel Radtke on 12/08/2024.
//

import XCTest
@testable import AuthApp

final class AuthAppUITests: XCTestCase {

    func testLogin_WithValidCredentials_ShouldSetIsLoggedIn() {
            // Uruchomienie aplikacji
            let app = XCUIApplication()
            app.launch()

            // Znalezienie pola tekstowego dla username
            let usernameTextField = app.textFields["usernameTextField"]
            XCTAssertTrue(usernameTextField.waitForExistence(timeout: 5), "Username text field should exist.")
            usernameTextField.tap()
            usernameTextField.typeText("admin")

            // Znalezienie pola tekstowego dla password
            let passwordTextField = app.secureTextFields["passwordTextField"]
            XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5), "Password text field should exist.")
            passwordTextField.tap()
            passwordTextField.typeText("admin")

            // Znalezienie przycisku logowania i kliknięcie
            let loginButton = app.buttons["loginButton"]
            XCTAssertTrue(loginButton.waitForExistence(timeout: 5), "Login button should exist.")
            loginButton.tap()

            // Sprawdzenie, czy po zalogowaniu widzimy ekran powitalny
            let menuView = app.alerts["loginAlert"]
            XCTAssertTrue(menuView.waitForExistence(timeout: 10), "Login alert should appear after login.")
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
