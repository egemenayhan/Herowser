//
//  HeroesViewModel.swift
//  Herowser
//
//  Created by Egemen Ayhan on 27.06.2022.
//

import Foundation

struct HeroesState {

    var heroes: [Hero] = []
    var nextPage: Int?
    var lastFetchAttempt: Int?
    var isFetchInProgress = false

    enum Change: StateChange {
        case refreshLoading
        case refreshLoaded
        case paginationLoading
        case paginationLoaded
        case paginationError
        case reloaded
        case paginated(newHeroes: [Hero], diffCount: Int)
        case errorOcurred(String?)
    }

}

class HeroesViewModel: StatefulViewModel<HeroesState.Change> {

    enum Constants {
        static let fetchRetryThreshold = 3
        static let pageLimit = 30
    }

    var state = HeroesState()
    var activeTask: URLSessionTask?
    private var fetchRetryCount = 0

    func reloadData() {
        loadData()
    }

    func nextPage() {
        guard let page = state.nextPage else { return }
        loadData(page: page)
    }

    func retry() {
        guard let page = state.lastFetchAttempt else { return }
        loadData(page: page)
    }

    private func loadData(page: Int = 0) {
        guard !state.isFetchInProgress else {
            emit(change: .refreshLoaded)
            return
        }
        let isInitialFetch = page == 0 && state.heroes.isEmpty
        isInitialFetch ? emit(change: .refreshLoading) : emit(change: .paginationLoading)
        state.isFetchInProgress = true
        state.lastFetchAttempt = page

        let req = HeroesRequest(page: 0, itemPerPage: Constants.pageLimit)
        activeTask = NetworkManager.shared.execute(request: req) { [weak self] response in
            guard let self = self else { return }
            self.activeTask = nil

            switch response.result {
            case .success(let baseResponse):
                print(baseResponse.results)
                self.handleResponse(baseResponse: baseResponse, isInitialFetch: isInitialFetch, page: page)
            case .failure(let error):
                print(error.localizedDescription)
                self.emit(change: .paginationError)
                self.emit(change: .refreshLoaded)
                self.emit(change: .errorOcurred(error.description ?? "Couldn`t fetch data."))
            }
        }
    }

    func handleResponse(baseResponse: HeroesRequest.Response, isInitialFetch: Bool, page: Int) {
        guard baseResponse.count ?? 0 > 0 else { // automatically fetches next page if people count is 0
            let initialPageHasNextPage = (baseResponse.hasNextPage && isInitialFetch)
//            let isNextPageDifferent = ((state.nextPage != nil) && !isInitialFetch && (state.nextPage != next))
            if (initialPageHasNextPage || state.nextPage != nil)
                && fetchRetryCount < Constants.fetchRetryThreshold { // fetch if there is next page
                emit(change: .refreshLoaded)
                fetchRetryCount += 1
                loadData(page: page + 1)
            } else if isInitialFetch,
                      state.heroes.isEmpty,
                      fetchRetryCount < Constants.fetchRetryThreshold { // retry initial fetch if there is no next page and people

                emit(change: .refreshLoaded)
                fetchRetryCount += 1
                loadData()
            } else if isInitialFetch { // can not retry again for initial fetch
                emit(change: .refreshLoaded)
                emit(change: .errorOcurred("Failed to reload page."))
            } else { // can not retry again for pagination
                emit(change: .paginationError)
            }
            return
        }
        state.nextPage = baseResponse.hasNextPage ? page + 1 : nil
        isInitialFetch ? emit(change: .refreshLoaded) : emit(change: .paginationLoaded)
        fetchRetryCount = 0 // reset retry count on successfull operation
        if isInitialFetch {
            state.heroes = baseResponse.results ?? []
            emit(change: .reloaded)
        } else {
            let diffCount = baseResponse.count ?? 0
            guard diffCount > 0 else { return }
            state.heroes.append(contentsOf: baseResponse.results ?? []) // append new people to our data source
            emit(change: .paginated(newHeroes: baseResponse.results ?? [], diffCount: diffCount))
        }
    }

}
