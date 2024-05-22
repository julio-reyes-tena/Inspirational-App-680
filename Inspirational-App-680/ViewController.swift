//
//  ViewController.swift
//  680 final project
//
// existing code used/ api's
//      -quotes:: "https://api.quotable.io/random"

//      -pictures::"https://source.unsplash.com/random/600x600"

//      -songs::"https://api.deezer.com/chart"


import UIKit
import AVFoundation

import UIKit
import AVFoundation

class ViewController: UIViewController {

    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let quoteLabel: UILabel = {
        let label = UILabel()
        label.text = "Press for a random quote"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let quoteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("New Inspirational Quote", for: .normal)
        button.addTarget(self, action: #selector(fetchRandomQuote), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    

    
    let photoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("New Inspirational Photo", for: .normal)
        button.addTarget(self, action: #selector(getRandomPhoto), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    

    
    let songButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Find a new song", for: .normal)
        button.addTarget(self, action: #selector(fetchAndPlayRandomSong), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let songTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "No song playing"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var player: AVPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.lightGray

        // Adding existing and new UI elements to the view
        view.addSubview(imageView)
        view.addSubview(quoteLabel)
        view.addSubview(quoteButton)
        view.addSubview(photoButton)
        view.addSubview(songButton)
        view.addSubview(songTitleLabel)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            // Constraints for existing imageView
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -150),
            imageView.widthAnchor.constraint(equalToConstant: 200),
            imageView.heightAnchor.constraint(equalToConstant: 200),
            
            // Constraints for the new quoteLabel
            quoteLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            quoteLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            quoteLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            quoteLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Constraints for the new quoteButton
            quoteButton.topAnchor.constraint(equalTo: quoteLabel.bottomAnchor, constant: 20),
            quoteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // Constraints for the photoButton
            photoButton.topAnchor.constraint(equalTo: quoteButton.bottomAnchor, constant: 20),
            photoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // Constraints for the songButton
            songButton.topAnchor.constraint(equalTo: photoButton.bottomAnchor, constant: 20),
            songButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // Constraints for the songTitleLabel
            songTitleLabel.topAnchor.constraint(equalTo: songButton.bottomAnchor, constant: 10),
            songTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            songTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            songTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    @objc func fetchRandomQuote() {
        let urlString = "https://api.quotable.io/random"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        if let content = json["content"] as? String {
                            DispatchQueue.main.async {
                                self.quoteLabel.text = content
                            }
                        }
                    }
                } catch {
                    print("Error parsing JSON: \(error)")
                }
            }
        }.resume()
    }
    
    @objc func getRandomPhoto() {
        let urlString = "https://source.unsplash.com/random/600x600"
        let url = URL(string: urlString)!
        guard let data = try? Data(contentsOf: url) else {
            return
        }
        DispatchQueue.main.async {
            self.imageView.image = UIImage(data: data)
        }
    }
    
    @objc func fetchAndPlayRandomSong() {
        let urlString = "https://api.deezer.com/chart"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let tracks = json["tracks"] as? [String: Any],
                       let data = tracks["data"] as? [[String: Any]],
                       let randomTrack = data.randomElement(),
                       let preview = randomTrack["preview"] as? String,
                       let title = randomTrack["title"] as? String {
                        DispatchQueue.main.async {
                            self.songTitleLabel.text = title
                        }
                        self.playSong(from: preview)
                    }
                } catch {
                    print("Error parsing JSON: \(error)")
                }
            }
        }.resume()
    }
    
    func playSong(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let playerItem = AVPlayerItem(url: url)
        self.player = AVPlayer(playerItem: playerItem)
        self.player?.play()
    }
}
