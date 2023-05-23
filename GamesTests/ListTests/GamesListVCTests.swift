//
//  GamesListVCTests.swift
//  GamesTests
//
//  Created by Ismael Mahmoud AlShabrawy on 22/05/2023.
//

import XCTest
@testable import Games

class GamesListVCTests: XCTestCase {

    var sut: GamesListVC!
    var viewModelMock: GamesListViewModelMock!

    override func setUp() {
        super.setUp()
        sut = GamesListVC()
        viewModelMock = GamesListViewModelMock(host: sut)
        sut.viewModel = viewModelMock
        sut.loadViewIfNeeded()
    }

    override func tearDown() {
        sut = nil
        viewModelMock = nil
        super.tearDown()
    }

    func testViewDidLoad_ConfiguresTableView() {
        XCTAssertNotNil(sut.gamesTableView.dataSource)
        XCTAssertNotNil(sut.gamesTableView.delegate)
        XCTAssertNotNil(sut.gamesTableView.prefetchDataSource)
    }

    func testTableViewDataSource_NumberOfRows() {
        sut.viewModel = GamesListViewModel(host: sut)
        let expectedNumberOfRows = sut.viewModel.numberOfCells()
        let actualNumberOfRows = sut.tableView(sut.gamesTableView, numberOfRowsInSection: 0)
        XCTAssertEqual(actualNumberOfRows, expectedNumberOfRows)
    }

    func testTableViewDataSource_CellForRow() {
        sut.viewModel = GamesListViewModel(host: sut)
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = sut.tableView(sut.gamesTableView, cellForRowAt: indexPath)
        XCTAssertTrue(cell is GameCell)
    }

    func testTableViewDelegate_DidSelectRow() {
        sut.viewModel = GamesListViewModel(host: sut)
        let indexPath = IndexPath(row: 0, section: 0)
        sut.tableView(sut.gamesTableView, didSelectRowAt: indexPath)
        // Add your assertion for the expected behavior after selecting a row
    }
}

class GamesListViewModelMock: GamesListViewModel {

    var numberOfCellsCalled = false
    var cellForRowCalled = false
    var didSelectCellCalled = false
    var gameWillDisplayCalled = false

    override func numberOfCells() -> Int {
        numberOfCellsCalled = true
        return 3
    }

    override func cellForRow(at indexPath: IndexPath) -> UITableViewCell {
        cellForRowCalled = true
        return UITableViewCell()
    }

    override func didSelectCell(at indexPath: IndexPath) {
        didSelectCellCalled = true
    }

    override func gameWillDisplay(at indexPath: IndexPath) {
        gameWillDisplayCalled = true
    }
}
