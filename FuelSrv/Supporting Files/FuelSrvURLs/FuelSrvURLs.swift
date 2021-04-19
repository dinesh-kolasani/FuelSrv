//
//  FuelSrvURLs.swift
//  FuelSrv
//
//  Created by PBS9 on 01/04/19.
//  Copyright © 2019 Dinesh. All rights reserved.
//

import Foundation


//MARK:- LIVE
let baseURL = "https://fuelsrv.ca/v3/api/"
let baseImageURL = "https://fuelsrv.ca/v3/api/image/"
let StripPaymentKey = "pk_live_EJynNmJD3fIRj53SFN13NppI00oBwxbQse"

//MARK:- DEV
//let baseURL = "http://18.221.142.137:8080/v3/api/"  // --- Main url ---
//let baseImageURL = "http://18.221.142.137:8080/v3/api/image/" // --- Base Image URL ---
//let StripPaymentKey = "pk_test_2DKsusSmJqwzBpcnLyYjVjvD00fRHqeuWO"  // --- Payment Key ---


//MARK: - Onboarding urls
let userLoginURL = baseURL + "userLogin"

let emailRegisterURL = baseURL + "emailRegister"

let googleURL = baseURL + "socialLogin"

let facebookURL = baseURL + "socialLogin"

let forgetPasswordURL = baseURL + "forgetPassword"

let vehicleURL = baseURL + "addVehicle"

let fuelTypeURL = baseURL + "allfuelType"

let businessTypeURL = baseURL + "allBuisnesstypeuser"

let getbrandsURL = baseURL + "getbrands"

let getModelsURL = baseURL + "getModels"

let getcolorsURL = baseURL + "getcolors"

let referralCodeURL = baseURL + "updateReferralCode" //"referralCode"

let promocodeURL = baseURL + "promocodeValid"

let updateLocationURL = baseURL + "updateLocation"

let getHomeDataURL = baseURL + "getHomeData"

let allServicesURL = baseURL + "allServices"

let getAllvehiclesURL = baseURL + "getAllvehicles"

let getProfileURL = baseURL + "getProfile"

let lastOrderDetailURL = baseURL + "lastOrderDetail"

let deleteVehicleURL = baseURL + "deleteVehicle"

let updateVehicleURL = baseURL + "updateVehicle"

let updateProfileURL = baseURL + "updateProfile"

let deleteAccountURL = baseURL + "deleteAccount"

let changePasswordURL = baseURL + "changePassword"

let getOilURL = baseURL + "getOil"

let getFilltyreURL = baseURL + "getFilltyre"

let getPlowmydrivewayURL = baseURL + "getPlowmydriveway"

let getWindshieldURL = baseURL + "getWindshield"

let placeOrderURL = baseURL + "placeOrder"

let cancelOrderURL = baseURL + "cancelOrderUser"

let cancelReccuringOrderURL = baseURL + "cancelReccuringOrder"

let allPendingOrdersURL = baseURL + "allpendingOrders"

let allrecurringOrdersURL = baseURL + "allrecurringOrders"

let allcompletedOrdersURL = baseURL + "allcompletedOrders"

let uploaddriverDocumentsURL = baseURL + "uploaddriverDocuments"


let getAllMemberShipURL = baseURL + "getAllMemberShip"

let buyMemberShipURL = baseURL + "buyMemberShip"

let cancelMembershipURL = baseURL + "cancelSubscription"

let getCardURL = baseURL + "getCard"

let addCardURL = baseURL + "addCard"

let deleteCardURL = baseURL + "deleteCard"

let checkUserVerificationURL = baseURL + "checkUserVerification"

let getCityAvailabilityURL = baseURL + "getCityAvailability"

let getallLocationsURL = baseURL + "getallLocations"

let deleteAddressURL = baseURL + "deleteAddress"

let editAddressURL = baseURL + "editAddress"

let notificationOnOffURL = baseURL + "notificationOnOff" //userId  isNotificationTrue = 1 for on 0 for off

let physicalRecieptURL = baseURL + "physicalReciept" // userId  isPhysicalRecieptYes = 1 for on 0 for off

let contactMeURL = baseURL + "contactMe"


let aboutURL =  "https://fuelsrv.com/about/about.html"

let userGuideURL = "https://fuelsrv.com/about/user-side-help.html"


let GoogleClientid = "85808799514-hdvb7jh6vif5ovtvhevl5e7akcr14ij5.apps.googleusercontent.com"

let GMSServicesid = "AIzaSyBVR9y0dhBvTnGkHOah1xy2rOIEB1J0pRA"
let GMSPlacesClientid = "AIzaSyBVR9y0dhBvTnGkHOah1xy2rOIEB1J0pRA"


//  https://docs.google.com/document/d/1HYolS6XFasi9Sm_sWk75-uh6v1pEKDYPLpf06UAQmKU/edit#
//com.googleusercontent.apps.85808799514-hdvb7jh6vif5ovtvhevl5e7akcr14ij5
