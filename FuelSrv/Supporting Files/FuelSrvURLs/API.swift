//
//  API.swift
//  FuelSrvDriver
//
//  Created by Apple on 30/04/19.
//  Copyright © 2019 PBS12. All rights reserved.
//

import Foundation

//let baseURL = "https://fuelsrv.ca/api/" //5cfe447ac216a266ed13c3db

 let allOrdersDriverURL = baseURL + "allOrdersDriver"

let driverOrdersScheduledURL = baseURL + "driverorderScheduled"

let acceptOredrsDriverURL = baseURL + "acceptOrderDriver"

let changeuserTypeURL = baseURL + "changeuserType"

let sendPromptURL = baseURL + "sendPrompt"

let orderDetailsURL = baseURL + "orderDetails"

let driverCompleteOrderURL = baseURL + "completeOrder"

let driverOrdersUrgentURL = baseURL + "driverordersUrgent"

let previousfilllingsDriversURL = baseURL + "previousfilllingsDrivers"

let userReimbursementURL = baseURL + "userReimbursement" // userId  {"message":"success","success":true,"userReimbursement":{"myFuelAmount":23.87,"distanceDriven":234.54,"fromDateTime":12334456789,"toDateTime":1234567890987,"customerFuelAmount":223.87,"fuelPumped":534.54,"upcomingReimbursementDate":1234567897}}
//url - sendPrompt
//userId
//driverId
//issue
