//
//  main.swift
//  
//
//  Created by Kieran Brown on 8/31/20.
//

import ArgumentParser
import Foundation

struct FindAndParse: ParsableCommand {

  @Option(help: "The file URL we want.",
          transform: URL.init(fileURLWithPath:))
  var input: URL

    @Option(help: "The file to generate",
            transform: URL.init(fileURLWithPath:))
    var output: URL


  mutating func validate() throws {
    // Verify the file actually exists.
    guard FileManager.default.fileExists(atPath: input.path) else {
      throw ValidationError("File does not exist at \(input.path)")
    }
  }

  func run() throws {
    // Do something with pathToFile...
    if let model = FileManager.default.contents(atPath: input.path) {
       let str = String(data: model, encoding: .utf8)
       let csv = CSV(str ?? "", name: "Event")
        let generator = StructGenerator(csv)
        let generated = generator.generate()
        print(generated)


        FileManager.default.createFile(atPath: output.path, contents: generated.data(using: .utf8)!, attributes: [:])

    }


  }
}
FindAndParse.main()
