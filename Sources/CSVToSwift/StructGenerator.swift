//
//  StructGenerator.swift
//  
//
//  Created by Kieran Brown on 8/31/20.
//

import Foundation

class StructGenerator {
    var csv: CSV

    init(_ csv: CSV) {
        self.csv = csv
    }

    func makeStruct(_ name: String) -> String {
        """
    public struct \(name.pascalCase()) {
        public var name: String
        public var parameter: ParameterType = .none
    }
    """
    }

    func makeExtension(_ name: String) -> String {
        var ext = "public extension \(name.pascalCase()) {"

        if let names = csv.column(for: "name"),
            let descriptions = csv.column(for: "description"),
            let parameters = csv.column(for: "parameter") {

            names.rows
                .enumerated()
                .forEach { (name) in

                    ext += "\n\n" + makeStaticProperty(name.element, description: descriptions.rows[name.offset], parameter: parameters.rows[name.offset])
            }

        }

        trackingLists.forEach { (key: String, value: [String]) in
            ext += makeList(key, cases: value)
        }

        ext += makeList("all", cases: allList)

        return ext + "\n\n}"

    }

    func makeStaticProperty(
        _ name: String,
        description: String,
        parameter: String
    ) -> String {
        """
            /// \(description)
            static let \(name.camelCase().removeSpaces()) = \(csv.name)(
                name: \"\(name.removeSpaces())\",
                parameter: .\(parameter.lowercased())
            )
        """
    }

    struct TrackedItem {
        var trackerName: String
        var values: [String]
    }

    var trackingLists: [String: [String]] {

        var lists: [String: [String]] = [:]
        if let names = csv.column(for: "name") {
            let columns = csv.columns.filter({$0.title.lowercased().contains("tracking")})
            var trackers = columns.map(\.title)

            columns.forEach { (column) in
                let events = column.rows
                    .enumerated()
                    .filter({$0.element.lowercased() == "true"})
                    .map({names.rows[$0.offset]})

                lists[column.title] = events
            }
        }


        return lists

    }

    var allList: [String] {
        if let names = csv.column(for: "name") {
           return  names.rows
        }
        return []
    }

    func makeListHead(_ name: String) -> String {
        """
        static var \(name.camelCase(" ")): [\(csv.name)] {
               [
        """
    }

    func makeList(_ name: String, cases: [String]) -> String {
        "\n\n   " + makeListHead(name) + cases.map({"          ." + $0.camelCase().removeSpaces() + ",\n"}).reduce("", +) + "\n       ]\n    }"

    }

    func generate() -> String  {
        "import Foundation\n\n" + makeStruct(csv.name) + "\n\n" + makeExtension(csv.name) + "\n\nextension \(csv.name) {\n\n" + StructGenerator.parameterTypes + "\n\n}"

    }

    static let parameterTypes = """
        public enum ParameterType: String {
            case none       = ""
            case bool       = "Bool"
            case int        = "Int"
            case double     = "Double"
            case string     = "String"
            case dictionary = "NSDictionary"
            public func validate<T>(_ value: T) -> Bool {
                switch self {
                case .none:       return false
                case .bool:       return value is Bool
                case .int:        return value is Int
                case .double:     return value is Double
                case .string:     return value is String
                case .dictionary: return value is NSDictionary
                }
            }
        }
    """
}
