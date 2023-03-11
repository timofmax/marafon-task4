//
//  ViewController.swift
//  marafon-task4
//
//  Created by Timofey Privalov on 10.03.2023.
//

import UIKit

final class ViewController: UIViewController {
    
    // MARK: - Private properties
    
    private var tableView: UITableView = {
        let table = UITableView(frame: .init(x: 0, y: 0,
                                             width: UIScreen.main.bounds.width,
                                             height: UIScreen.main.bounds.height), style: .insetGrouped)
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    private var viewContainer: UIView!
    private var shuffleButton: UIBarButtonItem!
    private var dataSource: UITableViewDiffableDataSource<Section, CellNumber>!
    private var numbers = [CellNumber]()
    
    // MARK: - Lifecycle
    
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
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    // MARK: - @objc method
    
    @objc private
    func shuffleRows() {
        let currentSnapshot = self.dataSource.snapshot()
        let mixedNumbers = currentSnapshot.itemIdentifiers.shuffled()
        var snapshot = NSDiffableDataSourceSnapshot<Section, CellNumber>()
        snapshot.appendSections([.first])
        snapshot.appendItems(mixedNumbers)
        self.dataSource.apply(snapshot, animatingDifferences: true, completion: nil)
    }

    // MARK: - Private methods
    
    private func setupDelegates() {
        tableView.delegate = self
    }
    
    private func setNavigation() {
        shuffleButton = UIBarButtonItem(title: "ShakeIT", style: .plain, target: self, action: #selector(shuffleRows))
        navigationItem.rightBarButtonItems = [shuffleButton]
        navigationItem.title = "TASK 4"
    }
    
    private func updateDataSource() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, CellNumber>()
        snapshot.appendSections([.first])
        createDict()
        snapshot.appendItems(numbers)
        dataSource.apply(snapshot, animatingDifferences: true, completion: nil)
    }
    
    private func createDict() {
        for number in Array(1...30) {
            numbers.append(CellNumber(number: number))
        }
    }
    
    private enum Section {
        case first
    }
    
    private struct CellNumber: Hashable {
        let number: Int
    }
}


extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedtCell = tableView.cellForRow(at: indexPath)
        selectedtCell?.selectionStyle = .none
        switch selectedtCell?.accessoryType == .checkmark {
        case true:
            selectedtCell?.accessoryType = .none
        case false:
            guard let selectedCellNumber = dataSource.itemIdentifier(for: indexPath) else { return }
            var snapshot = dataSource.snapshot()
            snapshot.deleteItems([selectedCellNumber])
            let newIndexPath = IndexPath(row: 0, section: 0)
            snapshot.insertItems([selectedCellNumber],
                                 beforeItem: snapshot.itemIdentifiers[newIndexPath.row])
            dataSource.apply(snapshot, animatingDifferences: true)
            tableView.cellForRow(at: IndexPath(row: 0, section: 0))?.accessoryType = .checkmark
            tableView.selectRow(at: newIndexPath, animated: true, scrollPosition: .top)
        }
    }
}
