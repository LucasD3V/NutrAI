//
//  ViewController.swift
//  NutrAI
//
//  Created by Vinicius Mangueira on 02/07/19.
//  Copyright © 2019 Vinicius Mangueira. All rights reserved.
//

import UIKit

class MealsListController: UITableViewController {
    
    let schedules = [Schedule(name: "BreakFast", imageNamed: "breakfast"), Schedule(name: "Lunch", imageNamed: "lunch"), Schedule(name: "Dinner", imageNamed: "dinner")]
    
    var meals: [Meal]?
    
    fileprivate let coreStack = CoreDao<Meal>(with: "NutriAI-Data")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addMealButtonClicked))
        setupTableView()
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        meals = coreStack.fetchAll()
        tableView.reloadData()
    }
    
}

extension MealsListController {
    @objc func addMealButtonClicked(_ sender: Any) {
        let mealIdentifierVC = MealIdentifierController()
        present(mealIdentifierVC, animated: true)
    }
}

extension MealsListController {
    fileprivate func setupTableView() {
        tableView.tableFooterView = UIView()
        tableView.register(cellType: MealsListCell.self)
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = MealsListHeader()
        header.schedule = schedules[section]
        return header
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return meals?.filter { $0.schedule == ScheduleInfo.ScheduleType.breakfast.rawValue }.count ?? 0
        case 1:
            return meals?.filter { $0.schedule == ScheduleInfo.ScheduleType.lunch.rawValue }.count ?? 0
        case 2:
            return meals?.filter { $0.schedule == ScheduleInfo.ScheduleType.dinner.rawValue }.count ?? 0
        default:
            return 0
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return schedules.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: MealsListCell.self)
        meals = coreStack.fetchAll()
        
        guard let curMeal = meals?[indexPath.row],
            let schedule = curMeal.schedule else {
            print("Could not get current meal")
            return UITableViewCell()
        }
        let scheduleType = ScheduleInfo.getSchedule(schedule)
        
        switch section {
        case 0:
            if scheduleType == .breakfast {
                cell.setupCell(meal: curMeal)
            }
        case 1:
            if scheduleType == .lunch {
                cell.setupCell(meal: curMeal)
            }
        case 2:
            if scheduleType == .dinner {
                cell.setupCell(meal: curMeal)
            }
        default:
            cell.setupCell(meal: curMeal)
            print("Could not identify schedule type")
        }
        
        return cell
    }
}
