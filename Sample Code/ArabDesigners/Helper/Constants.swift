//
//  Constants.swift
//  ArabDesigners
//
//  Created by Shiv Charan Panjeta < shiv@ozvid.com > on 02/02/2019.
//  Copyright © 2019 OZVID Technologies Pvt. Ltd. < www.ozvid.com >. All rights reserved.
//

import Foundation
import UIKit

enum AppInfo {
    static let Mode         = "development"
    static let AppName      = "ArabDesigners"
    static let Version      = "1.2"
    static let UserAgent    = "\(Mode)/\(AppName)/\(Version)"
    static let showLogs     = true
}

enum PayTabs {
    static let secret       = "5hlkQcHxRJMe9bgEywbdRIv9JBGiKOSP6eaXqRuiBgxLsOp0kAeciJm2l2l5RdVXs5UTXocyFJj7yJ8Tjm5C6sEsvZxmdtjFyezv"
    static let email        = "ahadotaibi4@gmail.com"
    static let password     = "rVoPaGMCaL"
}

enum Fonts {
    static let normal   = "Tahoma"
    static let bold     = "Tahoma-Bold"
}

enum Colors {
    static var AppColor         = UIColor.init(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
    static var btnColour        = UIColor.init(red: 111/255.0, green: 113/255.0, blue: 121/255.0, alpha: 1.0)
    static var lblLinesColour   = UIColor.init(red: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1.0)
    static var lblLineColor     = UIColor.init(red: 70/255.0, green: 111/255.0, blue: 193/255.0, alpha: 1.0)
}
enum SortingOrder {
    
    static var LOWTOHIGH    = "-price"
    static var HIGHTLOW     = "price"
}

enum DateFormatStyle {
    
    public static let YYYY_MM_DD    = "yyyy-MM-dd"
    public static let DD_MMM_YYYY   = "dd/MMM/yyyy"
    public static let DD_MM_YYYY    = "dd/MM/yyyy"
    public static let HH_MM_A       = "hh:mm:a"
    public static let HH_MM_SS      = "HH:mm:ss"
    public static let YYYY_MM_DD_HH_MM_SS   = "yyyy-MM-dd HH:mm:ss"
    
}

enum Keys {
    static let ProvideAPIKey    = "AIzaSyBNB2Aszn5xVV8CZezkPg0O_Mwru5kYedw"//AIzaSyDV0Znf9yfUrtNCb4SKBrem-lTGgSLNIRw"
}

enum OrderState:Int{
    case STATE_PENDING = 1, STATE_ACCEPTED,  STATE_SHIPPED ,STATE_OUT_OF_DELIVERED ,STATE_DELIVERED,STATE_CANCELED,STATE_PAYMENT_PENDING
}

enum PushNotificationTypes {
    
    static var TYPE_CHAT    = "send"
    static var TYPE_ORDER   = "view"
}

enum EditorialType :Int{
    case TYPE_VIDEO = 0, TYPE_IMAGE, TYPE_TEXT
}

enum Apis {
    
    static let KServerUrl               = "https://arab-designers.com/api/"
    static let KShareLink               = "https://www.arab-designers.com/api/user/share?id="

    static let KSignUp                  = "user/signup"
    static let KLogin                   = "user/login"
    static let KLogout                  = "user/logout"
    static let KRecoverPassword         = "user/recover"
    static let KForgotPassword          = "user/recover"
    static let KChangePassword          = "user/change-password"
    static let KGetUserData             = "user/get?id="
    static let KCheck                   = "user/check"
    
    static let KUpdateProfile           = "user/update?id="
    static let KAllCategory             = "category/all?page="
    static let KSizeList                = "size/all?page="
    static let KUserGet                 = "user/view"
    static let KMainCategory            = "category/maincategory?page="
    static let KBannerCategoryList      = "category/banner?page="
    static let KWomenMenCategory        = "category/get-categories?type_id="
    static let KSubCategory             = "category/get-subcategories?id="
    
    static let KAllProduct              = "product/all?id="
    static let KProductDetial           = "product/get-product?id="
    static let KProductSize             = "product/productsize?id="
    static let KProductColor            = "product/productcolor?id="
    static let KAllDesigner             = "product/designer?page="
    static let KDesignerProduct         = "product/designerproduct?id="
    static let KAddWishlist             = "product/add-wishlist?id="
    static let KWishList                = "product/wishlist"
    static let KRemoveWishListItem      = "product/delete-wishlist?id="
    
