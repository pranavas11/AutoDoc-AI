import SwiftUI
import MapKit
import CoreLocation
import Foundation

protocol TaskProtocol {
    func addTask(_ task: Task)
    func removeTask(at index: Int) throws
    func completeTask(at index: Int)
    func printTasks()
}

enum TaskManagerError: Error {
    case indexOutOfBounds(String)
    case decodingError(String)
}

struct Task: Codable {
    var title: String
    var isCompleted: Bool
    var dueDate: Date?
}

class TaskManager: TaskProtocol {
    private var tasks: [Task] = []

    func addTask(_ task: Task) {
        tasks.append(task)
    }

    func removeTask(at index: Int) throws {
        guard index >= 0 && index < tasks.count else {
            throw TaskManagerError.indexOutOfBounds("Index \(index) is out of bounds for tasks array.")
        }
        tasks.remove(at: index)
    }

    func completeTask(at index: Int) {
        if index < tasks.count {
            var task = tasks[index]
            task.isCompleted = true
            tasks[index] = task
            print("Task completed: \(task.title)")
        }
    }

    func printTasks() {
        for task in tasks {
            let status = task.isCompleted ? "Completed" : "Pending"
            let dueDateString = task.dueDate?.formatted() ?? "No due date"
            print("\(task.title) - \(status) (Due: \(dueDateString))")
        }
    }

    internal static func decodeTasks(from jsonData: Data) throws -> [Task] {
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode([Task].self, from: jsonData)
        } catch {
            throw TaskManagerError.decodingError("Failed to decode tasks: \(error.localizedDescription)")
        }
    }

    internal static func _typeMismatch(at path: [CodingKey], expectation: Any.Type, reality: Any) -> DecodingError {
        let description = "Expected to decode \(expectation) but found \(_typeDescription(of: reality)) instead."
        return .typeMismatch(expectation, DecodingError.Context(codingPath: path, debugDescription: description))
    }

    private static func _typeDescription(of value: Any) -> String {
        return String(describing: type(of: value))
    }

    init(from jsonData: Data) throws {
        self.tasks = try TaskManager.decodeTasks(from: jsonData)
    }
}

let jsonData = """
[
    {"title": "Submit expense report", "isCompleted": false, "dueDate": "2021-05-01T12:00:00Z"},
    {"title": "Prepare project presentation", "isCompleted": false, "dueDate": "2021-05-02T15:00:00Z"}
]
""".data(using: .utf8)!

do {
    let taskManager = try TaskManager(from: jsonData)
    taskManager.printTasks()
} catch {
    print("An error occurred: \(error)")
}

enum NetworkError: Error {
    case badURL
    case noData
    case decodingError(Error)
}

struct User {
    var username: String
    var age: Int?
    var email: String
}

class DataManager<T: Codable> {
    var items: [T] = []

    func addItem(_ item: T) {
        items.append(item)
    }

    func item(at index: Int) -> T? {
        guard index >= 0 && index < items.count else {
            return nil
        }
        return items[index]
    }

    func loadItems(from urlString: String, completion: @escaping (Result<[T], NetworkError>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.badURL))
            return
        }
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            do {
                let decodedItems = try JSONDecoder().decode([T].self, from: data)
                completion(.success(decodedItems))
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }.resume()
    }
}

class UserAccountManager {

    var currentUser: User?

    var isUserLoggedIn: Bool {
        currentUser != nil
    }

    func logIn(username: String, password: String, completion: (Bool) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.currentUser = User(username: username, age: nil, email: "\(username)@example.com")
            completion(true)
        }
    }

    func logOut() {
        currentUser = nil
    }
}

extension User {
    var isValidEmail: Bool {
        let emailRegex = "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}$"
        return NSPredicate(format: "SELF MATCHES[c] %@", emailRegex).evaluate(with: email)
    }
}

extension DataManager where T == User {
    func findUser(byEmail email: String) -> User? {
        items.first { $0.email == email }
    }
}


@usableFromInline
func typeName(_ type: Any.Type) -> String {
var name = _typeName(type, qualified: true)
if let index = name.firstIndex(of: ".") {
    name.removeSubrange(...index)
}
let sanitizedName =
    name
    .replacingOccurrences(
    of: #"<.+>|\(unknown context at \$[[:xdigit:]]+\)\."#,
    with: "",
    options: .regularExpression
    )
return sanitizedName
}