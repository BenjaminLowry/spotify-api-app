//
//  SongCell.swift
//  
//
//  Created by Ben LOWRY on 1/28/17.
//
//

import UIKit
import AVFoundation

var player: AVAudioPlayer!

class SongCell: UITableViewCell {

    //our song title outlet
    @IBOutlet weak var songTitleLabel: UILabel!
    
    //our album image outlet
    @IBOutlet weak var albumImageView: UIImageView!
    
    //our play/stop button outlet
    @IBOutlet weak var playStopButton: UIButton!
    
    //our song URL
    var songURL: URL!
    
    //our bool to check if the song is playing
    var isPlaying: Bool = false
    
    @IBAction func buttonPressed(_ sender: UIButton) {
    
        if let audioPlayer = player { //if a song is playing
            
            if isPlaying { //if it is the song from the current cell
                
                //stop the song
                audioPlayer.stop()
                
                //remove the song from our player
                player = nil
                
                //change our button to the "play" image
                playStopButton.setBackgroundImage(#imageLiteral(resourceName: "rsz_1play_button"), for: .normal)
                
                //change our bool to "false" because our cell's song is not playing
                isPlaying = false
                
            }
            
        } else { //if a song is not playing
            
            //start our song!
            downloadFileFromURL(url: songURL)
            
            //set the button image to the "stop" image
            playStopButton.setBackgroundImage(#imageLiteral(resourceName: "rsz_stop"), for: .normal)
            
            //our song is playing, so set the bool to "true"
            isPlaying = true
            
        }
        
    }
    
    /*
     *  Don't touch the code below!
     *
     */
    
    func downloadFileFromURL(url: URL) {
        
        var downloadTask = URLSessionDownloadTask()
        downloadTask = URLSession.shared.downloadTask(with: url, completionHandler: {
            customURL, response, error in
            self.play(url: customURL!)
        })
        
        downloadTask.resume()
        
    }
    
    func play(url: URL) {
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player.prepareToPlay()
            player.play()
        } catch {
            print(error)
        }
        
    }

}
