import Foundation

protocol TaskProtocol {
    func addTask(_ task: Task)
    func removeTask(at index: Int) throws
    func completeTask(at index: Int)
    func printTasks()
}

/// `TaskManagerError` is an enumeration that conforms to the `Error` protocol.
/// It represents specific errors that can occur while managing tasks.
///
/// - `indexOutOfBounds(String)`: This case indicates that an index is out of the valid range. The associated value
/// contains a description of the error.
/// - `decodingError(String)`: This case indicates that there was an error in decoding data. The associated value
/// contains a description of the error.
enum TaskManagerError: Error {
    case indexOutOfBounds(String)
    case decodingError(String)
}

/// This type encapsulates a set of methods and properties for a specific functionality. It is used internally and its
/// details are not included in the final public documentation. Please refer to the internal documentation for more
/// information.
struct Task: Codable {
    
    var title: String
    
    var isCompleted: Bool
    
    var dueDate: Date?
}

///
/// A type that manages a list of tasks. It provides functionality to add, remove, and mark tasks as completed. It also
/// supports printing a list of tasks with their status and due dates. Tasks can be initialized from JSON data, and
/// errors encountered during decoding are handled appropriately.
///
/// This type assumes that each task has `title`, `isCompleted`, and `dueDate` properties. The `dueDate` is optional and
/// is formatted before printing. If `dueDate` is `nil`, "No due date" is printed instead.
///
/// Errors that may be thrown during the execution of methods in this type include `TaskManagerError.indexOutOfBounds`
/// when trying to remove or mark a task at an out-of-bounds index, and `TaskManagerError.decodingError` when the
/// decoding of tasks from JSON data fails.
///
/// Note: The documentation of individual methods and properties in this type is not included in this summary.
class TaskManager: TaskProtocol {
    
    private var tasks: [Task] = []

    /// Adds a new task to the tasks list.
    ///
    /// - parameter task: The `Task` object to be added to the tasks list.
    ///
    /// This function does not return a value. It modifies the `tasks` array by appending the provided `Task` object.
    func addTask(_ task: Task) {
        tasks.append(task)
    }

    /// Removes a task at the specified index from the tasks array.
    ///
    /// - parameter index: The index of the task to be removed.
    /// - throws: A `TaskManagerError.indexOutOfBounds` error if the index is not within the bounds of the tasks array.
    ///
    /// This function checks if the provided index is within the bounds of the tasks array. If it is, the task at that index
    /// is removed. If it is not, the function throws an error.
    func removeTask(at index: Int) throws {
        guard index >= 0 && index < tasks.count else {
            throw TaskManagerError.indexOutOfBounds("Index \(index) is out of bounds for tasks array.")
        }
        tasks.remove(at: index)
    }

    /// Marks a task as completed at the specified index.
    ///
    /// This function checks if the provided index is within the range of the tasks array. If it is, the task at that index
    /// is marked as completed and the updated task is saved back to the tasks array. A message is then printed to the
    /// console indicating the title of the completed task.
    ///
    /// - parameter index: The index of the task in the tasks array that should be marked as completed.
    ///
    /// Note: This function does not return any value. If the provided index is out of range, the function will not perform
    /// any action.
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
    /// This function iterates over the `tasks` array and for each task, it prints the task's title, its completion status
    /// (either "Completed" or "Pending"), and its due date. If the task does not have a due date, it prints "No due date".
    ///
    /// - Note: The `tasks` array is assumed to be a property of the enclosing instance. Each `task` is assumed to have
    /// `title`, `isCompleted`, and `dueDate` properties. The `dueDate` is optional and is formatted before printing. If
    /// `dueDate` is `nil`, "No due date" is printed instead.
    func printTasks() {
        for task in tasks {
            let status = task.isCompleted ? "Completed" : "Pending"
            let dueDateString = task.dueDate?.formatted() ?? "No due date"
            print("\(task.title) - \(status) (Due: \(dueDateString))")
        }
    }

