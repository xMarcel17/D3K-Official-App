import SQLite
import Foundation

class DatabaseManager {
    static let shared = DatabaseManager()
    private var db: Connection?

    private let sensorData = Table("SensorData")
    private let id = SQLite.Expression<Int64>("id")
    private let timestamp = SQLite.Expression<Int>("timestamp")
    private let ir = SQLite.Expression<Int>("ir")
    private let red = SQLite.Expression<Int>("red")
    private let accX = SQLite.Expression<Int>("accX")
    private let accY = SQLite.Expression<Int>("accY")
    private let accZ = SQLite.Expression<Int>("accZ")

    private init() {
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("SensorData").appendingPathExtension("sqlite3")
            db = try Connection(fileUrl.path)
            createTable()
        } catch {
            print("Error initializing database: \(error)")
        }
    }

    private func createTable() {
        do {
            try db?.run(sensorData.create(ifNotExists: true) { table in
                table.column(id, primaryKey: .autoincrement)
                table.column(timestamp)
                table.column(ir)
                table.column(red)
                table.column(accX)
                table.column(accY)
                table.column(accZ)
            })
        } catch {
            print("Error creating table: \(error)")
        }
    }

    func insertData(timestamp: Int, ir: Int, red: Int, accX: Int, accY: Int, accZ: Int) {
        let insert = sensorData.insert(self.timestamp <- timestamp, self.ir <- ir, self.red <- red, self.accX <- accX, self.accY <- accY, self.accZ <- accZ)
        do {
            try db?.run(insert)
            print("Inserted data into database")
        } catch {
            print("Error inserting data: \(error)")
        }
    }
    
    func clearDatabase() {
        do {
            try db?.run(sensorData.delete())
            print("The database has been cleared.")
        } catch {
            print("Error while clearing the database: \(error)")
        }
    }
    
    func exportDataToJSON() {
        var axArray = [Int]()
        var ayArray = [Int]()
        var azArray = [Int]()
        var irArray = [Int]()
        var redArray = [Int]()
        var recordedAt: String = ""

        // Odczyt userId z UserDefaults jako String
        guard let userId = UserDefaults.standard.value(forKey: "user_id") as? String else {
            print("No userId found in UserDefaults")
            return
        }

        do {
            let db = try Connection(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("SensorData").appendingPathExtension("sqlite3").path)
            
            let sensorData = Table("SensorData")
            let timestampColumn = SQLite.Expression<Int>("timestamp")
            let irColumn = SQLite.Expression<Int>("ir")
            let redColumn = SQLite.Expression<Int>("red")
            let accXColumn = SQLite.Expression<Int>("accX")
            let accYColumn = SQLite.Expression<Int>("accY")
            let accZColumn = SQLite.Expression<Int>("accZ")

            for row in try db.prepare(sensorData) {
                if recordedAt.isEmpty {
                    let date = Date(timeIntervalSince1970: TimeInterval(row[timestampColumn]))
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"  //Dodanie T oraz Z sformatowanej daty
                    recordedAt = dateFormatter.string(from: date)
                }

                irArray.append(row[irColumn])
                redArray.append(row[redColumn])
                axArray.append(row[accXColumn])
                ayArray.append(row[accYColumn])
                azArray.append(row[accZColumn])
            }

            // Przygotowanie słownika do serializacji JSON bez trainingId
            let jsonData: [String: Any] = [
                "ax": axArray,
                "ay": ayArray,
                "az": azArray,
                "ir": irArray,
                "red": redArray,
                "userId": userId, // userId jako String
                "recordedAt": recordedAt
            ]

            let data = try JSONSerialization.data(withJSONObject: jsonData, options: .prettyPrinted)
            let fileName = "exportedData.json"
            let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(fileName)

            try data.write(to: fileURL)
            print("Data saved to JSON file: \(fileURL)")
            print("User ID: \(userId)")
        } catch {
            print("Error exporting data to JSON: \(error)")
        }
    }
}
