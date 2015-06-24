//
//  PlaylistDetailViewController.swift
//  Algorythm
//
//  Created by Taha Abbasi on 5/30/15.
//  Copyright (c) 2015 TahaAbbasi. All rights reserved.
//

import UIKit

class PlaylistDetailViewController: UIViewController {


    var playlist: Playlist?
    
    @IBOutlet weak var playlistCoverImage: UIImageView!
    @IBOutlet weak var playlistTitle: UILabel!
    @IBOutlet weak var playlistDescription: UILabel!
    
    
    @IBOutlet weak var playlistArtist0: UILabel!
    @IBOutlet weak var playlistArtist1: UILabel!
    @IBOutlet weak var playlistArtist2: UILabel!
    @IBOutlet weak var playlistArtist3: UILabel!
    @IBOutlet weak var playlistArtist4: UILabel!
    @IBOutlet weak var playlistArtist5: UILabel!
    @IBOutlet weak var playlistArtist6: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if playlist != nil {
            
            
            playlistCoverImage.image = playlist!.largeIcon
            playlistCoverImage.backgroundColor = playlist!.backgroundColor
            playlistTitle.text = playlist!.title
            playlistDescription.text = playlist!.description
            
            
            playlistArtist0.text = playlist!.artists[0]
            playlistArtist1.text = playlist!.artists[1]
            playlistArtist2.text = playlist!.artists[2]
            playlistArtist3.text = playlist!.artists[3]
            playlistArtist4.text = playlist!.artists[4]
            playlistArtist5.text = playlist!.artists[5]
            playlistArtist6.text = playlist!.artists[6]
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