    /// Decodes an array of `Task` objects from the provided JSON data.
    ///
    /// - parameter jsonData: The JSON data to decode.
    /// - throws: A `TaskManagerError.decodingError` if the decoding process fails.
    /// - returns: An array of `Task` objects decoded from the JSON data.
    ///
    /// This function uses the `JSONDecoder` with the `.iso8601` date decoding strategy. If the decoding process fails, it
    /// throws a `TaskManagerError.decodingError` with a description of the error.
    internal static func decodeTasks(from jsonData: Data) throws -> [Task] {
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode([Task].self, from: jsonData)
        } catch {
            throw TaskManagerError.decodingError("Failed to decode tasks: \(error.localizedDescription)")
        }
    }

    /// Returns a `.typeMismatch` error with a detailed description of the mismatch.
    ///
    /// - parameter path: An array of `CodingKey`s representing the path taken to decode a value of the expected type.
    /// - parameter expectation: The type that was expected to be encountered during decoding.
    /// - parameter reality: The actual value that was encountered instead of the expected type.
    /// - returns: A `DecodingError` indicating a type mismatch, along with the coding path and a debug description of the
    /// error.
    internal static func _typeMismatch(at path: [CodingKey], expectation: Any.Type, reality: Any) -> DecodingError {
        let description = "Expected to decode \(expectation) but found \(_typeDescription(of: reality)) instead."
        return .typeMismatch(expectation, DecodingError.Context(codingPath: path, debugDescription: description))
    }

    /// Returns a string description of the type of the given value.
    ///
    /// - parameter value: The value whose type is to be described.
    /// - returns: A `String` describing the type of the given value.
    private static func _typeDescription(of value: Any) -> String {
        return String(describing: type(of: value))
    }

    /// Initializes a new instance from the provided JSON data.
    ///
    /// - parameter jsonData: The JSON data to decode the tasks from.
    /// - throws: An error if the provided JSON data cannot be decoded into tasks.
    ///
    /// This initializer uses the `TaskManager.decodeTasks(from:)` function to decode the provided JSON data into tasks.
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


/// `NetworkError` is an enumeration that conforms to the `Error` protocol.
/// It represents a set of possible errors that can occur during network operations.
///
/// - `badURL`: Represents an error case where the provided URL is invalid.
/// - `noData`: Represents an error case where no data was returned from the network request.
/// - `decodingError(Error)`: Represents an error case where there was a problem decoding the returned data. The
/// associated value is the underlying error.
enum NetworkError: Error {
    case badURL
    case noData
    case decodingError(Error)
}

/// This type encapsulates a set of methods and properties for a specific functionality. It is used internally and
/// should not be included in the final public API documentation. The methods and properties within this type are
/// subject to change and are not intended for external use.
struct User {
    
    var username: String
    
    var age: Int?
    
    var email: String
}

///
/// This type provides methods for managing an array of items of type `T`. It includes functionality for adding items to
/// the array, retrieving items at a specific index, and loading items from a URL.
///
/// - `addItem(_:)`: This method adds an item to the `items` array. It takes a parameter of type `T` and modifies the
/// `items` array in place.
///
/// - `item(at:)`: This method returns the item at the specified index in the array. It performs a bounds check before
/// attempting to access and return the item. If the index is out of range, it returns `nil`.
///
/// - `loadItems(from:completion:)`: This method loads items from a given URL and decodes them into an array of type
/// `T`. It takes a string representation of the URL and a completion closure. The closure is called when the loading is
/// complete, with a `Result` indicating whether the loading was successful or not. If successful, the `Result` contains
/// the loaded items. If not, it contains an error indicating what went wrong.
///
/// This type is designed to prevent runtime errors by performing necessary checks and handling potential errors, such
/// as invalid URLs, failed data tasks, and decoding errors.
class DataManager<T: Codable> {
    
    var items: [T] = []

    /// Adds an item to the `items` array.
    ///
    /// - parameter item: The item of type `T` to be added to the `items` array.
    ///
    /// This function does not return a value. It modifies the `items` array in place.
    func addItem(_ item: T) {
        items.append(item)
    }

    /// Returns the item at the specified index in the array.
    ///
    /// - parameter index: The index of the item to be retrieved.
    /// - returns: The item at the specified index if it exists, or `nil` if the index is out of range.
    ///
    /// This function performs a bounds check before attempting to access and return the item at the specified index. If the
    /// index is less than 0 or greater than or equal to the count of items, the function returns `nil` to prevent a runtime
    /// error.
    func item(at index: Int) -> T? {
        guard index >= 0 && index < items.count else {
            return nil
        }
        return items[index]
    }

