//
//  MovieDetailViewModelTests.swift
//  JatAppTestAppTests
//
//  Created by Yurii Zaiachkivskyi on 01.02.2023.
//

import XCTest
@testable import JatAppTestApp

final class MovieDetailViewModelTests: XCTestCase {

    func testParseNameToFindLettersCount() {
        let incomingName1 = "tTttFffFF"
        let incomingName2 = "tttFffF"
        let expectedMessage = ["f=5","t=4"]
        
        let movieDetailsModel = MovieDetailViewModel()
        let parsedName1 = movieDetailsModel.parseNameToFindLettersCount(movieName: incomingName1)
        let parsedName2 = movieDetailsModel.parseNameToFindLettersCount(movieName: incomingName2)
        
        XCTAssertTrue(parsedName1 == expectedMessage)
        XCTAssertFalse(parsedName2 == expectedMessage)
    }
}

