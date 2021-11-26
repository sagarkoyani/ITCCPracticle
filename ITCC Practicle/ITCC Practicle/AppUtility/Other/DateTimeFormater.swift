//
//  DateTimeFormater.swift
//  MVVMBasicStructure
//
//  Created by KISHAN_RAJA on 28/02/21.
//

import Foundation

//MARK:- Date time formater
enum DateTimeFormater : String {
    case yyyymmdd       = "yyyy-MM-dd"
    case MMM_d_Y        = "MMM d, yyyy"
    case HHmmss         = "HH:mm:ss"
    case hhmma          = "hh:mma"
    case HHmm           = "HH:mm"
    case dmmyyyy        = "d/MM/yyyy"
    case hhmmA          = "hh:mm a"
    case UTCFormat      = "yyyy-MM-dd HH:mm:ss"
    case UTCFormatWith12H      = "yyyy-MM-dd hh:mm a"
    case NodeUTCFormat  = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    case ddmm_yyyy      = "dd MMM, yyyy"
    case WeekDayhhmma   = "EEE,hh:mma"
    case dmm_hhmm       = "d MMM, hh:mma"
    case ddmonyyyy      = "dd MMMM, yyyy"
    case ddmm_yyyy_hhmm = "dd MMM, yyyy. hh:mm a"
    case yyyyddmm       = "yyyy-dd-MM"
    case ddmmyyyyWithoutSpace       = "dd-MM-yyyy"
    case nameddmmyyyy        = "EEEE, dd/MM/yyyy"
    case mmmmddyyyy = "MMMM dd, yyyy"
    case ddmmyyyy        = "dd/MM/yyyy"
    case nameMMMddyyyy = "EEEE,  MMMM dd,  yyyy"
    case ddMMyyyyHHmmss      = "dd-MM-yyyy HH:mm:ss"
}
