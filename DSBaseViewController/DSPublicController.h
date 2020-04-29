//
//  DSPublicController.h
//  Pods
//
//  Created by WeiHan on 2020/4/29.
//

#ifndef DSPublicController_h
#define DSPublicController_h

#import <UIKit/UIKit.h>

#ifndef LOG_MACRO
    #define DDLogError(frmt, ...)   NSLog(frmt, ## __VA_ARGS__)
    #define DDLogWarn(frmt, ...)    NSLog(frmt, ## __VA_ARGS__)
    #define DDLogInfo(frmt, ...)    NSLog(frmt, ## __VA_ARGS__)
    #define DDLogDebug(frmt, ...)   NSLog(frmt, ## __VA_ARGS__)
    #define DDLogVerbose(frmt, ...) NSLog(frmt, ## __VA_ARGS__)
#endif

// These macros are used to inject the final super-classes if needed.
#ifndef BASEVIEWCONTROLLER
    #define BASEVIEWCONTROLLER       UIViewController
#endif

#ifndef BASENAVIGATIONCONTROLLER
    #define BASENAVIGATIONCONTROLLER UINavigationController
#endif

#ifndef BASETABBARCONTROLLER
    #define BASETABBARCONTROLLER     UITabBarController
#endif

#endif /* DSPublicController_h */
