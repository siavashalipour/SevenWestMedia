//
//  ViewController.swift
//  SevenWestMedia
//
//  Created by siavash abbasalipour on 30/6/17.
//  Copyright © 2017 Siavash. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxSwiftUtilities

class ViewController: UIViewController {
    
    @IBOutlet weak var channelTableView: UITableView!
    fileprivate var channels: [ChannelModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        bindUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    private func bindUI() {
        let client = RequestClient.init(withPath: "https://s3-ap-southeast-2.amazonaws.com/swm-ftp-s3/ios/channel_list.json", requestType: .get)
        let vm = ChannelsViewModel.init(with: client)
        let _ = vm.getChannels().subscribe { (event) in
            if let channels = event.element {
                DispatchQueue.main.async {
                    self.setupTableViewWith(channels: channels)
                }
            }
        }
        
    }
    private func setupTableViewWith(channels: [ChannelModel]) {
        self.channels = channels
        channelTableView.dataSource = self
        channelTableView.delegate = self
        channelTableView.reloadData()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier ==  MainStoryboardSegue.showDetail {
            if sender is ChannelModel {
                let selectedChannel = sender as! ChannelModel
                if let vc = segue.destination as? ProgramViewController {
                    vc.selectedChannel = selectedChannel
                }
            }
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        if let aCell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifier.channelCell) {
            cell = aCell
        } else {
            cell = UITableViewCell()
        }
        cell.textLabel?.text = channels[indexPath.row].name
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channels.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: MainStoryboardSegue.showDetail, sender: channels[indexPath.row])
    }
}

