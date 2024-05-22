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
    /// Holds a string representing the title of an item.
    ///
    /// - note: This property is not a function, but rather a variable that stores a `String` value.
    var title: String
    /// Indicates whether a task or operation has been completed.
    ///
    /// - note: This property is not implemented and does not have any effect.
    var isCompleted: Bool
    /// Represents a date that may or may not be set.
    ///
    /// - note: This property is an optional `Date` value, indicating that it may contain no value.
    var dueDate: Date?
}


class TaskManager: TaskProtocol {
    /// Holds an array of tasks.
    ///
    /// - note: This is a private property, indicating that it should not be accessed directly from outside the class.
    private var tasks: [Task] = []

    /// Adds a new task to the collection of tasks.
    ///
    /// - parameter task: The task to be added to the list of tasks.
    /// - returns: None, as this is a void function.
    func addTask(_ task: Task) {
        tasks.append(task)
    }

    /// Removes a task at the specified index from the `tasks` array.
    ///
    /// - parameter index: The zero-based index of the task to be removed.
    /// - throws: `TaskManagerError.indexOutOfBounds` if the provided index is out of bounds for the tasks array.
    /// - returns: None, as this function does not return a value.
    func removeTask(at index: Int) throws {
        guard index >= 0 && index < tasks.count else {
            throw TaskManagerError.indexOutOfBounds("Index \(index) is out of bounds for tasks array.")
        }
        tasks.remove(at: index)
    }

    /// Completes a task at the specified index.
    ///
    /// - parameter index: The index of the task to be marked as completed in the `tasks` array.
    /// - returns: None, as this is an internal method with no explicit return value.
    func completeTask(at index: Int) {
        if index < tasks.count {
            var task = tasks[index]
            task.isCompleted = true
            tasks[index] = task
            print("Task completed: \(task.title)")
        }
    }

    /// Prints a list of tasks with their status and due dates.
    ///
    /// - This function iterates over an array of tasks, printing each task's title, status (either "Completed" or
    /// "Pending"), and due date (if available).
    /// - parameter none: No parameters are required for this function.
    /// - returns: None, as the function only prints to the console.
    func printTasks() {
        for task in tasks {
            let status = task.isCompleted ? "Completed" : "Pending"
            let dueDateString = task.dueDate?.formatted() ?? "No due date"
            print("\(task.title) - \(status) (Due: \(dueDateString))")
        }
    }

    /// Decodes a JSON data object into an array of `Task` objects.
    ///
    /// - parameter jsonData: The JSON data to be decoded.
    /// - returns: An array of `Task` objects if decoding is successful, or throws a `TaskManagerError` with a descriptive
    /// error message if decoding fails.
    /// - note: This function uses the ISO 8601 date decoding strategy for dates in the JSON data.
    internal static func decodeTasks(from jsonData: Data) throws -> [Task] {
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode([Task].self, from: jsonData)
        } catch {
            throw TaskManagerError.decodingError("Failed to decode tasks: \(error.localizedDescription)")
        }
    }

    /// Returns a `.typeMismatch` error describing the expected type.
    ///
    /// - parameter path: The path of `CodingKey`s taken to decode a value of this type.
    /// - parameter expectation: The type expected to be encountered.
    /// - parameter reality: The value that was encountered instead of the expected type.
    /// - returns: A `DecodingError` with the appropriate path and debug description.
    internal static func _typeMismatch(at path: [CodingKey], expectation: Any.Type, reality: Any) -> DecodingError {
        let description = "Expected to decode \(expectation) but found \(_typeDescription(of: reality)) instead."
        return .typeMismatch(expectation, DecodingError.Context(codingPath: path, debugDescription: description))
    }

    /// Returns a string description of the type of the given `value`.
    ///
    /// - parameter value: The value for which to generate a type description.
    /// - returns: A string representation of the type of the given `value`.
    private static func _typeDescription(of value: Any) -> String {
        return String(describing: type(of: value))
    }

    /// Initializes an instance from JSON data.
    ///
    /// - parameter jsonData: The JSON data to be decoded and used for initialization.
    /// - throws: An error if the decoding process fails, typically due to invalid or malformed JSON data.
    /// - returns: None (void)
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
    /// Represents an optional integer value.
    ///
    /// - note: This property is used to store an integer value that may or may not be present.
    var age: Int?
    
    var email: String
}


class DataManager<T: Codable> {
    /// Initializes an empty array to store values of type `T`.
    ///
    /// - parameter none: The array is initialized with no elements.
    /// - returns: An empty array that can be used to store values of type `T`.
    var items: [T] = []

    /// Adds an item to the collection.
    ///
    /// - parameter item: The item to be added to the collection.
    /// - returns: None, as this is a void function.
    func addItem(_ item: T) {
        items.append(item)
    }

    /// Returns an optional value of type `T` at a specified index in the collection.
    ///
    /// - parameter index: The zero-based index of the item to retrieve from the collection.
    /// - returns: An optional value of type `T` if the index is within bounds, or `nil` otherwise.
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

    /// Holds a reference to the current user.
    ///
    /// - note: This variable is not a function, but rather a property that stores a `User` object.
    var currentUser: User?

    /// Returns a boolean indicating whether the current user is logged in.
    ///
    /// - returns: `true` if the current user is logged in, and `false` otherwise.
    var isUserLoggedIn: Bool {
        currentUser != nil
    }

    /// Asynchronously logs in a user with the provided credentials and calls the completion handler when done.
    ///
    /// - parameter username: The username to log in with.
    /// - parameter password: The password to log in with.
    /// - parameter completion: A closure that will be called once the login process is complete, with a boolean indicating
    /// whether the login was successful.
    /// - returns: None (asynchronous operation)
    func logIn(username: String, password: String, completion: (Bool) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.currentUser = User(username: username, age: nil, email: "\(username)@example.com")
            completion(true)
        }
    }

    /// Logs out the current user by setting `currentUser` to `nil`.
    ///
    /// - parameter none: No parameters are required for this function.
    /// - returns: None, as this function does not return a value.
    func logOut() {
        currentUser = nil
    }
}


extension User {
    /// Returns a boolean indicating whether the provided `email` string matches the expected format.
    ///
    /// - parameter email: The email address to be validated.
    /// - returns: A boolean value (`true` if the email is valid, `false` otherwise).
    var isValidEmail: Bool {
        let emailRegex = "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}$"
        return NSPredicate(format: "SELF MATCHES[c] %@", emailRegex).evaluate(with: email)
    }
}


extension DataManager where T == User {
    /// Searches for a user by their email address and returns the matching user, if found.
    ///
    /// - parameter email: The email address of the user to search for.
    /// - returns: The `User` object that matches the provided email, or `nil` if no match is found.
    func findUser(byEmail email: String) -> User? {
        items.first { $0.email == email }
    }
}


/// Returns a sanitized string representation of the given type.
///
/// - parameter type: The `Any.Type` to generate a name for.
/// - returns: A sanitized string representing the type, suitable for debugging and logging purposes.
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