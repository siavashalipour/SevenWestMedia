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
   
    // MARK:- View Outlets
    @IBOutlet weak var programTableView: UITableView!

    // MARK:- Public properties
    var selectedChannel: ChannelModel?
    
    // MARK:- Private properties
    fileprivate var programs: [ProgramModel] = []
    
    // MARK:- View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bindUI()
        
    }
    // MARK:- Private Helper
    
    /// instantiate the ViewModel for this view controller and binds the ViewModel data to the TableView for presenting
    private func bindUI() {
        if let selectedChannel = selectedChannel {
            title = "Channel \(selectedChannel.id)"
            let client = RequestClient.init(withPath: "\(APIPath.base)/channel_programs_\(selectedChannel.id).json", requestType: .get)
            let vm = ProgramViewModel.init(with: client)
            let _ = vm.getPrograms().subscribe(onNext: { (models) in
                    DispatchQueue.main.async {
                        self.setupTableViewWith(programs: models)
                    }
            }, onError: { (error) in
                DispatchQueue.main.async {
                    self.showOneButtonAlertViewWith(error: error, actionTitle: "OK")
                }
            })
        }
    }
    /// setups tableView datasource and delegate after the ViewModel has finished
    ///
    /// - Parameter channels: fetched Program models
    private func setupTableViewWith(programs: [ProgramModel]) {
        self.programs = programs
        programTableView.dataSource = self
        programTableView.reloadData()
    }
}

// MARK:- UITableViewDataSource,
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

// MARK:- ProgramTableViewCell
class ProgramTableViewCell: UITableViewCell {
    
    // MARK:- View Outlets
    @IBOutlet weak var programLabel: UILabel!
    @IBOutlet weak var programImageView: UIImageView!
    
    // MARK:- Public helper
    
    /// simply setups the UI for the cell based on the passed model
    ///
    /// - Parameter program: program model to be rendered
    func config(with program: ProgramModel) {
        programLabel.text = program.title + "\n\(program.startTime)"
        programImageView.sd_setImage(with: URL.init(string: program.imageURL))
    }
}
