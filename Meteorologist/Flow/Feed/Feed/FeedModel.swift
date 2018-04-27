//
//  FeedModel.swift
//  Meteorologist
//
//  Created by Ruslan on 4/27/18.
//  Copyright © 2018 Ruslan Popesku. All rights reserved.
//

import APIClient
import EventsTree

enum FeedEvent: Event {
    
    case repositorySelected(repository: Repository)
    
}

enum FeedViewAction {
    
    case viewLoaded
    case viewAppeared
    case refreshControlTriggered
    case willDisplayRepositoryAt(Int)
    case didSelectRepositoryAt(Int)
    
}

protocol FeedModelInput: ControllerVisibilityOutput {
    
    func perform(action: FeedViewAction)
    func numberOfRepositories() -> Int
    func repository(at index: Int) -> FeedModel.DisplayableRepository?
    
}

protocol FeedModelOutput: class {
    
    func didStartActivity(_ activity: FeedModel.Activity)
    func didFinishActivity(_ activity: FeedModel.Activity, hasNewData: Bool)
    func didFinishActivity(_ activity: FeedModel.Activity, with error: Error)
    func displayBadgeValue(_ badge: String?)
    
}

class FeedModel: Model, NetworkClientInjectable, DBClientInjectable {
    
    enum Activity {
        case reload, loadMore
    }
    
    weak var output: FeedModelOutput!
    fileprivate var observable: RequestObservable<Repository>!
    
    struct DisplayableRepository {
        let name: String
        let username: String
        let avatarImageURL: URL?
    }
    
    fileprivate var repositories = [Repository]()
    fileprivate var isLoadingData = false
    fileprivate var lastLoadedRepositoryId: Int {
        return repositories.last?.id ?? 0
    }
    
    override init(parent: EventNode?) {
        super.init(parent: parent)
        
        addObservable()
        addHandler { [weak self] (event: PushNotificationEvent) in
            guard let `self` = self, case .newRepoAvailable = event else {
                return
            }
            
            print("action feed by push")
            if self.isActive {
                self.reloadFeed(useCache: false)
            } else {
                self.output.displayBadgeValue("1")
            }
        }
    }
    
}

extension FeedModel: FeedModelInput, FeedViewControllerOutput {
    
    func perform(action: FeedViewAction) {
        switch action {
        case .didSelectRepositoryAt(let index):
            precondition(index < repositories.count && index >= 0)
            let repository = repositories[index]
            let event = FeedEvent.repositorySelected(repository: repository)
            raise(event: event)
            
        case .willDisplayRepositoryAt(let index):
            if index == numberOfRepositories() - 1 {
                loadNextFeedPage()
            }
            
        case .refreshControlTriggered:
            reloadFeed(useCache: false)
            
        case .viewLoaded:
            reloadFeed(useCache: true)
            
        case .viewAppeared:
            output.displayBadgeValue(nil)
            
        }
    }
    
    /**
     Loads repositories and replaces existing array with loaded repositories
     
     - Parameter useCache: Load repositories from database cache at first
     */
    fileprivate func reloadFeed(useCache: Bool) {
        if !isLoadingData {
            isLoadingData = true
            output.didStartActivity(.reload)
            
            let completion: ([Repository]?, Error?) -> Void = { [weak self] repositories, error in
                guard let strongSelf = self else {
                    return
                }
                
                guard let repositories = repositories else {
                    dump(error)
                    strongSelf.output.didFinishActivity(.reload, with: error!)
                    return
                }
                
                strongSelf.repositories = repositories
                strongSelf.output.didFinishActivity(.reload, hasNewData: true)
                
                strongSelf.isLoadingData = false
            }
            
            if useCache {
                loadRepositoriesFromDatabase().continueWith(.mainThread) { task in
                    if let repositories = task.result {
                        completion(repositories, nil)
                    } else if let error = task.error {
                        // There is no need to show error to user because we have network request to resque
                        dump(error)
                    }
                }
            }
            
            let request = GetRepositoriesRequest()
            loadRepositories(with: request, completion: completion)
        } else {
            output.didFinishActivity(.reload, hasNewData: false)
        }
    }
    
