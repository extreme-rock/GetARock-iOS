//
//  LandingViewController.swift
//  GetARock
//
//  Created by Mijoo Kim on 2023/01/18.
//

import SafariServices
import UIKit

class LandingViewController: UIViewController {
    
    let songList: [SongListVO] = [
        SongListVO(songID: 0, name: "Don't Look Back in Anger", artist: "Oasis", link: nil),
        SongListVO(songID: 0, name: "Ai Wo Tsutaetaidatoka", artist: "Aimyong", link: "https://www.youtube.com/watch?v=ARwVe1MYAUA"),
        SongListVO(songID: 0, name: "Kick Back", artist: "Kenshi Yonezu", link: "https://www.youtube.com/watch?v=M2cckDmNLMI"),
    ]
    
    private lazy var songListView = SongListView(songListType: .detail,
                                            songList: self.songList)
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(songListView)
        songListView.delegate = self
        songListView.constraint(top: view.topAnchor,
                                leading: view.leadingAnchor,
                                trailing: view.trailingAnchor,
                                padding: UIEdgeInsets(top: 100, left: 0, bottom: 0, right: 0))
        songListView.constraint(.heightAnchor, constant: 300)
    }
}

extension LandingViewController: SongListViewDelegate {
    func presentSongLink(with link: String) {
        guard let url = URL(string: link) else { return }
        let vc = SFSafariViewController(url: url)
        self.present(vc, animated: true)
    }
    

}
