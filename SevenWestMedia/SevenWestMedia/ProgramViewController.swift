//
//  ProgramViewController.swift
//  SevenWestMedia
//
//  Created by siavash abbasalipour on 30/6/17.
//  Copyright © 2017 Siavash. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class ProgramViewController: UIViewController {
    
    var selectedChannel: ChannelModel?
    fileprivate var programs: [ProgramModel] = []
    @IBOutlet weak var programTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindUI()
        
    }
    private func bindUI() {
        if let selectedChannel = selectedChannel {
            title = "Channel \(selectedChannel.id)"
            let client = RequestClient.init(withPath: "https://s3-ap-southeast-2.amazonaws.com/swm-ftp-s3/ios/channel_programs_\(selectedChannel.id).json", requestType: .get)
            let vm = ProgramViewModel.init(with: client)
            let _ = vm.getPrograms().subscribe { (event) in
                if let programms = event.element {
                    DispatchQueue.main.async {
                        self.setupTableViewWith(programs: programms)
                    }
                }
            }
        }

        
    }
    private func setupTableViewWith(programs: [ProgramModel]) {
        self.programs = programs
        programTableView.dataSource = self
        programTableView.reloadData()
    }
}


extension ProgramViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ProgramTableViewCell
        if let aCell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifier.programCell) as? ProgramTableViewCell {
            cell = aCell
        } else {
            cell = ProgramTableViewCell()
        }
        cell.config(with: programs[indexPath.row])
        
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return programs.count
    }
    
}

class ProgramTableViewCell: UITableViewCell {
    
    @IBOutlet weak var programLabel: UILabel!
    @IBOutlet weak var programImageView: UIImageView!
    
    func config(with program: ProgramModel) {
        programLabel.text = program.title + "\n\(program.startTime)"
        programImageView.sd_setImage(with: URL.init(string: program.imageURL))
    }
}
