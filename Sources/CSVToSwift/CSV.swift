//
//  CSV.swift
//  
//
//  Created by Kieran Brown on 8/31/20.
//

import Foundation

struct CSV {
    var name: String
    var keys: [String]
    var entries: [[String]]

    init(_ csv: String, name: String? = nil) {

        self.name = name ?? .placeholder

        entries = csv
            .split(separator: "\r\n")  // Split by linebreaks.
            .map { entry in

                entry
                    .split(separator: ",")  // Split into values.
                    .map(\.string)          // Get String.
        }

        // First row is the parameter names
        keys = entries
            .removeFirst() // Remove it from the entries
    }

}

extension CSV {
    var entryCount: Int {
        columns[0].rows.count
    }

    var columnCount: Int {
        keys.count
    }

    struct Column {
        var title: String
        var rows: [String]
    }

    var columns: [Column] {
                keys
                    .enumerated()
                    .map({ key in

                        Column(
                            title: key.element,
                            rows: entries.map { $0[key.offset] }
                        )
        })
    }


    func column(for key: String) -> Column? {
        columns.first(where: {$0.title.lowercased() == key})
    }
}
