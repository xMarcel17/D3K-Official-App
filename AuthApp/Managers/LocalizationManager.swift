import SwiftUI
import Combine

class LocalizationManager: ObservableObject {
    static let shared = LocalizationManager()
    
    @Published var currentLanguage: String = "pl" {
        didSet {
            UserDefaults.standard.set(currentLanguage, forKey: "selectedLanguage")
        }
    }

    private var translations: [String: [String: String]] = [
        "pl": [
            "login_title": "Login",
            "username_placeholder": "Nazwa użytkownika",
            "password_placeholder": "Hasło",
            "passwordSecond_placeholder": "Powtórz hasło",
            "remember_me": "Zapamiętaj mnie",
            "login_button": "Zaloguj",
            "register_button": "Zarejestruj",
            "change_language": "Zmień język",
            "gender_placeholder": "Płeć",
            "age_placeholder": "Wiek",
            "height_placeholder": "Wzrost (cm)",
            "weight_placeholder": "Waga (kg)"
            // dodaj resztę tłumaczeń
        ],
        "en": [
            "login_title": "Login",
            "username_placeholder": "Username",
            "password_placeholder": "Password",
            "passwordSecond_placeholder": "Repeat password",
            "remember_me": "Remember Me",
            "login_button": "Login",
            "register_button": "Register",
            "change_language": "Change Language",
            "gender_placeholder": "Gender",
            "age_placeholder": "Age",
            "height_placeholder": "Height (cm)",
            "weight_placeholder": "Weight (kg)"
            // dodaj resztę tłumaczeń
        ],
        "de": [
            "login_title": "Anmeldung",
            "username_placeholder": "Benutzername",
            "password_placeholder": "Passwort",
            "remember_me": "Erinnere dich an mich",
            "login_button": "Einloggen",
            "change_language": "Sprache ändern",
            // dodaj resztę tłumaczeń
        ],
        "es": [
            "login_title": "Iniciar sesión",
            "username_placeholder": "Nombre de usuario",
            "password_placeholder": "Contraseña",
            "remember_me": "Recuérdame",
            "login_button": "Iniciar sesión",
            "change_language": "Cambiar idioma",
            // dodaj resztę tłumaczeń
        ]
    ]

    func localizedString(forKey key: String) -> String {
        return translations[currentLanguage]?[key] ?? key
    }
    
    init() {
        if let savedLanguage = UserDefaults.standard.string(forKey: "selectedLanguage") {
            currentLanguage = savedLanguage
        }
    }
}