    static let KAddCartProduct          = "cart/add"
    static let KGetAllCartItem          = "cart/get-cart"
    static let KDeleteCartItem          = "cart/delete-cartitem?id="
    static let KCheckout                = "order/checkout?"
    static let KSortJustInProducts      = "product/all?id="
    static let KApplyJustInFilter       = "product/filter?id="
    static let KOrderList               = "order/get-orders"
    static let KOrderDetial             = "order/get-order?id="
    static let KVideosCategory          = "category/video-category?page="
    static let KVideosFiles             = "category/video-files?id="
    static let KGetAllMsg               = "chat/get-message"
    static let KSendMsg                 = "chat/send-message"
    static let KNewMsg                  = "chat/get-new-messages?id="
    static let KGetUserDetial           = "user/get?id="
    static let kGetUserAddress          = "user/get-addresses"
    static let kUpdateTransaction       = "transaction/save-transaction"
    static let kPages                   = "user/get-page?type="
    static let kGetAllPages             = "user/get-page-types"
    static let ksocialLogin             = "user/social-login"
    static let KAllProductSearch        = "product/all?search="
    static let KAllNotification         = "order/notifications"
    static let kAddPromo                = "order/apply-promo?code="
    static let kMoveToWishlist          = "cart/move-to-wishlist?id="
    static let kEditCartItem            = "cart/edit-cart-item?id="
    
}

enum AlertValue {
    static var jsonError            = "Error: Unable to encode JSON".localized
    static var urlError             = "Please check the URL : 400".localized
    static var sessionError         = "Session Logged out".localized
    static var urlNotExist          = "URL does not exists : 404".localized
    static var serverError          = "Server error, Please try again..".localized
    static var name                 = "Please enter name".localized
    static var validName            = "Please enter valid name".localized
    static var message              = "Please enter message".localized
    static var firstlogin           = "Please login first".localized
    static var email                = "Please enter email".localized
    static var validEmail           = "Please enter valid email".localized
    static var phoneNumber          = "Please enter phone number".localized
    static var ValidphoneNumber     = "Please enter valid phone number".localized
    static var validPassword        = "Password must be minimum 8 characters".localized
    static var password             = "Please enter password".localized
    static var newPassword          = "Please enter new password".localized
    static var confirmPassword      = "Please enter confirm password".localized
    static var notMatch             = "Password doesn't match".localized
    static var city                 = "Please enter city".localized
    static var state                = "Please enter state".localized
    static var code                 = "Please enter code".localized
    static var country              = "Please enter country".localized
    static var countryFirst         = "Please enter country first".localized
    static var language             = "Please select language".localized
    static var zipcode              = "Please enter zipcode".localized
    static var address              = "Please enter address".localized
    static var privacyPolicy        = "Please agree to our privacy policy".localized
    static var profileImage         = "Please add profile image".localized
    static var profileUpdate        = "Profile updated successfully".localized
    static var passwrdChanged       = "Password changed successfully".localized
    static var signup               = "Signup successful".localized
    static var login                = "Login successful".localized
    static var alert                = "Alert".localized
    static var ok                   = "Ok".localized
    static var cameraNotSupport     = "Camera is not supported".localized
    static var cammeraNotAccess     = "Unable to access the Camera".localized
    static var cancel               = "Cancel".localized
    static var setting              = "Settings".localized
    static var openSettingCamera    = "EnableCamera".localized
    static var deletePhoto          = "Delete Photo".localized
    static var gallery              = "Gallery".localized
    static var camera               = "Camera".localized
    static var dataFound            = "Data not Found".localized
    static var addToFavorite        = "Product added into favorite list".localized
    static var removeFromFavorite   = "Product removed from favorite list".localized
    static var noProduct            = "No Product Found".localized
    static var noImplement          = "Not Implement".localized
    
    static var noNotification       = "No Notification found".localized
}

enum PostType {
    
    static var TYPE_NORMAL      = 1
    static var TYPE_READYTOWEAR = 2
}

