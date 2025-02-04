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
            //LoginView
            "login_failed": "Błąd logowania!",
            "login_failed_message": "Wystąpił błąd i nie udało Ci się zalogować. Spróbuj ponownie.",
            "login_account_header": "Logowanie",
            "username_placeholder": "Nazwa użytkownika",
            "password_placeholder": "Hasło",
            "remember_me": "Zapamiętaj mnie",
            "login_button": "Zaloguj",
            "register_title": "Rejestracja",
            "change_language": "Zmień język",
            
            //RegistrationView
            "passwordSecond_placeholder": "Powtórz hasło",
            "register_button": "Zarejestruj",
            "register_failed": "Rejestracja nie powiodła się!",
            "register_failed_message_first": "Hasło i nazwa użytkownika nie mogą być puste. Wprowadź hasło.",
            "register_failed_message_second": "Podane hasła nie są identyczne. Spróbuj ponownie.",
            "register_failed_message_third": "Zapisz go w bezpiecznym miejscu. Jest wyświetlany tylko raz.",
            "register_failed_message_fourth": "Konto o podanej nazwie użytkownika już istnieje. Spróbuj ponownie.",
            "register_failed_message_fifth": "Wystąpił błąd i nie udało Ci się zarejestrować. Spróbuj ponownie.",
            
            //ProfileDataInputView
            "enter_data_title": "Wprowadź swoje dane",
            "gender_placeholder": "Płeć (Male/Female)",
            "age_placeholder": "Wiek",
            "height_placeholder": "Wzrost (cm)",
            "weight_placeholder": "Waga (kg)",
            "activity_placeholder": "Poziom aktywności",
            "confirm_data_button": "Potwierdź dane",
            "data_input_message": "Wszystkie pola muszą zostać wypełnione poprawnie.",
            
            //LanguageSelectionView
            "select_language_title": "Zmień język",
            
            //MenuView
            "home": "MENU",
            "band": "OPASKA",
            "profile": "PROFIL",
            "settings": "USTAWIENIA",
            "login_successful": "Logowanie udane!",
            "login_successful_message": "Pomyślnie zalogowano.",
            
            //MainView
            "welcome_user": "Witaj, %@!",
            "my_trainings": "Moje treningi",
            "forum": "Forum",
            "badges": "Odznaki",
            "calculator": "Kalkulator",
            "coming_soon": "Wkrótce!",
            "coming_soon_message": "Ta funkcja będzie dostępna w przyszłości.",
            
            //TrainingsView
            "delete_workout": "Usuń trening",
            "delete_workout_message": "Czy na pewno chcesz usunąć ten trening?",
            "delete": "Usuń",
            "trainings": "Treningi",
            "previous": "Poprzedni",
            "next": "Następny",
            
            //SingleTraining
            "speed_graph": "Wykres prędkości",
            "heartrate_graph": "Wykres tętna",
            "time": "Czas:",
            "calories": "Kalorie:",
            "distance": "Dystans:",
            "avg_steps": "Kroki:",
            "avg_bpm": "Śr. BPM:",
            
            //HeartrateGraph
            "graph_info": "(kliknij lupę powyżej,\naby powiększyć i zobaczyć szczegóły)",
            "time_graph": "Czas (s)",
            "bpm_graph": "BPM",
            
            //SpeedGraph
            "speedms_graph": "Prędkość (m/s)",
            
            //BMICalcView
            "warning": "Ostrzeżenie!",
            "bmicalc": "BMI\nKalkulator",
            "weightkg": "Waga (kg)",
            "weight": "Waga",
            "heightcm": "Wzrost (cm)",
            "height": "Wzrost",
            "calculate": "Oblicz",
            "bmialert": "Proszę wypełnić wszystkie pola.",
            "underweight": "Niedowaga",
            "normal": "Prawidłowa waga",
            "overweight": "Nadwaga",
            "obesity": "Otyłość",
            
            //KCALCalcView
            "kcalcalc": "Kalkulator\nKalorii",
            "activitylevel": "Poziom aktywności",
            "kcalalertfirst": "Proszę wypełnić wszystkie pola.",
            "kcalalertsecond": "Proszę wybrać płeć.",
            "kcalalertthird": "Proszę wybrać poziom aktywności.",
            
            //SmartbandView
            "connected": "POŁĄCZONO",
            "disconnected": "ROZŁĄCZONO",
            "connect": "Połącz",
            "disconnect": "Rozłącz",
            "receivedata": "Odbierz dane",
            "sendtoserver": "Wyślij dane na serwer",
            "sendwifi": "Wyślij WiFi",
            "wifipassword": "Hasło WiFi",
            "send": "Wyślij",
            "synctime": "Synchronizuj czas",
            "bandinfo": "Informacje o opasce",
            "downloaded": "Dane pobrane",
            "donwloadedtext": "Dane zostały pobrane i zapisane w bazie danych. Można je teraz wysłać na serwer!",
            "trainingprocessed": "Trening przetworzony",
            "trainingtext": "Trening został pomyślnie przetworzony i znajdziesz go w sekcji Treningi!",
            
            //ProfileView
            "sex:": "Płeć:",
            "age:": "Wiek:",
            "weight:": "Waga:",
            "height:": "Wzrost:",
            "logout": "Wyloguj się",
            
            //SettingsView
            "settingstitle": "Ustawienia",
            "changeuserdata": "Zmień dane użytkownika",
            "changeprofilepicture": "Zmień zdjęcie profilowe",
            "changepassword": "Zmień hasło",
            "changetheme": "Zmień motyw",
            "appinfo": "Informacje o aplikacji",
            "contactus": "Skontaktuj się z nami",
            
            //ProfileDataUpdateView
            "edityourdata": "Edytuj swoje dane",
            "edityourdatatext": "(nie musisz wypełniać\nwszystkich pól)",
            "success": "Sukces!",
            "succestext": "Dane zostały pomyślnie zaktualizowane.",
            "updatealert": "Brak podanych danych do aktualizacji.",
            
            //ChangeProfilePicture
            "changepicturetitle": "Zmień swoje\nzdjęcie profilowe",
            "uploadnewpicture": "Prześlij nowe zdjęcie",
            "picturefirst": "Nie wybrano obrazu",
            "picturesecond": "Błąd: Brak ID użytkownika lub ID sesji",
            "picturethird": "Przesyłanie...",
            "picturefourth": "Avatar przesłany!",
            
            //ChangePasswordView
            "password_change_for_user": "Zmiana hasła \ndla \n%@",
            "resetcode": "Kod resetujący",
            "newpassword": "Nowe hasło",
            "newpasswordrepeat": "Powtórz nowe hasło",
            "changepasswordbutton": "Zmień hasło",
            "alertcode": "Zapisz go w bezpiecznym miejscu. Ta wiadomość jest wyświetlana tylko raz.",
            
            //ChangeTheme
            "miamivice": "Miami Vice",
            "seabreeze": "Morska Bryza",
            
            //AppInformation
            "appversion": "wersja: 1.0",
            "createdby": "Stworzone przez:\nMarcel Radtke\nBartosz Rakowski",
            
            //ContactUs
            "contact": "Kontakt",
            "contacttext": "Jeśli napotkałeś jakiekolwiek problemy lub błędy związane z funkcjonalnością naszej aplikacji, skontaktuj się z nami przez e-mail\n(kliknij w e-mail poniżej)",
            
            //TrainingTypeView
            "trainingtype": "Wybierz typ treningu dla tej sesji treningowej",
            
            //BandInfoView
            "bandinfotitle": "Informacje o opasce",
            "batterylevel": "Poziom baterii",
            "firmwareversion": "Wersja:",
            "filestosend": "Pliki do wysłania:",
            
            //CustomResetCodeAlert
            "resetcodetext": "Oto Twój kod resetowania hasła",
            
            //BMIOutcome
            "bmioutcome": "Twoje BMI wynosi:",
            
            //KCALOutcome
            "kcaloutcome": "Twoje zapotrzebowanie kaloryczne wynosi:",
            
            //Common use
            "failure_message": "Niepowodzenie!"
        ],
        "en": [
            //LoginView
            "login_failed": "Login failed!",
            "login_failed_message": "An error occurred and you could not log in. Please try again.",
            "login_account_header": "Login account",
            "username_placeholder": "Username",
            "password_placeholder": "Password",
            "remember_me": "Remember Me",
            "login_button": "Login",
            "register_title": "Registration",
            "change_language": "Change Language",
            
            //RegistrationView
            "passwordSecond_placeholder": "Repeat password",
            "register_button": "Register",
            "register_failed": "Registration failed!",
            "register_failed_message_first": "Password and username cannot be empty. Please enter a password.",
            "register_failed_message_second": "The passwords are not identical. Please try again.",
            "register_failed_message_third": "Save it in a safe place. This message is displayed once.",
            "register_failed_message_fourth": "An account with this username already exists. Please try again.",
            "register_failed_message_fifth": "An error occurred and you could not register. Please try again.",
            
            //ProfileDataInputView
            "enter_data_title": "Enter your data",
            "gender_placeholder": "Gender (Male/Female)",
            "age_placeholder": "Age",
            "height_placeholder": "Height (cm)",
            "weight_placeholder": "Weight (kg)",
            "activity_placeholder": "Activity level",
            "confirm_data_button": "Confirm data",
            "data_input_message": "All fields must be completed correctly.",
            
            //LanguageSelectionView
            "select_language_title": "Select language",
            
            //MenuView
            "home": "HOME",
            "band": "BAND",
            "profile": "PROFILE",
            "settings": "SETTINGS",
            "login_successful": "Login successful!",
            "login_successful_message": "You have successfully logged in.",
            
            //MainView
            "welcome_user": "Welcome, %@!",
            "my_trainings": "My Trainings",
            "forum": "Forum",
            "badges": "Badges",
            "calculator": "Calculator",
            "coming_soon": "Cooming soon!",
            "coming_soon_message": "This feature will be available in the future.",
            
            //TrainingsView
            "delete_workout": "Delete workout",
            "delete_workout_message": "Are you sure you want to delete this workout?",
            "delete": "Delete",
            "trainings": "Trainings",
            "previous": "Previous",
            "next": "Next",
            
            //SingleTraining
            "speed_graph": "Speed graph",
            "heartrate_graph": "Heartrate graph",
            "time": "Time:",
            "calories": "Calories:",
            "distance": "Distance:",
            "avg_steps": "Avg Steps:",
            "avg_bpm": "Avg BPM:",
            
            //HeartrateGraph
            "graph_info": "(click on the magnifier above\nto zoom in for details)",
            "time_graph": "Time (s)",
            "bpm_graph": "BPM",
            
            //SpeedGraph
            "speedms_graph": "Speed (m/s)",
            
            //BMICalcView
            "warning": "Warning!",
            "bmicalc": "BMI\nCalculator",
            "weightkg": "Weight(kg)",
            "weight": "Weight",
            "heightcm": "Height(cm)",
            "height": "Height",
            "calculate": "Calculate",
            "bmialert": "Please fill in all fields.",
            "underweight": "Underweight",
            "normal": "Normal",
            "overweight": "Overweight",
            "obesity": "Obesity",
            
            //KCALCalcView
            "kcalcalc": "Calories\nCalculator",
            "activitylevel": "Activity level",
            "kcalalertfirst": "Please fill in all fields.",
            "kcalalertsecond": "Please select a gender.",
            "kcalalertthird": "Please choose an activity level.",
            
            //SmartbandView
            "connected": "CONNECTED",
            "disconnected": "DISCONNECTED",
            "connect": "Connect",
            "disconnect": "Disconnect",
            "receivedata": "Receive data",
            "sendtoserver": "Send data to server",
            "sendwifi": "Send WiFi",
            "wifipassword": "WiFi Password",
            "send": "Send",
            "synctime": "Synce time",
            "bandinfo": "Band info",
            "downloaded": "Data downloaded",
            "donwloadedtext": "The data was downloaded and saved to the database. It can now be sent to the server!",
            "trainingprocessed": "Training Processed",
            "trainingtext": "Training was processed successfully and you can find it in the Trainings section!",
            
            //ProfileView
            "sex:": "Sex:",
            "age:": "Age:",
            "weight:": "Weight:",
            "height:": "Height:",
            "logout": "Logout",
            
            //SettingsView
            "settingstitle": "Settings",
            "changeuserdata": "Change user data",
            "changeprofilepicture": "Change profile picture",
            "changepassword": "Change password",
            "changetheme": "Change theme",
            "appinfo": "App information",
            "contactus": "Contact us",
            
            //ProfileDataUpdateView
            "edityourdata": "Edit your data",
            "edityourdatatext": "(you do not have to\npopulate all fields)",
            "success": "Success!",
            "succestext": "The data has been successfully updated.",
            "updatealert": "No data provided to update.",
            
            //ChangeProfilePicture
            "changepicturetitle": "Change your\nprofile picture",
            "uploadnewpicture": "Upload new picture",
            "picturefirst": "No image selected",
            "picturesecond": "Error: Missing User ID or Session ID",
            "picturethird": "Uploading...",
            "picturefourth": "Avatar przesłany!",
            
            //ChangePasswordView
            "password_change_for_user": "Password change \nfor \n%@",
            "resetcode": "Reset code",
            "newpassword": "New password",
            "newpasswordrepeat": "Repeat new password",
            "changepasswordbutton": "Change password",
            "alertcode": "Save it in a safe place. This message is displayed once.",
            
            //ChangeTheme
            "miamivice": "Miami Vice",
            "seabreeze": "Sea Breeze",
            
            //AppInformation
            "appversion": "version: 1.0",
            "createdby": "Created by:\nMarcel Radtke\nBartosz Rakowski",
            
            //ContactUs
            "contact": "Contact",
            "contacttext": "In case you have encountered any issues or bugs related to functionalities of our application, contact us via e-mail\n(click on the e-mail below) ",
            
            //TrainingTypeView
            "trainingtype": "Select training type for this particular training session",
            
            //BandInfoView
            "bandinfotitle": "Band information",
            "batterylevel": "Battery level",
            "firmwareversion": "Firmware version:",
            "filestosend": "Files to send:",
            
            //CustomResetCodeAlert
            "resetcodetext": "Here is your password reset code ",
            
            //BMIOutcome
            "bmioutcome": "Your BMI is:",
            
            //KCALOutcome
            "kcaloutcome": "Your Calorie income is:",

            //Common use
            "failure_message": "Failure!"
        ],
        "de": [
            //LoginView
            "login_failed": "Anmeldung fehlgeschlagen!",
            "login_failed_message": "Ein Fehler ist aufgetreten und die Anmeldung war nicht möglich. Bitte versuchen Sie es erneut.",
            "login_account_header": "Anmeldung",
            "username_placeholder": "Benutzername",
            "password_placeholder": "Passwort",
            "remember_me": "Angemeldet bleiben",
            "login_button": "Anmelden",
            "register_title": "Registrierung",
            "change_language": "Sprache ändern",
            
            //RegistrationView
            "passwordSecond_placeholder": "Passwort wiederholen",
            "register_button": "Registrieren",
            "register_failed": "Registrierung fehlgeschlagen!",
            "register_failed_message_first": "Passwort und Benutzername dürfen nicht leer sein. Bitte geben Sie ein Passwort ein.",
            "register_failed_message_second": "Die Passwörter stimmen nicht überein. Bitte versuchen Sie es erneut.",
            "register_failed_message_third": "Speichern Sie es an einem sicheren Ort. Diese Nachricht wird nur einmal angezeigt.",
            "register_failed_message_fourth": "Ein Konto mit diesem Benutzernamen existiert bereits. Bitte versuchen Sie es erneut.",
            "register_failed_message_fifth": "Ein Fehler ist aufgetreten und die Registrierung war nicht möglich. Bitte versuchen Sie es erneut.",
            
            //ProfileDataInputView
            "enter_data_title": "Geben Sie Ihre Daten ein",
            "gender_placeholder": "Geschlecht (Mann/Frau)",
            "age_placeholder": "Alter",
            "height_placeholder": "Größe (cm)",
            "weight_placeholder": "Gewicht (kg)",
            "activity_placeholder": "Aktivitätsniveau",
            "confirm_data_button": "Daten bestätigen",
            "data_input_message": "Alle Felder müssen korrekt ausgefüllt werden.",
            
            //LanguageSelectionView
            "select_language_title": "Sprache auswählen",
            
            //MenuView
            "home": "STARTSEITE",
            "band": "ARMBAND",
            "profile": "PROFIL",
            "settings": "EINSTELLUNGEN",
            "login_successful": "Erfolgreiche Anmeldung!",
            "login_successful_message": "Sie haben sich erfolgreich angemeldet.",
            
            //MainView
            "welcome_user": "Willkommen, %@!",
            "my_trainings": "Meine Trainings",
            "forum": "Forum",
            "badges": "Abzeichen",
            "calculator": "Rechner",
            "coming_soon": "Kommt bald!",
            "coming_soon_message": "Diese Funktion wird in Zukunft verfügbar sein.",
            
            //TrainingsView
            "delete_workout": "Training löschen",
            "delete_workout_message": "Möchten Sie dieses Training wirklich löschen?",
            "delete": "Löschen",
            "trainings": "Trainings",
            "previous": "Zurück",
            "next": "Weiter",
            
            //SingleTraining
            "speed_graph": "Geschwindigkeitsdiagramm",
            "heartrate_graph": "Herzfrequenzdiagramm",
            "time": "Zeit:",
            "calories": "Kalorien:",
            "distance": "Distanz:",
            "avg_steps": "Durchschnittliche Schritte:",
            "avg_bpm": "Durchschnittliches BPM:",
            
            //HeartrateGraph
            "graph_info": "(Klicken Sie auf die Lupe oben,\num Details zu vergrößern)",
            "time_graph": "Zeit (s)",
            "bpm_graph": "BPM",
            
            //SpeedGraph
            "speedms_graph": "Geschwindigkeit (m/s)",
            
            //BMICalcView
            "warning": "Warnung!",
            "bmicalc": "BMI-Rechner",
            "weightkg": "Gewicht (kg)",
            "weight": "Gewicht",
            "heightcm": "Größe (cm)",
            "height": "Größe",
            "calculate": "Berechnen",
            "bmialert": "Bitte füllen Sie alle Felder aus.",
            "underweight": "Untergewicht",
            "normal": "Normalgewicht",
            "overweight": "Übergewicht",
            "obesity": "Adipositas",
            
            //KCALCalcView
            "kcalcalc": "Kalorienrechner",
            "activitylevel": "Aktivitätsniveau",
            "kcalalertfirst": "Bitte füllen Sie alle Felder aus.",
            "kcalalertsecond": "Bitte wählen Sie ein Geschlecht aus.",
            "kcalalertthird": "Bitte wählen Sie ein Aktivitätsniveau aus.",
            
            //SmartbandView
            "connected": "VERBUNDEN",
            "disconnected": "GETRENNT",
            "connect": "Verbinden",
            "disconnect": "Trennen",
            "receivedata": "Daten empfangen",
            "sendtoserver": "Daten an Server senden",
            "sendwifi": "WiFi senden",
            "wifipassword": "WiFi-Passwort",
            "send": "Senden",
            "synctime": "Zeit synchronisieren",
            "bandinfo": "Armband-Info",
            "downloaded": "Daten heruntergeladen",
            "donwloadedtext": "Die Daten wurden heruntergeladen und in der Datenbank gespeichert. Sie können jetzt an den Server gesendet werden!",
            "trainingprocessed": "Training verarbeitet",
            "trainingtext": "Das Training wurde erfolgreich verarbeitet und ist in der Trainingssektion zu finden!",
            
            //ProfileView
            "sex:": "Geschlecht:",
            "age:": "Alter:",
            "weight:": "Gewicht:",
            "height:": "Größe:",
            "logout": "Abmelden",
            
            //SettingsView
            "settingstitle": "Einstellungen",
            "changeuserdata": "Benutzerdaten ändern",
            "changeprofilepicture": "Profilbild ändern",
            "changepassword": "Passwort ändern",
            "changetheme": "Thema ändern",
            "appinfo": "App-Informationen",
            "contactus": "Kontakt",
            
            //ProfileDataUpdateView
            "edityourdata": "Daten bearbeiten",
            "edityourdatatext": "(Sie müssen nicht\nalle Felder ausfüllen)",
            "success": "Erfolg!",
            "succestext": "Die Daten wurden erfolgreich aktualisiert.",
            "updatealert": "Keine Daten zur Aktualisierung angegeben.",
            
            //ChangeProfilePicture
            "changepicturetitle": "Profilbild ändern",
            "uploadnewpicture": "Neues Bild hochladen",
            "picturefirst": "Kein Bild ausgewählt",
            "picturesecond": "Fehler: Fehlende Benutzer-ID oder Sitzungs-ID",
            "picturethird": "Hochladen...",
            "picturefourth": "Avatar hochgeladen!",
            
            //ChangePasswordView
            "password_change_for_user": "Passwortänderung \nfür \n%@",
            "resetcode": "Reset-Code",
            "newpaswword": "Neues Passwort",
            "newpasswordrepeat": "Neues Passwort wiederholen",
            "changepasswordbutton": "Passwort ändern",
            "alertcode": "Speichern Sie es an einem sicheren Ort. Diese Nachricht wird nur einmal angezeigt.",
            
            //ChangeTheme
            "miamivice": "Miami Vice",
            "seabreeze": "Meeresbrise",
            
            //AppInformation
            "appversion": "Version: 1.0",
            "createdby": "Erstellt von:\nMarcel Radtke\nBartosz Rakowski",
            
            //ContactUs
            "contact": "Kontakt",
            "contacttext": "Falls Sie Probleme oder Fehler im Zusammenhang mit der Funktionalität unserer Anwendung festgestellt haben, kontaktieren Sie uns per E-Mail\n(klicken Sie auf die unten stehende E-Mail)",
            
            //TrainingTypeView
            "trainingtype": "Wählen Sie den Trainingstyp für diese Trainingseinheit aus",
            
            //BandInfoView
            "bandinfotitle": "Armband-Informationen",
            "batterylevel": "Batteriestand",
            "firmwareversion": "Firmware-Version:",
            "filestosend": "Zu sendende Dateien:",
            
            //CustomResetCodeAlert
            "resetcodetext": "Hier ist Ihr Passwort-Reset-Code",
            
            //BMIOutcome
            "bmioutcome": "Ihr BMI beträgt:",
            
            //KCALOutcome
            "kcaloutcome": "Ihr Kalorienbedarf beträgt:",
            
            //Common use
            "failure_message": "Fehler!"
        ],
        "es": [
            //LoginView
            "login_failed": "¡Error de inicio de sesión!",
            "login_failed_message": "Ocurrió un error y no se pudo iniciar sesión. Por favor, inténtelo de nuevo.",
            "login_account_header": "Iniciar sesión",
            "username_placeholder": "Nombre de usuario",
            "password_placeholder": "Contraseña",
            "remember_me": "Recuérdame",
            "login_button": "Iniciar sesión",
            "register_title": "Registro",
            "change_language": "Cambiar idioma",
            
            //RegistrationView
            "passwordSecond_placeholder": "Repetir contraseña",
            "register_button": "Registrarse",
            "register_failed": "¡Error de registro!",
            "register_failed_message_first": "El nombre de usuario y la contraseña no pueden estar vacíos. Por favor, introduzca una contraseña.",
            "register_failed_message_second": "Las contraseñas no coinciden. Por favor, inténtelo de nuevo.",
            "register_failed_message_third": "Guárdelo en un lugar seguro. Este mensaje se muestra solo una vez.",
            "register_failed_message_fourth": "Ya existe una cuenta con este nombre de usuario. Por favor, inténtelo de nuevo.",
            "register_failed_message_fifth": "Ocurrió un error y no se pudo registrar. Por favor, inténtelo de nuevo.",
            
            //ProfileDataInputView
            "enter_data_title": "Ingrese sus datos",
            "gender_placeholder": "Género (Hombre/Mujer)",
            "age_placeholder": "Edad",
            "height_placeholder": "Altura (cm)",
            "weight_placeholder": "Peso (kg)",
            "activity_placeholder": "Nivel de actividad",
            "confirm_data_button": "Confirmar datos",
            "data_input_message": "Todos los campos deben completarse correctamente.",
            
            //LanguageSelectionView
            "select_language_title": "Seleccionar idioma",
            
            //MenuView
            "home": "INICIO",
            "band": "PULSERA",
            "profile": "PERFIL",
            "settings": "AJUSTES",
            "login_successful": "¡Inicio de sesión exitoso!",
            "login_successful_message": "Has iniciado sesión correctamente.",
            
            //MainView
            "welcome_user": "¡Bienvenido, %@!",
            "my_trainings": "Mis entrenamientos",
            "forum": "Foro",
            "badges": "Insignias",
            "calculator": "Calculadora",
            "coming_soon": "¡Próximamente!",
            "coming_soon_message": "Esta función estará disponible en el futuro.",
            
            //TrainingsView
            "delete_workout": "Eliminar entrenamiento",
            "delete_workout_message": "¿Está seguro de que desea eliminar este entrenamiento?",
            "delete": "Eliminar",
            "trainings": "Entrenamientos",
            "previous": "Anterior",
            "next": "Siguiente",
            
            //SingleTraining
            "speed_graph": "Gráfico de velocidad",
            "heartrate_graph": "Gráfico de frecuencia cardíaca",
            "time": "Tiempo:",
            "calories": "Calorías:",
            "distance": "Distancia:",
            "avg_steps": "Promedio de pasos:",
            "avg_bpm": "Promedio de BPM:",
            
            //HeartrateGraph
            "graph_info": "(haga clic en la lupa arriba\npara ampliar y ver detalles)",
            "time_graph": "Tiempo (s)",
            "bpm_graph": "BPM",
            
            //SpeedGraph
            "speedms_graph": "Velocidad (m/s)",
            
            //BMICalcView
            "warning": "¡Advertencia!",
            "bmicalc": "Calculadora de IMC",
            "weightkg": "Peso (kg)",
            "weight": "Peso",
            "heightcm": "Altura (cm)",
            "height": "Altura",
            "calculate": "Calcular",
            "bmialert": "Por favor, complete todos los campos.",
            "underweight": "Bajo peso",
            "normal": "Peso normal",
            "overweight": "Sobrepeso",
            "obesity": "Obesidad",
            
            //KCALCalcView
            "kcalcalc": "Calculadora de calorías",
            "activitylevel": "Nivel de actividad",
            "kcalalertfirst": "Por favor, complete todos los campos.",
            "kcalalertsecond": "Por favor, seleccione un género.",
            "kcalalertthird": "Por favor, elija un nivel de actividad.",
            
            //SmartbandView
            "connected": "CONECTADO",
            "disconnected": "DESCONECTADO",
            "connect": "Conectar",
            "disconnect": "Desconectar",
            "receivedata": "Recibir datos",
            "sendtoserver": "Enviar datos al servidor",
            "sendwifi": "Enviar WiFi",
            "wifipassword": "Contraseña WiFi",
            "send": "Enviar",
            "synctime": "Sincronizar tiempo",
            "bandinfo": "Información de la pulsera",
            "downloaded": "Datos descargados",
            "donwloadedtext": "Los datos se han descargado y guardado en la base de datos. ¡Ahora se pueden enviar al servidor!",
            "trainingprocessed": "Entrenamiento procesado",
            "trainingtext": "El entrenamiento se ha procesado correctamente y lo encontrarás en la sección de entrenamientos.",
            
            //ProfileView
            "sex:": "Género:",
            "age:": "Edad:",
            "weight:": "Peso:",
            "height:": "Altura:",
            "logout": "Cerrar sesión",
            
            //SettingsView
            "settingstitle": "Ajustes",
            "changeuserdata": "Cambiar datos de usuario",
            "changeprofilepicture": "Cambiar foto de perfil",
            "changepassword": "Cambiar contraseña",
            "changetheme": "Cambiar tema",
            "appinfo": "Información de la aplicación",
            "contactus": "Contáctenos",
            
            //ProfileDataUpdateView
            "edityourdata": "Editar sus datos",
            "edityourdatatext": "(no es necesario llenar\n todos los campos)",
            "success": "¡Éxito!",
            "succestext": "Los datos se han actualizado correctamente.",
            "updatealert": "No se proporcionaron datos para actualizar.",
            
            //ChangeProfilePicture
            "changepicutertitle": "Cambiar su\nfoto de perfil",
            "uploadnewpicture": "Subir nueva foto",
            "picturefirst": "No se ha seleccionado ninguna imagen",
            "picturesecond": "Error: Falta el ID de usuario o el ID de sesión",
            "picturethird": "Subiendo...",
            "picturefourth": "¡Avatar subido!",
            
            //ChangePasswordView
            "password_change_for_user": "Cambio de contraseña \npara \n%@",
            "resetcode": "Código de restablecimiento",
            "newpaswword": "Nueva contraseña",
            "newpasswordrepeat": "Repetir nueva contraseña",
            "changepasswordbutton": "Cambiar contraseña",
            "alertcode": "Guárdelo en un lugar seguro. Este mensaje se muestra solo una vez.",
            
            //ChangeTheme
            "miamivice": "Miami Vice",
            "seabreeze": "Brisa Marina",
            
            //AppInformation
            "appversion": "versión: 1.0",
            "createdby": "Creado por:\nMarcel Radtke\nBartosz Rakowski",
            
            //ContactUs
            "contact": "Contacto",
            "contacttext": "Si ha encontrado algún problema o error relacionado con las funcionalidades de nuestra aplicación, contáctenos por correo electrónico\n(haga clic en el correo electrónico a continuación)",
            
            //TrainingTypeView
            "trainingtype": "Seleccione el tipo de entrenamiento para esta sesión",
            
            //BandInfoView
            "bandinfotitle": "Información de la pulsera",
            "batterylevel": "Nivel de batería",
            "firmwareversion": "Versión del firmware:",
            "filestosend": "Archivos para enviar:",
            
            //CustomResetCodeAlert
            "resetcodetext": "Aquí está su código de restablecimiento de contraseña",
            
            //BMIOutcome
            "bmioutcome": "Su IMC es:",
            
            //KCALOutcome
            "kcaloutcome": "Su ingesta calórica es:",
            
            //Common use
            "failure_message": "¡Error!"
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
