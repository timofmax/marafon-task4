//
//  ViewController.swift
//  marafon-task4
//
//  Created by Timofey Privalov on 10.03.2023.
//

/*
 Connect a diffable data source to your table view.
 Implement a cell provider to configure your table view’s cells.
 Generate the current state of the data.
 Display the data in the UI.
 */

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
    var dataSource: UITableViewDiffableDataSource<Section, CellNumber>!
    var numbers = [CellNumber]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = UITableViewDiffableDataSource(tableView: tableView,
                                                   cellProvider: { tableView, indexPath, model in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = String(model.number)
            return cell
        })
        updateDataSource()
        setNavigation()
        view.addSubview(tableView)
        setupDelegates()
    }
    
    @objc
    func shuffleRows() {
        let currentSnapshot = self.dataSource.snapshot()
        let mixedNumbers = currentSnapshot.itemIdentifiers.shuffled()
        var snapshot = NSDiffableDataSourceSnapshot<Section, CellNumber>()
        snapshot.appendSections([.first])
        snapshot.appendItems(mixedNumbers)
        self.dataSource.apply(snapshot, animatingDifferences: true, completion: nil)
    }

    private func setupDelegates() {
        tableView.delegate = self
    }
    
    private func setNavigation() {
        shuffleButton = UIBarButtonItem(title: "ShakeIT", style: .plain, target: self, action: #selector(shuffleRows))
        navigationItem.rightBarButtonItems = [shuffleButton]
        navigationItem.title = "TASK 4"
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func updateDataSource() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, CellNumber>()
        snapshot.appendSections([.first])
        createDict()
        snapshot.appendItems(numbers)
        dataSource.apply(snapshot, animatingDifferences: true, completion: nil)
    }
    
    func createDict() {
        for number in Array(1...30) {
            numbers.append(CellNumber(number: number))
        }
    }
    
    enum Section {
        case first
    }
    
    struct CellNumber: Hashable {
        let number: Int
    }
}


extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedCellNumber = dataSource.itemIdentifier(for: indexPath) else { return }
        var snapshot = dataSource.snapshot()
        // Remove the selected entry from its current position
        snapshot.deleteItems([selectedCellNumber])
        // Insert the selected entry at the top of the array
        let newIndexPath = IndexPath(row: 0, section: 0)
        snapshot.insertItems([selectedCellNumber], beforeItem: snapshot.itemIdentifiers[newIndexPath.row])

        // Apply the modified snapshot
        dataSource.apply(snapshot, animatingDifferences: true)
        tableView.cellForRow(at: IndexPath(row: 0, section: 0))?.accessoryType = .checkmark
        // Select the inserted item
        tableView.selectRow(at: newIndexPath, animated: true, scrollPosition: .top)
    }
}
