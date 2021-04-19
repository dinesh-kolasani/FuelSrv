//
//  Constants.swift
//  FuelSrv
//
//  Created by PBS9 on 04/04/19.
//  Copyright © 2019 Dinesh. All rights reserved.
//

import Foundation

//let deviceToken = "deviceId"
//let defaultValues = UserDefaults.standard
//let Token = defaultValues.value(forKey: deviceToken) as? String

var approxNoOfVehicles = ["1 - 10","11 - 25","26 - 50","51 - 100","100+"]
var noOfVehicle = "1 - 10"
var popTwoBack = Bool()
var fullUrl = Int()
var membership: Int = 0
var onDemandPrice = Double()
var paymentStatus = Int()
var urgentOrder = Int()
//var Verified = Int()
var freeTrialTaken = Int()
var notificationTrue = Int()
var physicalRecieptYes = Int()
var profileCompleted = Int()
var firstTimeOrder = Int()
var refCode = String()
var cancelAction = Bool()
var startTime = String()
var endTime = String()
var haltedMessage = String()
var haltedTrue = Int()

//var UESRID = defaultValues.string(forKey: "UserID")

let defaultValues = UserDefaults.standard

var userID = defaultValues.value(forKey: "UserID") as! String //?? ""
var RemenberValue = defaultValues.value(forKey: "Rememberme") as? String ?? ""
var USEREMAIL = defaultValues.value(forKey: "UserEmail") as? String ?? ""
var USERPASSWORD = defaultValues.value(forKey: "UserPassword") as? String ?? ""
var userName = defaultValues.value(forKey: "UserName") as? String ?? ""
var userAddres = defaultValues.value(forKey: "address") as? String ?? ""
var userPhNum = defaultValues.value(forKey: "Phone") as? String ?? ""
var userphoto = defaultValues.value(forKey: "avatar") as! String
var deviceIdNum = defaultValues.value(forKey: "DeviceID") as? String ?? ""
var accountType = defaultValues.value(forKey: "AccountType") as! Int
var physicalReciept = defaultValues.value(forKey: "PhysicalReciept") as? Int ?? 0
var membershipTaken = defaultValues.value(forKey: "MembershipTaken") as? Int ?? 0
var inviteCodeText = defaultValues.value(forKey: "InviteCodeText") as? String ?? ""
var userType = defaultValues.value(forKey: "UserType") as? Int ?? 0
var isVerified = defaultValues.value(forKey: "IsVerified") as? Int ?? 0
