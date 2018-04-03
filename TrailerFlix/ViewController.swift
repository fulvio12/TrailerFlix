//
//  ViewController.swift
//  TrailerFeix
//
//  Created by fgrmac on 03/04/18.
//  Copyright © 2018 Fulvio Resendes. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var trailers: [Trailer] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTrailers()
    }

    func loadTrailers() {
        guard let url = Bundle.main.url(forResource: "trailers", withExtension: "json") else {return}
        
        do {
            let trailerData = try Data(contentsOf: url)
            trailers = try JSONDecoder().decode([Trailer].self, from: trailerData)
            tableView.reloadData()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! TrailerViewController
        vc.trailer = sender as! Trailer
    }
    
    func showTrailer(index: Int) {
        let trailer = trailers[index]
        performSegue(withIdentifier: "trailerSegue", sender: trailer)
    }

    @IBAction func watchRandomTrailer(_ sender: UIButton) {
        let randomIndex = Int(arc4random_uniform(UInt32(trailers.count)))
        showTrailer(index: randomIndex)
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trailers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let trailer = trailers[indexPath.row]
        cell.textLabel?.text = trailer.title
        cell.detailTextLabel?.text = "\(trailer.year)"
        cell.imageView?.image = UIImage(named: "\(trailer.poster)")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        showTrailer(index: index)
    }
}
