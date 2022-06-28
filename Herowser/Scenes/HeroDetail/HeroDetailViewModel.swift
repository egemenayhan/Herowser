//
//  HeroDetailViewModel.swift
//  Herowser
//
//  Created by Egemen Ayhan on 28.06.2022.
//

import Foundation
import Combine

struct HeroDetailState {

    var hero: Hero
    var comics: [Comic]?

    enum Change: StateChange {
        case loading
        case loaded
        case comicsFetched
        case favoriteStateChanged
    }

}

class HeroDetailViewModel: StatefulViewModel<HeroDetailState.Change> {

    var state: HeroDetailState
    private var subscriptions = Set<AnyCancellable>()

    init(state: HeroDetailState) {
        self.state = state
        super.init()

        NotificationCenter.default
            .publisher(for: Notification.Name.favoriteStateUpdatedNotification)
            .sink(receiveValue: { [weak self] notification in
                guard let self = self,
                      let id = notification.userInfo?[NotificationInfoKeys.heroID] as? Int,
                      id == state.hero.id else { return }
                self.emit(change: .favoriteStateChanged)
            })
            .store(in: &subscriptions)
    }

    func fetchDetails() {
        emit(change: .loading)
        let request = HeroComicsRequest(heroID: state.hero.id)
        NetworkManager.shared.execute(request: request)
            .receive(on: DispatchQueue.main)
            .map { $0.results }
            .sink(receiveCompletion: { [weak self] result in
                guard let self = self else { return }
                self.emit(change: .loaded)
                guard case let .failure(error) = result else {
                    return
                }
                print("Error ocurred on fetching comics: \(error.localizedDescription)")
            }, receiveValue: { [weak self] comics in
                guard let self = self else { return }
                self.state.comics = comics
                self.emit(change: .comicsFetched)
            })
            .store(in: &subscriptions)
    }

    func toggleFavorite() {
        FavoritesManager.shared.toggleFavoriteState(for: state.hero)
    }

}
