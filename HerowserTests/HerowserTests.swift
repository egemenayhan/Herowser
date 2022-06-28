//
//  FavoritesManagerTests.swift
//  HerowserTests
//
//  Created by Egemen Ayhan on 27.06.2022.
//

import XCTest
@testable import Herowser

class FavoritesManagerTests: XCTestCase {

    private enum Constants {
        static let hero1 = Hero(id: 1, name: "Egemen")
        static let hero2 = Hero(id: 2, name: "Ayhan")
    }

    var mockDefaults: MockUserDefaults!
    var manager: FavoritesManager!

    override func setUpWithError() throws {
        mockDefaults = MockUserDefaults()
        manager = FavoritesManager(defaults: mockDefaults)
    }

    func testSaveGame() throws {
        manager.toggleFavoriteState(for: Constants.hero1)
        XCTAssertEqual(mockDefaults.heroes?.count, 1)
        XCTAssertNotNil(mockDefaults.storage[FavoritesManager.Constants.HeroListKey])
    }

    func testGetGames() throws {
        manager.toggleFavoriteState(for: Constants.hero1)
        manager.toggleFavoriteState(for: Constants.hero2)
        XCTAssertEqual(mockDefaults.heroes?.count, 2)
        XCTAssertEqual(manager.heroes.count, 2)
    }

    func testAddToFavorite() throws {
        manager.toggleFavoriteState(for: Constants.hero1)
        XCTAssertEqual(mockDefaults.heroes?.count, 1)
        XCTAssertEqual(manager.heroes.count, 1)
        XCTAssertNotNil(mockDefaults.storage[FavoritesManager.Constants.HeroListKey])
    }

    func testIsFavorite() throws {
        manager.toggleFavoriteState(for: Constants.hero1)
        XCTAssertEqual(mockDefaults.heroes?.count, 1)
        XCTAssertEqual(manager.heroes.count, 1)

        XCTAssertEqual(manager.isFavorite(heroID: Constants.hero1.id), true)
        manager.toggleFavoriteState(for: Constants.hero1)
        XCTAssertEqual(manager.isFavorite(heroID: Constants.hero1.id), false)
    }

}

class MockUserDefaults: UserDefaultsType {

    var storage: [String: Any] = [:]

    var heroes: [Hero]? {
        return getHeroList()
    }

    private func getHeroList() -> [Hero]? {
        guard let data = storage[FavoritesManager.Constants.HeroListKey] as? Data else { return [] }
        return (try? JSONDecoder().decode([Hero].self, from: data))
    }

    func data(forKey defaultName: String) -> Data? {
        return storage[defaultName] as? Data
    }

    func set(_ value: Any?, forKey defaultName: String) {
        storage[defaultName] = value
    }

}

