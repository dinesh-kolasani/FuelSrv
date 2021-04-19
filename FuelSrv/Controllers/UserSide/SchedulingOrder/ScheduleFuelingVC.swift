//
//  ScheduleFuelingVC.swift
//  FuelSrv
//
//  Created by PBS9 on 09/04/19.
//  Copyright © 2019 Dinesh. All rights reserved.
//

import UIKit
import FSCalendar
import SkyFloatingLabelTextField

class ScheduleFuelingVC: UIViewController,FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance,UITextFieldDelegate{
    
    var myPickerView = UIDatePicker()
    
    @IBOutlet weak var calender: FSCalendar!
    @IBOutlet weak var hoursTxt: UITextField!
    @IBOutlet weak var minTxt: UITextField!
    @IBOutlet weak var AMTxt: UITextField!
    @IBOutlet weak var recurringBtn: UIButton!
    @IBOutlet weak var nextBtn: RoundButton!
    
    @IBOutlet weak var operatingHoursLbl: UILabel!
    //@IBOutlet weak var noteLbl: UILabel!
    @IBOutlet weak var vcHeight: NSLayoutConstraint!
    private var currentPage: Date?
    private lazy var today: Date = {
        return Date()
    }()
    
    var scheduleOrder: [String:Any] = [:]
    var longDate = Int()
    var UserSelectedDate = String()
    var SelectedTime = String()
    var reccuring = String(describing: 1)
    var timeCurrent = String()
    var timeS = ""
    var timeE = ""
    