    /// Loads items from a given URL and decodes them into an array of type `T`.
    ///
    /// - parameter urlString: The string representation of the URL from which to load items.
    /// - parameter completion: A closure that is called when the loading is complete. This closure takes a parameter of
    /// type `Result<[T], NetworkError>`. If the loading is successful, the `Result` is a `.success` with an array of the
    /// loaded items. If the loading fails, the `Result` is a `.failure` with an error indicating what went wrong.
    ///
    /// This function first attempts to create a `URL` from the given `urlString`. If this fails, it calls the `completion`
    /// closure with a `.failure` result and a `NetworkError.badURL` error.
    ///
    /// If the `URL` creation is successful, the function starts a data task with the created `URL`. If the data task fails
    /// to retrieve data, the function calls the `completion` closure with a `.failure` result and a `NetworkError.noData`
    /// error.
    ///
    /// If the data task retrieves data successfully, the function attempts to decode the data into an array of type `T`
    /// using `JSONDecoder`. If the decoding is successful, the function calls the `completion` closure with a `.success`
    /// result and the decoded items. If the decoding fails, the function calls the `completion` closure with a `.failure`
    /// result and a `NetworkError.decodingError` error, passing the caught error to the `NetworkError.decodingError`
    /// initializer.
    ///
    /// The function resumes the data task before it returns.
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

///
/// This type provides functionality related to user authentication, including checking if a user is currently logged
/// in,
/// logging in a user with a provided username and password, and logging out the current user.
///
/// The `isLoggedIn` computed property indicates whether a user is currently logged in by checking if the `currentUser`
/// is not `nil`.
///
/// The `login` function simulates a login process by setting the `currentUser` to a new `User` instance with the
/// provided
/// username and an email derived from the username. The login process is simulated to take 1 second, after which the
/// completion handler is called with `true`. Note that this function does not actually perform any authentication and
/// is
/// intended for testing purposes.
///
/// The `logout` function logs out the current user by setting the `currentUser` to `nil`.
///
class UserAccountManager {
    
    var currentUser: User?

    /// Indicates whether the user is currently logged in.
    ///
    /// This computed property checks if the `currentUser` is not `nil`. If `currentUser` is `nil`, it means the user is not
    /// logged in.
    ///
    /// - returns: A `Bool` value indicating whether the user is logged in (`true`) or not (`false`).
    var isUserLoggedIn: Bool {
        currentUser != nil
    }

    /// Logs in a user with the provided username and password.
    ///
    /// This function simulates a login process by setting the `currentUser` to a new `User` instance with the provided
    /// username and an email derived from the username. The login process is simulated to take 1 second, after which the
    /// completion handler is called with `true`.
    ///
    /// - parameter username: The username of the user to log in.
    /// - parameter password: The password of the user to log in. Note that in this implementation, the password is not
    /// actually checked.
    /// - parameter completion: A closure to be executed once the login process is completed. This closure takes a single
    /// Boolean parameter, which is always `true` in this implementation.
    ///
    /// - Note: This function does not actually perform any authentication. It is a mock function for testing purposes.
    func logIn(username: String, password: String, completion: (Bool) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.currentUser = User(username: username, age: nil, email: "\(username)@example.com")
            completion(true)
        }
    }

    /// Logs out the current user.
    ///
    /// This function sets the `currentUser` to `nil`, effectively logging out the user from the system.
    func logOut() {
        currentUser = nil
    }
}

/// A computed property that validates an email string.
///
/// This property uses a regular expression to check the format of the email string. It checks for the presence of
/// alphanumeric characters, periods, underscores, percent signs, plus signs, and hyphens before the @ symbol.
/// After the @ symbol, it checks for the presence of alphanumeric characters, periods, and hyphens. Finally, it
/// checks for a period followed by two to four uppercase letters at the end of the string.
///
/// - Returns: A `Bool` indicating whether the email string matches the regular expression. Returns `true` if the
/// email string is valid, `false` otherwise.
extension User {
    /// Checks if the email string is valid.
    ///
    /// This computed property uses a regular expression to validate the format of the email string. The regular expression
    /// checks for the presence of alphanumeric characters, periods, underscores, percent signs, plus signs, and hyphens
    /// before the @ symbol. After the @ symbol, it checks for the presence of alphanumeric characters, periods, and
    /// hyphens. Finally, it checks for a period followed by two to four uppercase letters at the end of the string.
    ///
    /// - returns: A `Bool` indicating whether the email string matches the regular expression. Returns `true` if the email
    /// string is valid, `false` otherwise.
    var isValidEmail: Bool {
        let emailRegex = "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}$"
        return NSPredicate(format: "SELF MATCHES[c] %@", emailRegex).evaluate(with: email)
    }
}

/// This type provides functionality to find a `User` object based on the provided email.
///
/// It includes a method that takes an email address as a parameter and returns an optional `User` object. If a `User`
/// with the provided email is found, that `User` is returned; otherwise, `nil` is returned.
extension DataManager where T == User {
    /// Finds and returns a `User` object based on the provided email.
    ///
    /// - parameter email: The email address used to find the corresponding `User`.
    /// - returns: An optional `User` object. If a `User` with the provided email is found, that `User` is returned;
    /// otherwise, `nil` is returned.
    func findUser(byEmail email: String) -> User? {
        items.first { $0.email == email }
    }
}

