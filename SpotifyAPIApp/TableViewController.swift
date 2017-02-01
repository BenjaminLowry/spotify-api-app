//
//  ViewController.swift
//  SpotifyAPIApp
//
//  Created by Ben LOWRY on 1/28/17.
//  Copyright © 2017 Ben LOWRY. All rights reserved.
//

import UIKit
import Alamofire
import AVFoundation

//our song structure to store our songs!
struct SongItem {
    let mainImage: UIImage!
    let songName: String!
    let previewURL: String!
}

class TableViewController: UITableViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    
    //array of songs to show
    var songs = [SongItem]()
    
    //our URL string that we are searching for
    var searchURL = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //setting the search bar's delegate to this view controller
        searchBar.delegate = self
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        //the text received from our search bar
        let searchText = searchBar.text!
        
        //changing from text to 'keywords'
        let keywords = searchText.replacingOccurrences(of: " ", with: "+")
        
        //our Spotify URL for our song results
        searchURL = "https://api.spotify.com/v1/search?q=\(keywords)&type=track"
        
        //calling the URL to get the songs through Alamo
        callAlamo(url: searchURL)
        
        //push the keyboard down when you press the search button
        self.view.endEditing(true)
        
    }
    
    /*
     *  Below is for the "Advanced" version of tutorial
     *
     */
    
    //This func tells the table view how many rows it needs to have
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //we will have as many rows as we have songs
        return songs.count
    }
    
    //This func prepares each table view cell before it loads/reloads
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //get our custom cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongCell") as! SongCell
        
        //set the cell's album cover image to our song image
        cell.albumImageView.image = songs[indexPath.row].mainImage
        
        //set the cell's title to our song name
        cell.songTitleLabel.text = songs[indexPath.row].songName
        
        //set the cell's song URL to our song URL, so that we can play the song
        cell.songURL = URL(string: songs[indexPath.row].previewURL)
        
        //return our custom cell to the table view so it can be displayed
        return cell
    }
    
    /*
     *  Don't change the code below, or your app won't work!
     *
     */
    
    func callAlamo(url: String) {
        Alamofire.request(url).responseJSON(completionHandler: { response in
            self.parseData(JSONData: response.data!)
        })
    }
    
    func parseData(JSONData: Data) {
        typealias JSONObject = [String: Any]
        do {
            var readableJSON = try JSONSerialization.jsonObject(with: JSONData, options: .mutableContainers) as! JSONObject
            print(readableJSON)
            if let tracks = readableJSON["tracks"] as? JSONObject {
                if let items = tracks["items"] as? [JSONObject] {
                    for item in items {
                        let songName = item["name"] as! String
                        
                        let previewURL = item["preview_url"] as! String
                        
                        if let album = item["album"] as? JSONObject {
                            if let images = album["images"] as? [JSONObject] {
                                
                                let imageData = images[0]
                                
                                let mainImageURL = URL(string: imageData["url"] as! String)
                                do {
                                    let mainImageData = try Data(contentsOf: mainImageURL!)
                                    let image = UIImage(data: mainImageData)
                                    
                                    songs.append(SongItem.init(mainImage: image, songName: songName, previewURL: previewURL))
                                    self.tableView.reloadData()
                                    
                                } catch {
                                    print(error)
                                }
                                
                            }
                        }
                        
                    }
                }
            }
        } catch {
            print(error)
        }
    }


}

