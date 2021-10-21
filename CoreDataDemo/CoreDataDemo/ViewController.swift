//
//  ViewController.swift
//  CoreDataDemo
//
//  Created by Latitude Technolabs on 11/12/20.
//  Copyright © 2020 test. All rights reserved.
//

import UIKit
import CoreData
class ViewController: UIViewController {

    //MARK:Variables
    var Image:UIImage?
    
    //MARK:Outlets
    @IBOutlet var txtDOB: UITextField!
    @IBOutlet var txtDesignation: UITextField!
    @IBOutlet var txtName: UITextField!
    @IBOutlet var imgprofile: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Employee")
        request.returnsObjectsAsFaults = false
        
        do
        {
            let results = try context.fetch(request)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                context.delete(managedObjectData)
                print("Deleted")
            }
            
        } catch let error as NSError {
            print(error)
        }
/*        //relationship b/w Employee and Shineinfosoft
        // Create Mutable Set
        let employee = Shineinfosoft.mutableSetValue(forKey: #keyPath(Shineinfosoft.employee))
        
        // Add Employee
        employee.add(Employee.self)

        //to many relationship
         let shineinfosoft = Shineinfosoft(context: appDelegate.persistentContainer.viewContext)
        //shineinfosoft.addToEmployess(employee)
        
        //one-to-one relationship
        
        */
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:Actions
    
    @IBAction func btnSaveTap(_ sender: Any) {

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        //save coredata
        let entity = NSEntityDescription.entity(forEntityName: "Employee", in: context)
        let newUser = NSManagedObject(entity: entity!, insertInto: context)
        newUser.setValue(txtName.text, forKey: "name")
        newUser.setValue(txtDesignation.text, forKey: "designation")
        let dateformater = DateFormatter()
        dateformater.dateFormat = "dd/MM/yy"
        let date = dateformater.date(from: txtDOB.text!)
        newUser.setValue(date, forKey: "dob")
        let imageData = UIImagePNGRepresentation(#imageLiteral(resourceName: "myimage"))
        newUser.setValue(imageData, forKey: "profile")
        do {
            try context.save()
            print("save")
        } catch {
            print("Failed saving")
        }
        
    }
    
    @IBAction func btnShowTap(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        //fetch coredata
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Employee")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                print(data)
                let name = data.value(forKey: "name") as! String
                let designation = data.value(forKey: "designation") as! String
                let dob = data.value(forKey: "dob") as! Date
                let dateformater = DateFormatter()
                dateformater.dateFormat = "dd/MM/yy"
                let date = dateformater.string(from: dob)
                let data = data.value(forKey: "profile") as! Data
                
                let alert = UIAlertController(title: "CoreData",
                                              message: "name: \(name)\n  designation:\(designation) \n DOB: \(dob)",
                                              preferredStyle: UIAlertControllerStyle.alert)
                var imageView = UIImageView(frame: CGRect(x: 220, y: 10, width: 40, height: 40))
                imageView.image = UIImage(data:data)
                
                alert.view.addSubview(imageView)
                
                let cancelAction = UIAlertAction(title: "OK",
                                                 style: .cancel, handler: nil)
                
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            }
        } catch {
            
            print("Failed")
        }
    }
    
}
extension Shineinfosoft{
    @objc(addEmployeesObject:)
    @NSManaged public func addToEmployess(_ value: Employee)
    
    @objc(removeEmployeesObject:)
    @NSManaged public func removeFromEmployess(_ value: Employee)

}
