//
//  ViewController.swift
//  Reproductor
//
//  Created by Ivan Duran Martinez on 13/4/16.
//  Copyright © 2016 Ivan Duran Martinez. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var songTittle: UILabel!
    @IBOutlet weak var albumCover: UIImageView!
    @IBOutlet weak var songsTableView: UITableView!
    @IBOutlet weak var Volume: UILabel!
    
    weak var dataSource: UITableViewDataSource?
    weak var delegate: UITableViewDelegate?
    
    var songList = ["Rumor Has It", "Rent A Cop", "Sober In June", "If I Had Eyes", "Mister Sandman"]
    var imageList = ["21.jpg", "Supersunnyspeedgraphic.jpg", "Voff Voff.jpg", "Sleep Through The Static.jpg", "tribute to famous people.jpg"]
    
    var selectedSong = false
    var currentVolume:Float = 1.0

    private var reproductor : AVAudioPlayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        songsTableView.delegate = self
        songsTableView.dataSource = self
        
        updateVolumeValue()
        
        nuevaCancion(0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func nuevaCancion(index:Int) -> Bool {
        let song = NSBundle.mainBundle().URLForResource(songList[index], withExtension: "mp3")
        do {
            try reproductor = AVAudioPlayer(contentsOfURL: song!)
        }catch{
            return false
        }
        albumCover.image = UIImage(named: imageList[index])
        songTittle.text = songList[index]
        return true
    }

    @IBAction func play() {
        if !reproductor.playing {
            reproductor.play()
        }
    }
    
    @IBAction func pause() {
        if reproductor.playing{
            reproductor.pause()
        }
    }
    
    @IBAction func stop() {
        if reproductor.playing{
            reproductor.stop()
            reproductor.currentTime = 0.0
        }
    }
    
    @IBAction func random() {
        let songIndex = Int(arc4random_uniform(UInt32(songList.count)))
        if nuevaCancion(songIndex){
            let tableIP = NSIndexPath(forRow: songIndex, inSection: 0)
            songsTableView.selectRowAtIndexPath(tableIP, animated: true, scrollPosition: .None)
        }
        reproductor.play()
    }
    
    @IBAction func lessVolume() {
        if currentVolume > 0.0 {
            currentVolume -= 0.1
            reproductor.volume = currentVolume
            updateVolumeValue()
        }
    }
    
    @IBAction func moreVolume() {
        if currentVolume < 1.0 {
            currentVolume += 0.1
            reproductor.volume = currentVolume
            updateVolumeValue()
        }
    }
    
    func updateVolumeValue() {
        Volume.text = "Volumen \(Int(currentVolume * 10.0))"
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songList.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        nuevaCancion(indexPath.row)
        reproductor.play()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "stdCell")
        cell.textLabel?.text = songList[indexPath.row]
        return cell
    }
    
    
}

