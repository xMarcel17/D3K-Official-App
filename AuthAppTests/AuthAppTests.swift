import XCTest
import SwiftUI
@testable import AuthApp

class LoginViewTests: XCTestCase {
    private var mockSession: MockURLSession!
    private var loginView: LoginView!
    
    override func setUp() {
        super.setUp()
        
        clearUserDefaults()
        
        mockSession = MockURLSession()
  
        let arguments = ProcessInfo.processInfo.arguments
           if !arguments.contains("UITestMode") {
               var newArguments = arguments
               newArguments.append("UITestMode")
               setenv("UITestMode", "true", 1)
           }
        
        loginView = LoginView()
        
        let hostingVC = UIHostingController(rootView: loginView)
        _ = hostingVC.view
    }
     
    override func tearDown() {
        clearUserDefaults()
        super.tearDown()
    }
         
    func clearUserDefaults() {
        if let appDomain = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: appDomain)
            UserDefaults.standard.synchronize()
        }
    }
    
    func testPerformLoginSuccessRemembered() {
        // Dane testowe
        loginView.usernameTest = "testUser"
        loginView.passwordTest = "password123"
        loginView.rememberMeTest = true
        
        // Oczekiwanie na zakończenie operacji
        let expectation = self.expectation(description: "Login completes")

        // Metoda logowania
        loginView.login(username: loginView.usernameTest!, password: loginView.passwordTest!, using: mockSession)

        // Czekanie na zakończenie asynchronicznej operacji
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertTrue(UserDefaults.standard.bool(forKey: "isLoggedInForTest"))
            XCTAssertEqual(UserDefaults.standard.string(forKey: "savedUsername"), "testUser")
            XCTAssertEqual(UserDefaults.standard.string(forKey: "savedPassword"), "password123")
            XCTAssertTrue(UserDefaults.standard.bool(forKey: "isRemembered"))
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0) // Limit czasu dla testu
    }
    
    func testPerformLoginSuccessNoRemembered() {
        // Ustaw dane testowe
        loginView.usernameTest = "testUser"
        loginView.passwordTest = "password123"
        loginView.rememberMeTest = false
        
        // Stwórz oczekiwanie na zakończenie operacji
        let expectation = self.expectation(description: "Login completes")

        // Wywołaj metodę logowania
        loginView.login(username: loginView.usernameTest!, password: loginView.passwordTest!, using: mockSession)

        // Czekaj na zakończenie asynchronicznej operacji
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertTrue(UserDefaults.standard.bool(forKey: "isLoggedInForTest"))
            XCTAssertEqual(UserDefaults.standard.string(forKey: "savedUsername"), nil)
            XCTAssertEqual(UserDefaults.standard.string(forKey: "savedPassword"), nil)
            XCTAssertFalse(UserDefaults.standard.bool(forKey: "isRemembered"))
            expectation.fulfill() // Oznacz oczekiwanie jako spełnione
        }
        
        wait(for: [expectation], timeout: 5.0) // Ustaw limit czasu dla testu
    }

    
    func testPerformLoginFailure() {
        // Ustaw dane testowe
        loginView.usernameTest = "testUserFailure"
        loginView.passwordTest = "password12345"
        loginView.rememberMeTest = false
        
        // Stwórz oczekiwanie na zakończenie operacji
        let expectation = self.expectation(description: "Login fails")

        // Wywołaj metodę logowania
        loginView.login(username: loginView.usernameTest!, password: loginView.passwordTest!, using: mockSession)

        // Czekaj na zakończenie asynchronicznej operacji
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertFalse(UserDefaults.standard.bool(forKey: "isLoggedInForTest"))
            XCTAssertEqual(UserDefaults.standard.string(forKey: "savedUsername"), nil)
            XCTAssertEqual(UserDefaults.standard.string(forKey: "savedPassword"), nil)
            XCTAssertFalse(UserDefaults.standard.bool(forKey: "isRemembered"))
            expectation.fulfill() // Oznacz oczekiwanie jako spełnione
        }
        
        wait(for: [expectation], timeout: 5.0) // Ustaw limit czasu dla testu
    }
    
    func testLoadRememberedCredentials() {
        // Ustaw dane testowe
        UserDefaults.standard.set("loadedUsername", forKey: "savedUsername")
        UserDefaults.standard.set("loadedPassword", forKey: "savedPassword")
        UserDefaults.standard.set(true, forKey: "isRemembered")
        
        // Stwórz oczekiwanie na zakończenie operacji
        let expectation = self.expectation(description: "Loads credentials")

        // Wywołaj metodę logowania
        loginView.loadRememberedCredentials()

        // Czekaj na zakończenie asynchronicznej operacji
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertTrue(UserDefaults.standard.bool(forKey: "isUsernameLoaded"))
            XCTAssertTrue(UserDefaults.standard.bool(forKey: "isPasswordLoaded"))
            XCTAssertTrue(UserDefaults.standard.bool(forKey: "isRemembered"))
            expectation.fulfill() // Oznacz oczekiwanie jako spełnione
        }
        
        wait(for: [expectation], timeout: 5.0) // Ustaw limit czasu dla testu
    }
    
    func testResetLoginData() {
        // Ustaw dane testowe
        UserDefaults.standard.set("testSavedUsername", forKey: "savedUsername")
        UserDefaults.standard.set("testSavedPassword", forKey: "savedPassword")
        UserDefaults.standard.set(false, forKey: "isRemembered")
        UserDefaults.standard.set("testUserId", forKey: "user_id")
        UserDefaults.standard.set("testSessionId", forKey: "session_id")
        
        // Stwórz oczekiwanie na zakończenie operacji
        let expectation = self.expectation(description: "Resets login data")

        // Wywołaj metodę logowania
        loginView.resetLoginData()

        // Czekaj na zakończenie asynchronicznej operacji
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertEqual(UserDefaults.standard.string(forKey: "savedUsername"), nil)
            XCTAssertEqual(UserDefaults.standard.string(forKey: "savedPassword"), nil)
            XCTAssertFalse(UserDefaults.standard.bool(forKey: "isRemembered"))
            XCTAssertEqual(UserDefaults.standard.string(forKey: "user_id"), nil)
            XCTAssertEqual(UserDefaults.standard.string(forKey: "session_id"), nil)
            expectation.fulfill() // Oznacz oczekiwanie jako spełnione
        }
        
        wait(for: [expectation], timeout: 5.0) // Ustaw limit czasu dla testu
    }
    
    func testVerifyUserSuccess() {
        UserDefaults.standard.set("12345", forKey: "user_id")
        UserDefaults.standard.set("mockSessionId", forKey: "session_id")
        
        let expectation = self.expectation(description: "VerifyUser completes successfully")
        
        loginView.verifyUser(using: mockSession) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                XCTAssertTrue(UserDefaults.standard.bool(forKey: "httpResponseForVerifyUser"))
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
        
    func testVerifyUserFailure() {
        UserDefaults.standard.set("invalidUserId", forKey: "user_id")
        UserDefaults.standard.set("mockSessionId", forKey: "session_id")
        
        let expectation = self.expectation(description: "VerifyUser fails")
        
        loginView.verifyUser(using: mockSession) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                XCTAssertFalse(UserDefaults.standard.bool(forKey: "httpResponseForVerifyUser"))
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
}

// Mock URLSession for testing API requests
class MockURLSession: URLSession {
    override func dataTask(
        with request: URLRequest,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTask {
        let mockTask = MockURLSessionDataTask()
        mockTask.completionHandler = {
            let validUsername = "testUser"
            let validPassword = "password123"
            let validUserId = "12345"
            
            if request.url?.absoluteString.contains("/auth/login") == true {
                if let httpBody = request.httpBody,
                   let json = try? JSONSerialization.jsonObject(with: httpBody, options: []) as? [String: Any],
                   let username = json["username"] as? String,
                   let password = json["password"] as? String,
                   username == validUsername, password == validPassword {
                    let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: ["session_id": "mockSessionId"])
                    completionHandler("{\"user_id\": \"12345\"}".data(using: .utf8), response, nil)
                } else {
                    completionHandler(nil, nil, NSError(domain: "MockLoginError", code: 401, userInfo: nil))
                }
            } else if request.url?.absoluteString.contains(validUserId) == true {
                let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: ["session_id": "mockSessionId"])
                completionHandler(nil, response, nil)
            } else {
                let response = HTTPURLResponse(url: request.url!, statusCode: 404, httpVersion: nil, headerFields: nil)
                completionHandler(nil, response, nil)
            }
        }
        return mockTask
    }
}
// Mock URLSessionDataTask
class MockURLSessionDataTask: URLSessionDataTask {
    var completionHandler: (() -> Void)?
    
    override func resume() {
        completionHandler?()
    }
}