    //MARK:- View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
       // vcHeight.constant = UIScreen.main.bounds.height   // + 0.1
        navigation()
        timePicker()
        //myPickerView.locale = Locale(identifier: "en_US")
//        let time = currentTime()
//       print(time)

    }
    
    //MARK:- View Will Appear
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    //MARK:- Button Actions
    
    @IBAction func forwardBtn(_ sender: Any) {
        calender.setCurrentPage(getNextMonth(date: calender.currentPage), animated: true)
    }
    
    @IBAction func backwardBtn(_ sender: Any) {
        calender.setCurrentPage(getPreviousMonth(date: calender.currentPage), animated: true)
    }
    
    @IBAction func recurringBtn(_ sender: Any) {
        if recurringBtn.isSelected {
            recurringBtn.setImage(#imageLiteral(resourceName: "Rounded Rectangle"), for: .normal)
            reccuring = String(describing: 0)
        }else{
            recurringBtn.setImage(#imageLiteral(resourceName: "checkbox-activated@"), for: .normal)
            reccuring = String(describing: 1)
        }
    
        recurringBtn.isSelected = !recurringBtn.isSelected
        //reccuring = String(describing: 0)
    }
    @IBAction func nextBtn(_ sender: UIButton) {
        if haltedTrue == 0 {
            if AMTxt.text! != "00"{
                let date = myPickerView.date
                let calender = Calendar.current
                let compHour = Int(truncating: numbFormat(hoursTxt.text!))//calender.component(.hour, from: date)
                let compMinuts = Int(truncating: numbFormat(minTxt.text!))//calender.component(.minute, from: date)
                let compAM = AMTxt.text!
                print(compHour)
                
                // Formating string to Hours
                let inFormatter = DateFormatter()
                inFormatter.dateFormat = "hh:mm a"
                
                let outFormatter = DateFormatter()
                outFormatter.dateFormat = "HH:mm"
                
                // let inStr = "16:50"
                let date1 = inFormatter.date(from: "\(compHour):\(compMinuts) \(compAM)")!
                print(date1)
                let outStr = outFormatter.string(from: date1)
                print("converted time\(outStr)")
                
                if outStr >= endTime || outStr < startTime {
                    // showAlert("Info:", "We're sorry, we won't be fueling at that time! Please request a time within our service hours (\(startTime) to \(endTime)).", "OK")
                    showAlert("Info:", "We’re sorry, our service hours are currently \(startTime) to \(endTime), please schedule a fueling between those hours!", "OK")
                }
                else{
                    scheduleOrder[ScheduleFuelingEnum.LongDate.rawValue] = longDate
                    scheduleOrder[ScheduleFuelingEnum.SelectedDate.rawValue] = UserSelectedDate
                    scheduleOrder[ScheduleFuelingEnum.SelectedTime.rawValue] = SelectedTime
                    scheduleOrder[ScheduleFuelingEnum.Reccuring.rawValue] = reccuring
                    
                    appDelegate.orderDataDict[OrderDataEnum.Schedule.rawValue] = scheduleOrder
                    print(appDelegate.orderDataDict)
                    
                    
                    let curerntdate = Date()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "EEE, MMM dd, yyyy"
                    
                    let convertedDate: String = dateFormatter.string(from: curerntdate)
                    let currentDate = String(describing: convertedDate)
                    
                    if currentDate == UserSelectedDate {
                        if timeCurrent >= SelectedTime {
                            urgentOrder = 1
                            
                        }else{
                            urgentOrder = 0
                        }
                    }else{
                        urgentOrder = 0
                    }
                    
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ConvenientServicesVC") as! ConvenientServicesVC
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }else{
              self.showAlert("Info:", "Please select valid date and time!", "OK")
            }
            
        }else{
            self.showAlert("Info:", haltedMessage, "OK")
        }
    }
    
    func presentTime() -> [String]{
        let date = Date()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let time = formatter.string(from: date)
        let timeCompents = time.components(separatedBy: ":")
        
        return timeCompents
    }
    //MARK:- Navigation
    func navigation(){
        navigationItem.leftItemsSupplementBackButton = true
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.title = "SCHEDULE FUELING"
        
        self.operatingHoursLbl.text = timeS + " - " + timeE
//        noteLbl.text = "Note: Fuelings less than 2 hours from now will incur a \(currencyFormat(String(describing: onDemandPrice))) On-Demand service fee."
        
        //Time displying in time textfields
        let displayingTime = presentTime()
        print(displayingTime)

        let currentHourText = displayingTime[0]
        let displayingText =  Int(truncating: numbFormat(currentHourText)) + Int(truncating: numbFormat("02"))
        print(displayingText)
        
        if displayingText >= 24{
            
            hoursTxt.text = "00"
            minTxt.text = "00"
            AMTxt.text = "00"
        }else{
           print("currentTime")
            let hourString = String(describing: displayingText)
            
            // Formating string to Hours
            let inFormatter = DateFormatter()
            //inFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
            inFormatter.dateFormat = "HH:mm"
            
            let outFormatter = DateFormatter()
            //outFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
            outFormatter.dateFormat = "hh:mm:a"
            
            // let inStr = "16:50"
            let date = inFormatter.date(from: "\(hourString):\(displayingTime[1])")!
            print(date)
            let outStr = outFormatter.string(from: date)
            let compents = outStr.components(separatedBy: ":")
            
            hoursTxt.text = compents[0] //"\(displayingText)"
            minTxt.text = compents[1]
            AMTxt.text = compents[2]
            SelectedTime = hoursTxt.text! + ":" + minTxt.text! + " " + AMTxt.text!
            self.timeCurrent = SelectedTime
        }
        
        
    }
    func numbFormat(_ someString: String?) -> NSNumber {
        guard someString != nil else { return 00.00 }
        let doubleValue = Double(someString!) ?? 00.0
        let myInteger = Int(doubleValue)
        let myNumber = NSNumber(value:myInteger)
        return myNumber
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        let date = Date()
        let calender = Calendar.current
        var comp = calender.dateComponents([.hour,.minute], from: date)
        comp.hour = comp.hour! + 2
        print(comp)
        
        let someDateTime = calender.date(from: comp)
        
        myPickerView.date = someDateTime ?? Date()
        comp.hour = comp.hour! - 2

        return true
    }
    
    //MARK:- Time Picker
    func timePicker(){
        
        myPickerView.datePickerMode = .time
    
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action:#selector(ScheduleFuelingVC
            .donetimePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.done, target: self, action:#selector(ScheduleFuelingVC.cancelDatePicker))
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        
        hoursTxt.delegate = self
        minTxt.delegate = self
        AMTxt.delegate = self
        hoursTxt.inputAccessoryView = toolbar
        hoursTxt.inputView = myPickerView
        minTxt.inputAccessoryView = toolbar
        minTxt.inputView = myPickerView
        
        AMTxt.inputAccessoryView = toolbar
        AMTxt.inputView = myPickerView
        
    }
    @objc func donetimePicker()
    {
        let curerntdate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, MMM dd, yyyy"
        
        let convertedDate: String = dateFormatter.string(from: curerntdate)
        let currentDate = String(describing: convertedDate) //2019-07-07
        
        let date = myPickerView.date
        let calender = Calendar.current
        let compHour = calender.component(.hour, from: date)
        let compMinuts = calender.component(.minute, from: date)
        print(compHour)
        
        // Formating string to Hours
        let inFormatter = DateFormatter()
        inFormatter.dateFormat = "HH:mm"
        
        let outFormatter = DateFormatter()
        outFormatter.dateFormat = "HH:mm"
        
        // let inStr = "16:50"
        let date1 = inFormatter.date(from: "\(compHour):\(compMinuts)")!
        print(date)
        let outStr = outFormatter.string(from: date1)
        print("converted time\(outStr)")
        
        //let minutes = calender.component(.minute, from: date)
        //let comp = calender.dateComponents([.hour,.minute], from: date)
       // print(comp)
        
        if currentDate == UserSelectedDate {
            
            let dateCurrent = NSDate()
            let calendarCurrent = NSCalendar.current
            
            
            let componentsCurrentHour = calendarCurrent.component(Calendar.Component.hour, from: dateCurrent as Date)
            let componentsCurrentMinute = calendarCurrent.component(Calendar.Component.minute, from: dateCurrent as Date)
            let hour = componentsCurrentHour // Calendar.Component.hour
            print(hour) // Calendar.Component.minute
            
            let time1 = "\(componentsCurrentHour):\(componentsCurrentMinute)"
            let time2 = "\(compHour):\(compMinuts)"
            
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            
            let date1 = formatter.date(from: time1)
            let date2 = formatter.date(from: time2)
            
            var result: ComparisonResult? = nil
            if let date2 = date2 {
                result = date1?.compare(date2)
            }
            if result == .orderedDescending {
                showAlert("Info:", "Please select valid date and time!", "OK")
                print("time1 is later than time2")
                
            } else if result == .orderedAscending {
                if outStr >= endTime || outStr < startTime {
                    
//                    showAlert("Info:", "We're sorry, we won't be fueling at that time! Please request a time within our service hours (\(startTime) to \(endTime)).", "OK")
                    showAlert("Info:", "We’re sorry, our service hours are currently \(startTime) to \(endTime), please schedule a fueling between those hours!", "OK")
                }else{
                    print("time1 is later than time2")
                    
                    let formatter = DateFormatter()
                    formatter.dateFormat = "hh:mm:a"
                    let time = formatter.string(from: date)
                    print(time)
                    let timeCompents = time.components(separatedBy: ":")
                    
                    hoursTxt.text = timeCompents[0]
                    minTxt.text = timeCompents[1]
                    AMTxt.text = timeCompents[2]
                    
                    self.view.endEditing(true)
                    SelectedTime = hoursTxt.text! + ":" + minTxt.text! + " " + AMTxt.text!
                }
                
                
            } else {
                showAlert("Info:", "Please select valid date and time!", "OK")
                print("time1 is equal to time2")
            }
            
        }
        else{
            
        if outStr >= endTime || outStr < startTime {
            
//            showAlert("Info:", "We're sorry, we won't be fueling at that time! Please request a time within our service hours (\(startTime) to \(endTime)).", "OK")
            showAlert("Info:", "We’re sorry, our service hours are currently \(startTime) to \(endTime), please schedule a fueling between those hours!", "OK")
        }else{
            let formatter = DateFormatter()
            formatter.dateFormat = "hh:mm:a"
            let time = formatter.string(from: date)
            print(time)
            let timeCompents = time.components(separatedBy: ":")
            
            hoursTxt.text = timeCompents[0]
            minTxt.text = timeCompents[1]
            AMTxt.text = timeCompents[2]
            
            self.view.endEditing(true)
            SelectedTime = hoursTxt.text! + ":" + minTxt.text! + " " + AMTxt.text!
        }
    }
        print(SelectedTime)
        
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    //MARK:- Calender
    func getNextMonth(date:Date)->Date {
        return  Calendar.current.date(byAdding: .month, value: 1, to:date)!
    }
    
    func getPreviousMonth(date:Date)->Date {
        return  Calendar.current.date(byAdding: .month, value: -1, to:date)!
    }
    
    
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        
        let curerntdate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, MMM dd, yyyy"
        
        let convertedDate: String = dateFormatter.string(from: curerntdate)
        self.UserSelectedDate = String(describing: convertedDate)
        print("UserSelectedDate: \(UserSelectedDate)")
        
        let selectdateinlong = curerntdate.timeIntervalSince1970
        let longDateObj1 = selectdateinlong*1000
        self.longDate = Int(longDateObj1)
        
        //self.longDate = String(describing: longDateObj1)
        
        return Date()
        
        
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        calendar.today = nil
       // print("calendar did select date \(self.formatter.string(from: date))")
        if monthPosition == .previous || monthPosition == .next {
            calendar.setCurrentPage(date, animated: true)
        }
        
       // print(date)
        let selectdateinlong = date.timeIntervalSince1970
        let longDateObj = selectdateinlong*1000
        self.longDate  = Int(longDateObj)
        print("printing longdate \(longDate)")
        let selectdate = date
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "EEE, MMM dd, yyyy"
        let convertedDate: String = dateFormatter.string(from: selectdate)
        self.UserSelectedDate = convertedDate
        print("printing user \(UserSelectedDate)")
    }
    
}
enum ScheduleFuelingEnum:String {
    case LongDate
    case SelectedDate
    case SelectedTime
    case Reccuring
    
}
