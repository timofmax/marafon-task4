//
//  ViewController.swift
//  marafon-task4
//
//  Created by Timofey Privalov on 10.03.2023.
//

import UIKit

final class ViewController: UIViewController {
    var tableView: UITableView = {
        let table = UITableView(frame: .init(x: 0, y: 0,
                                             width: UIScreen.main.bounds.width,
                                             height: UIScreen.main.bounds.height), style: .insetGrouped)
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    var viewContainer: UIView!
    var shuffleButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.clipsToBounds = true
//        tableView.layer.cornerRadius = 30
        view.addSubview(tableView)
//        tableView.layer.cornerRadius = 8
//        tableView.layer.masksToBounds = true
//        tableView.frame = .init(x: 0, y: 0,
//                                width: view.bounds.width - view.layoutMargins.left * 2,
//                                height: view.bounds.height)
//
        shuffleButton = UIBarButtonItem(title: "ShakeIT", style: .plain, target: self, action: #selector(shuffleRows))
        navigationItem.rightBarButtonItems = [shuffleButton]
        navigationItem.title = "TASK 4"
        setupDelegates()
    }
    
    @objc
    func shuffleRows() {
        // Get all the rows in the table view
        let rows = (0..<tableView.numberOfRows(inSection: 0)).map { IndexPath(row: $0, section: 0) }
        // Shuffle the rows
        let shuffledRows = rows.shuffled()
        // Keep track of the current textLabel.text for each cell
        var cellTexts = [String]()
        for row in rows {
            guard let cell = tableView.cellForRow(at: row) else {
                print("🌝🌝🌝")
                continue
            }
            cellTexts.append(cell.textLabel?.text ?? "")
        }
        // Perform the shuffling animation
        tableView.beginUpdates()
        for (oldRow, newRow) in zip(rows, shuffledRows) {
            tableView.moveRow(at: oldRow, to: newRow)
        }
        // Update the textLabel.text for each cell at its new position
        for (row, text) in zip(rows, cellTexts) {
            guard let cell = tableView.cellForRow(at: row) else { continue }
            cell.textLabel?.text = text
        }
        tableView.endUpdates()
    }

    private func setupDelegates() {
        tableView.dataSource = self
        tableView.delegate = self
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func createDict() {
        for (position, element) in Array(1...30).enumerated() {
            print(position)
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.frame = .init(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height/30)
        cell.textLabel?.text = "\(indexPath.row + 1)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        cell.accessoryType = .checkmark
        tableView.beginUpdates()
        tableView.moveRow(at: indexPath, to: IndexPath(row: 0, section: 0))
        tableView.endUpdates()
    }
}
