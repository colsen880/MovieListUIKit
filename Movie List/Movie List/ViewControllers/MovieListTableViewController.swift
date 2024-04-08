//
//  MovieListTableViewController.swift
//  Movie List
//
//  Created by Chad Olsen on 9/25/23.
//  Copyright © 2023 colsen. All rights reserved.
//

import UIKit
import CoreData

class MovieListTableViewController: UITableViewController {
    let movieAPI = MovieAPI()
    var movies: [Movie] = []
    var posters: [Int : UIImage] = [:]
    var favorites: [Favorite] = []
    var context: NSManagedObjectContext?
    
    private lazy var persistentContainer: NSPersistentContainer = {
        NSPersistentContainer(name: "Favorites")
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        context = persistentContainer.viewContext
        loadStore()
        getMovies()
        setupUI()
    }
    
    private func loadStore() {
        persistentContainer.loadPersistentStores { [weak self] persistentStoreDescription, error in
            guard error == nil else {
                print("Unable to Add Persistent Store")
                print("\(String(describing: error)), \(error!.localizedDescription)")
                return
            }
            self?.fetchFavorites()
        }
    }

    private func getMovies() {
        movieAPI.getMovieList() { movieList in
            self.movies = movieList
            self.getPosters() {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        
    }
    
    private func getPosters(completion: @escaping() -> Void) {
        for movie in movies {
            movieAPI.getImage(filePath: movie.posterPath) { image in
                self.posters[movie.id] = image
                completion()
            }
        }
    }
    
    private func saveFavorites(id: Int) {
        guard let managedContext = context else { return }
        
        let favorite = Favorite(context: managedContext)
        favorite.movieID = Int64(id)
        do {
            try managedContext.save()
        } catch {
            print("faild to save with error: \(error)")
        }
    }
    
    private func removeFavorite(id: Int) {
        guard let managedContext = context else { return }
        
        let favorite = favorites.filter({ $0.movieID == id })
        managedContext.delete(favorite[0])
        do {
            try managedContext.save()
        } catch {
            print(error)
        }
    }
    
    private func fetchFavorites() {
        let fetchRequest: NSFetchRequest<Favorite> = Favorite.fetchRequest()
        persistentContainer.viewContext.perform {
            do {
                self.favorites = try fetchRequest.execute()
            } catch {
                print("unable to execute request with error: \(error)")
            }
        }
    }
    
    private func setupUI() {
        tableView.register(MovieInfoTableViewCell.self, forCellReuseIdentifier: "MovieInfoCell")
    }
    
    @objc private func favoriteMoviePushed(_ sender: UIButton) {
        if sender.isSelected {
            removeFavorite(id: sender.tag)
            sender.isSelected = false
        } else {
            saveFavorites(id: sender.tag)
            sender.isSelected = true
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movie = movies[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MovieInfoCell", for: indexPath) as? MovieInfoTableViewCell {
            cell.title.text = movie.title
            cell.subtitle.text = movie.releaseDate
            cell.poster.image = posters[movie.id]
            cell.movieDescription.text = movie.overview
            cell.button.tag = movie.id
            cell.button.addTarget(self, action: #selector(favoriteMoviePushed(_:)), for: .touchUpInside)
            cell.button.isSelected = !favorites.filter({ $0.movieID == movie.id }).isEmpty
            return cell
        } else {
            return UITableViewCell()
        }
    }
}
