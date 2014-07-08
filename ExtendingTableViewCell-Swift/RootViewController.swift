//
//  RootViewController.swift
//  ExtendingTableViewCell-Swift
//
//  Created by Kevin Chen on 7/8/14.
//  Copyright (c) 2014 KnightLord Universe Technolegies Ltd. All rights reserved.
//

import UIKit



class RootViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var tableDatas :[Dictionary<String, AnyObject>]?
    var dateFormatter :NSDateFormatter?
    var selectedIndexPath :NSIndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        tableDatas = [
            ["title" : "Birthday", "type":"datepicker"],
            ["title" : "Gender", "type" : "picker", "value" : "Male"],
            ["title" : "Wake Up", "type" : "datepicker", "value" : NSDate()],
            ["title" : "Address", "type" : "normal", "value" : "1 Infinite Loop Cupertino, CA 95014"],
            ["title" : "Telephone", "type" : "normal", "value" : "1(408)-996-1010"]
        ]
        
        dateFormatter = NSDateFormatter();
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // #pragma mark - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        var numberOfRows = tableDatas!.count

        if hasInlineTableViewCell() {
            numberOfRows += 1
        }
        return numberOfRows
    }

    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell? {
        
        var dataRow = indexPath.row
        
        if selectedIndexPath && selectedIndexPath!.section == indexPath.section && selectedIndexPath!.row == indexPath.row - 1 {
            dataRow -= 1;
        }
        
        // Configure the cell...
        var rowData = tableDatas![dataRow]
        let title = rowData["title"]! as String
        let type = rowData["type"]! as String
        if selectedIndexPath && selectedIndexPath!.section == indexPath.section && selectedIndexPath!.row == indexPath.row - 1 {
            
            if type == "picker" {
                
                let pickerViewCell = tableView.dequeueReusableCellWithIdentifier("PickerViewCell", forIndexPath: indexPath) as PickerViewCell
                pickerViewCell.pickerView.delegate = self
                pickerViewCell.pickerView.dataSource = self;
                
                if let gender :AnyObject = rowData["value"] {
                    pickerViewCell.pickerView.selectRow((gender as String == "Male") ? 0 : 1, inComponent: 0, animated: true)
                }
                
                return pickerViewCell

                
            } else if type == "datepicker" {
                let datePickerCell = tableView.dequeueReusableCellWithIdentifier("DatePickerCell", forIndexPath: indexPath) as DatePickerCell
                
                datePickerCell.datePicker.addTarget(self, action:"handleDatePickerValueChanged:", forControlEvents: UIControlEvents.ValueChanged)

                if title == "Birthday" {
                    datePickerCell.datePicker.datePickerMode = .Date
                } else if title == "Wake Up" {
                    datePickerCell.datePicker.datePickerMode = .Time
                }
                
                if let date :AnyObject = rowData["value"] {
                    datePickerCell.datePicker.setDate(date as NSDate, animated: true)
                }
                
                return datePickerCell
                
            }
            
            
        }
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("NormalCell", forIndexPath: indexPath) as UITableViewCell
       
        
        cell.textLabel.text = title
        if let valueOfRow: AnyObject = rowData["value"] {
            if title == "Birthday" {
                dateFormatter!.dateStyle = .ShortStyle
                dateFormatter!.dateFormat = nil;
                cell.detailTextLabel.text = dateFormatter!.stringFromDate(valueOfRow as NSDate)
            } else if title == "Wake Up" {
                dateFormatter!.dateStyle = .NoStyle
                dateFormatter!.dateFormat = "hh:mm a"
                cell.detailTextLabel.text = dateFormatter!.stringFromDate(valueOfRow as NSDate)
            } else {
                cell.detailTextLabel.text = valueOfRow as String
            }
        } else {
            cell.detailTextLabel.text = "Any"
        }
        

        return cell
    }
    
    override func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        var heightForRow :CGFloat = 44.0
        if selectedIndexPath
            && selectedIndexPath!.section == indexPath.section
            && selectedIndexPath!.row == indexPath.row - 1 {
            heightForRow = 216.0
        }
        
        return heightForRow
    }

    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        
        var dataRow = indexPath.row
        if selectedIndexPath && selectedIndexPath!.section == indexPath.section && selectedIndexPath!.row < indexPath.row {
            dataRow -= 1
        }
        
        var rowData = tableDatas![dataRow]
        var type = rowData["type"]! as String
        if type != "normal" {
            displayOrHideInlinePickerViewForIndexPath(indexPath);
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func displayOrHideInlinePickerViewForIndexPath(indexPath: NSIndexPath!) {
        tableView.beginUpdates()
        
        if selectedIndexPath == nil {
            
            selectedIndexPath = indexPath
            tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: indexPath.row + 1, inSection: indexPath.section)], withRowAnimation: .Fade)
            
        } else if selectedIndexPath!.section == indexPath.section && selectedIndexPath!.row == indexPath.row {
            
            tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: indexPath.row + 1, inSection: indexPath.section)], withRowAnimation: .Fade)
            selectedIndexPath = nil
            
        } else if selectedIndexPath!.section != indexPath.section || selectedIndexPath!.row != indexPath.row {
            
            tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: selectedIndexPath!.row + 1, inSection: selectedIndexPath!.section)], withRowAnimation: .Fade)
            
            // After the deletion operation the then indexPath of original table view changed to the resulting table view
            if (selectedIndexPath!.section == indexPath.section && selectedIndexPath!.row < indexPath.row) {
                
                tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: indexPath.row, inSection: indexPath.section)], withRowAnimation: .Fade)
                selectedIndexPath = NSIndexPath(forRow: indexPath.row - 1, inSection: indexPath.section)
                
            } else {
                
                tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: indexPath.row + 1, inSection: indexPath.section)], withRowAnimation: .Fade)
                selectedIndexPath = indexPath
            }
        }
        
        tableView.endUpdates()
    }
    
    func hasInlineTableViewCell() -> Bool {
        return !(self.selectedIndexPath == nil)
    }
    
    // MARK: UIPickerDelegate
    func numberOfComponentsInPickerView(pickerView: UIPickerView!) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView!, numberOfRowsInComponent component: Int) -> Int {
        return 2;
    }
    
    func pickerView(pickerView: UIPickerView!, titleForRow row: Int, forComponent component: Int) -> String! {
        if (row == 0) {
            return "Male"
        } else {
            return "Female"
        }
    }
    
    func pickerView(pickerView: UIPickerView!, didSelectRow row: Int, inComponent component: Int) {
        
        var index = selectedIndexPath!.row
        var rowData = tableDatas![index]
        rowData["value"] = (row == 0) ? "Male" : "Female";
        
        if var tmpArray = tableDatas {
            tmpArray[index] = rowData
            tableDatas = tmpArray
        }

        
        tableView.reloadRowsAtIndexPaths([selectedIndexPath!], withRowAnimation: .Fade)
    }
    
    func handleDatePickerValueChanged(datePicker: UIDatePicker!) {
        var index = selectedIndexPath!.row
        var rowData = tableDatas![index]
        rowData["value"] = datePicker.date
        
        if var tmpArray = tableDatas {
            tmpArray[index] = rowData
            tableDatas = tmpArray
        }
        
        tableView.reloadRowsAtIndexPaths([selectedIndexPath!], withRowAnimation: .Fade)

    }

}
