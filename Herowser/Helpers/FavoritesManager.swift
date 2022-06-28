//
//  FavoritesManager.swift
//  Herowser
//
//  Created by Egemen Ayhan on 28.06.2022.
//

import Foundation

// MARK: UserDefaultsType

protocol UserDefaultsType {

    func data(forKey defaultName: String) -> Data?
    func set(_ value: Any?, forKey defaultName: String)

}

// MARK: UserDefaults extension

extension UserDefaults: UserDefaultsType {}

// MARK: UserDefaultsManager

class FavoritesManager {

    enum Constants {
        static let HeroListKey = "HeroList"
    }

    static let shared = FavoritesManager(defaults: UserDefaults.standard)
    private let defaults: UserDefaultsType
    private(set) var heroes: [Hero] = []

    init(defaults: UserDefaultsType) {
        self.defaults = defaults
        heroes = getHeroList()
    }

    private func getHeroList() -> [Hero] {
        guard let data = defaults.data(forKey: Constants.HeroListKey) else { return [] }
        return (try? JSONDecoder().decode([Hero].self, from: data)) ?? []
    }

    func save() {
        let data = try? JSONEncoder().encode(heroes)
        defaults.set(data, forKey: Constants.HeroListKey)
    }

    // MARK: - Favorite operations

    func toggleFavoriteState(for hero: Hero) {
        if let index = heroes.firstIndex(where: { $0.id == hero.id }) {
            heroes.remove(at: index)
        } else {
            heroes.append(hero)
        }
        save()
        NotificationCenter.default.post(
            name: .favoriteStateUpdatedNotification,
            object: nil,
            userInfo: [NotificationInfoKeys.heroID: hero.id]
        )
    }

    func isFavorite(heroID: Int) -> Bool {
        return heroes.contains(where: { $0.id == heroID })
    }

}

extension Notification.Name {

    static let favoriteStateUpdatedNotification = Notification.Name("HeroFavoriteStateUpdated")

}

enum NotificationInfoKeys {
    case heroID
}

