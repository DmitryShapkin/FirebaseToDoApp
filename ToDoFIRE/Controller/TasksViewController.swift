//
//  TasksViewController.swift
//  ToDoFIRE
//
//  Created by Dmitry Shapkin on 14/12/2019.
//  Copyright © 2019 ShapkinDev. All rights reserved.
//


import UIKit
import Firebase

final class TasksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var user: AppUser!
    var ref: DatabaseReference!
    var tasks = Array<Task>()
    
    /// TableView с тасками
    let tasksTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupNavigationBar()
        setupTableView()
        
        guard let currentUser = Auth.auth().currentUser else { return }
        user = AppUser(user: currentUser)
        ref = Database.database().reference(withPath: "users").child(String(user.uid)).child("tasks")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ref.observe(.value) { [weak self] (snapshot) in
            
            guard let self = self else { return }
            
            var tempTasks = Array<Task>()
            
            for item in snapshot.children {
                let task = Task(snapshot: item as! DataSnapshot)
                tempTasks.append(task)
            }
            
            self.tasks = tempTasks
            self.tasksTableView.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ref.removeAllObservers()
    }
}

private extension TasksViewController {
    func setupLayout() {
        self.view.backgroundColor = .lightGray
        tasksTableView.backgroundColor = .red
        
        self.view.addSubview(tasksTableView)
        
        NSLayoutConstraint.activate([
            tasksTableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            tasksTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tasksTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tasksTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    func setupNavigationBar() {
        navigationItem.title = "Tasks"
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sign Out",
                                                                style: UIBarButtonItem.Style.plain,
                                                                target: self,
                                                                action: #selector(signOutTapped(sender:)))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                                 target: self,
                                                                 action: #selector(addTapped(sender:)))
        
        self.navigationController?.navigationBar.layer.masksToBounds = false
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
        self.navigationController?.navigationBar.layer.shadowOpacity = 0.4
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 2
    }
    
    func setupTableView() {
        tasksTableView.register(CustomCell.self, forCellReuseIdentifier: "custom")
        tasksTableView.rowHeight = UITableView.automaticDimension
        tasksTableView.estimatedRowHeight = 200
//        tasksTableView.allowsSelection = false
        tasksTableView.separatorStyle = .singleLine
        tasksTableView.isUserInteractionEnabled = true
        
        tasksTableView.dataSource = self
        tasksTableView.delegate = self
    }
    
    @objc
    private func addTapped(sender: UIButton) {
        print("addTapped")
        let alertController = UIAlertController(title: "New Task", message: "Add new task", preferredStyle: .alert)
        alertController.addTextField()
        let save = UIAlertAction(title: "Save", style: .default) { [weak self] _ in
            guard let self = self else { return }
            guard let alertTextField = alertController.textFields?.first, alertTextField.text != "" else { return }
            let task = Task(title: alertTextField.text!, userId: self.user.uid)
            let taskRef = self.ref.child(task.title.lowercased())
            taskRef.setValue(task.convertToDictionary())
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(save)
        alertController.addAction(cancel)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @objc
    private func signOutTapped(sender: UIButton) {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error.localizedDescription)
        }
        self.navigationController?.popViewController(animated: true)
    }
}


// MARK: - Делегат и Датасорс тэйблвью

extension TasksViewController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tasksTableView.dequeueReusableCell(withIdentifier: "custom") as! CustomCell
        let task = tasks[indexPath.row]
        let taskTitle = task.title
        let isCompleted = task.completed
        cell.labelView.text = taskTitle
        
        toggleCompletion(cell, isCompleted: isCompleted)
        
        return cell
    }
}


// MARK: - Расширение на тэйблвью для удаления и редактирования

extension TasksViewController {
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = tasks[indexPath.row]
            task.ref?.removeValue()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        let task = tasks[indexPath.row]
        let isCompleted = !task.completed
        
        toggleCompletion(cell, isCompleted: isCompleted)
        
        // Запишем изменение в Базу Данных
        task.ref?.updateChildValues(["completed": isCompleted])
    }
    
    func toggleCompletion(_ cell: UITableViewCell, isCompleted: Bool) {
        cell.accessoryType = isCompleted ? .checkmark : .none
    }
}
