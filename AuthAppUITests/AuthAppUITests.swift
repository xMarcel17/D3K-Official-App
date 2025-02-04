import XCTest
@testable import AuthApp

final class AuthAppUITests: XCTestCase {

    func testPerformLogin() {
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
        
        // Naciśnięcie przycisku OK z powiadomienia o pozytywnym zalogowaniu
        app.alerts.buttons["OK"].firstMatch.tap()
        
        // Sprawdzenie, czy po zalogowaniu widzimy ekran powitalny
        let menuView = app.staticTexts["welcomeIdentifier"]
        XCTAssertTrue(menuView.waitForExistence(timeout: 10), "MenuView should appear after login.")
    }
    
    func testOpenLanguageSelectionView() {
        // Uruchomienie aplikacji
        let app = XCUIApplication()
        app.launch()

        // Naciśnięcie przycisku do zmiany języka
        let languageSelectionButton = app.buttons["languageSelectionButton"]
        XCTAssertTrue(languageSelectionButton.waitForExistence(timeout: 5), "Select language button should exist.")
        languageSelectionButton.tap()
        
        // Naciśnięcie przycisku do wyjścia z widoku
        let languageSelectionBackButton = app.buttons["languageSelectionBackButton"]
        XCTAssertTrue(languageSelectionBackButton.waitForExistence(timeout: 5), "Back button should exist.")
        languageSelectionBackButton.tap()
        
        // Sprawdzenie, czy powrócono do widoku
        let loginView = app.staticTexts["loginAccountIdentifier"]
        XCTAssertTrue(loginView.waitForExistence(timeout: 10), "LoginView should appear after going back.")
    }
    
    func testOpenRegistrationView() {
        // Uruchomienie aplikacji
        let app = XCUIApplication()
        app.launch()

        // Naciśnięcie przycisku do zmiany języka
        let registrationViewButton = app.buttons["registrationViewButton"]
        XCTAssertTrue(registrationViewButton.waitForExistence(timeout: 5), "Register button should exist.")
        registrationViewButton.tap()
        
        // Naciśnięcie przycisku do wyjścia z widoku
        let registrationViewBackButton = app.buttons["registrationViewBackButton"]
        XCTAssertTrue(registrationViewBackButton.waitForExistence(timeout: 5), "Back button should exist.")
        registrationViewBackButton.tap()
        
        // Sprawdzenie, czy powrócono do widoku
        let loginView = app.staticTexts["loginAccountIdentifier"]
        XCTAssertTrue(loginView.waitForExistence(timeout: 10), "LoginView should appear after going back.")
    }
}