    /**
     Loads new bunch of repositories and adds them to existing repositories array
     
     - Important: Loading always from network - database cache is ignored
     */
    private func loadNextFeedPage() {
        guard !isLoadingData else {
            output.didFinishActivity(.loadMore, hasNewData: false)
            return
        }
        isLoadingData = true
        
        output.didStartActivity(.loadMore)
        
        let request = GetRepositoriesRequest(since: lastLoadedRepositoryId)
        loadRepositories(with: request) { [weak self] repositories, error in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.isLoadingData = false
            
            guard let repositories = repositories else {
                strongSelf.output.didFinishActivity(.loadMore, with: error!)
                return
            }
            
            strongSelf.repositories.append(contentsOf: repositories)
            strongSelf.output.didFinishActivity(.loadMore, hasNewData: !repositories.isEmpty)
        }
    }
    
    /**
     Returns quantity of currently loaded repositories
     */
    func numberOfRepositories() -> Int {
        return repositories.count
    }
    
    /**
     Returns repository by its index
     
     - Parameter index: Position of repository in repository array
     
     - Important: Array position of repository is equal to row index of asked repository
     */
    func repository(at index: Int) -> DisplayableRepository? {
        // We don't check for index in range because it is developer error and should be exposed
        return displayableRepository(from: repositories[index])
    }
    
}

// MARK - Requests & DB logic assembling

extension FeedModel {
    
    /**
     Loads repositories
     
     - Fetch available repositories from DB
     - Execute API request to receive available repositories
     - Save received repositories to DB and update view
     */
    fileprivate func loadRepositories(with request: GetRepositoriesRequest, completion: @escaping ([Repository]?, Error?) -> Void) {
        networkClient.execute(request: request).continueWith(.mainThread) { [weak self] task in
            guard let strongSelf = self else {
                return
            }
            
            guard let repositories = task.result else {
                if let error = task.error {
                    completion(nil, error)
                }
                
                return
            }
            
            strongSelf.saveRepositories(repositories).continueWith(.mainThread) { task in
                if let error = task.error {
                    // There is no need to show this error because user will receive data and he doesn't care
                    dump(error)
                }
                completion(repositories, nil)
            }
        }
        
    }
    
}

// MARK: Database logic

extension FeedModel {
    
    fileprivate func addObservable() {
        observable = dbClient.observable(for: FetchRequest<Repository>())
        
        observable.observe { [weak self] changeSet in
            guard let strongSelf = self else {
                return
            }
            
            switch changeSet {
            case .initial(let objects):
                strongSelf.repositories = objects
                break
                
            case .change(objects: let objects, deletions: _, insertions: _, modifications: _):
                strongSelf.repositories = objects
                /**
                 Call output method here and update/insert/delete
                 UITableViewCells in view controller (if needed)
                 */
                
            case .error(let error):
                print("Got an error: \(error)")
            }
        }
    }
    
    fileprivate func saveRepositories(_ repositories: [Repository]) -> Task<[Repository]> {
        return dbClient.insert(repositories)
    }
    
    fileprivate func loadRepositoriesFromDatabase() -> Task<[Repository]> {
        let predicate = NSPredicate(format: "private = %@", "false")
        let request = FetchRequest<Repository>().filtered(with: predicate)
        
        return dbClient.execute(request)
    }
}

// MARK: Convertation to displayable structs

extension FeedModel {
    
    fileprivate func displayableRepositories(from repositories: [Repository]) -> [DisplayableRepository] {
        return repositories.map { repository in
            displayableRepository(from: repository)
        }
    }
    
    fileprivate func displayableRepository(from repository: Repository) -> DisplayableRepository {
        return DisplayableRepository(
            name: repository.fullName,
            username: repository.owner?.nickname ?? "",
            avatarImageURL: repository.owner?.avatarURL
        )
    }
    
}
