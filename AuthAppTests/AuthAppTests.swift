import XCTest
@testable import AuthApp

final class LoginViewTests: XCTestCase {

    var loginView: LoginView!

    override func setUpWithError() throws {
        try super.setUpWithError()
        loginView = LoginView()
    }

    override func tearDownWithError() throws {
        loginView = nil
        try super.tearDownWithError()
    }


    func testLogin_WithValidCredentials_ShouldSetIsLoggedIn() {
        // Given
        loginView.username = "admin"
        loginView.password = "admin"

        //let expectation = self.expectation(description: "Login request should succeed")

        // When
        loginView.login()

        DispatchQueue.main.asyncAfter(deadline: .now() + 10) { // Czekamy na zakończenie żądania
            // Then
            XCTAssertTrue(self.loginView.isLoggedIn)
            XCTAssertNotNil(UserDefaults.standard.string(forKey: "user_id"))
            //expectation.fulfill()
        }
    }

    func testLoadRememberedCredentials_ShouldLoadCredentialsFromUserDefaults() {
        // Given
        UserDefaults.standard.set("admin", forKey: "savedUsername")
        UserDefaults.standard.set("admin", forKey: "savedPassword")
        UserDefaults.standard.set(true, forKey: "isRemembered")

        // When
        loginView.loadRememberedCredentials()

        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) { [self] in // Czekamy na zakończenie żądania
            XCTAssertEqual(loginView.username, "admin")
            XCTAssertEqual(loginView.password, "admin")
            XCTAssertTrue(loginView.rememberMe)
        }
    }

    func testResetLoginData_ShouldClearUserDefaultsAndState() {
        // Given
        UserDefaults.standard.set("admin", forKey: "savedUsername")
        UserDefaults.standard.set("admin", forKey: "savedPassword")
        UserDefaults.standard.set(true, forKey: "isRemembered")
        loginView.username = "admin"
        loginView.password = "admin"
        loginView.rememberMe = true

        // When
        loginView.resetLoginData()

        // Then
        XCTAssertNil(UserDefaults.standard.string(forKey: "savedUsername"))
        XCTAssertNil(UserDefaults.standard.string(forKey: "savedPassword"))
        XCTAssertFalse(UserDefaults.standard.bool(forKey: "isRemembered"))
        XCTAssertEqual(loginView.username, "")
        XCTAssertEqual(loginView.password, "")
        XCTAssertFalse(loginView.rememberMe)
    }

    func testVerifyUser_WithExistingUser_ShouldSetIsUserExistingToTrue() {
        // Given
        UserDefaults.standard.set("12345", forKey: "user_id")

        // When
        loginView.verifyUser {
            // Then
            XCTAssertTrue(self.loginView.isUserExisting)
        }
    }

    func testVerifyUser_WithNonExistingUser_ShouldSetIsUserExistingToFalse() {
        // Given
        UserDefaults.standard.set("nonExistingUserId", forKey: "user_id")

        let expectation = self.expectation(description: "User verification should fail")

        // When
        loginView.verifyUser {
            // Then
            XCTAssertFalse(self.loginView.isUserExisting)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)
    }
}
