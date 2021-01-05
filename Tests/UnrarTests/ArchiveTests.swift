// SPDX-FileCopyrightText: 2021 mtgto <hogerappa@gmail.com>
// SPDX-License-Identifier: MIT

import XCTest

@testable import Unrar

final class ArchiveTests: XCTestCase {
    func testOpenNotExistsArchive() {
        guard let path = Bundle.module.path(forResource: "test", ofType: "rar") else {
            XCTFail()
            return
        }
        let archive = Archive(path: path + ".not.exists")
        XCTAssertThrowsError(try archive.entries())
    }

    func testExample() throws {
        guard let path = Bundle.module.path(forResource: "test", ofType: "rar") else {
            XCTFail()
            return
        }
        let archive = Archive(path: path)
        XCTAssertNotNil(archive)
        let entries = try archive.entries()
        XCTAssertEqual(entries.count, 1)
        XCTAssertEqual(entries[0].fileName, "README.md")
        XCTAssertEqual(entries[0].uncompressedSize, 40)
    }

    func testExtract() throws {
        guard let path = Bundle.module.path(forResource: "test", ofType: "rar") else {
            XCTFail()
            return
        }
        let archive = Archive(path: path)
        XCTAssertNotNil(archive)
        let entries = try archive.entries()
        var data: Data = Data()
        try archive.extract(entries[0]) { receivedData, progress in
            data.append(receivedData)
        }
        XCTAssertEqual(data.count, 40)
    }

    func testMultibyteArchive() throws {
        guard let path = Bundle.module.path(forResource: "multibyte.v4", ofType: "rar") else {
            XCTFail()
            return
        }
        let archive = Archive(path: path)
        XCTAssertNotNil(archive)
        let entries = try archive.entries()
        XCTAssertEqual(entries.count, 4)
    }

    func testExtractEncrypted() throws {
        guard let path = Bundle.module.path(forResource: "encrypted", ofType: "rar") else {
            XCTFail()
            return
        }
        let archive = Archive(path: path)
        XCTAssertNotNil(archive)
        let entries = try archive.entries()
        var data: Data = Data()
        try archive.extract(entries[0]) { receivedData, progress in
            data.append(receivedData)
        }
        XCTAssertEqual(data.count, 40)
    }

    static var allTests = [
        ("testExample", testExample)
    ]
}
