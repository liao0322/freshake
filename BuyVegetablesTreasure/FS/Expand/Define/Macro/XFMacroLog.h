//
//  XFMacroLog.h
//  XFiOSKitDemo
//
//  Created by DamonLiao on 03/12/2016.
//  Copyright © 2016 DamonLiao. All rights reserved.
//

#ifndef XFMacroLog_h
#define XFMacroLog_h

#ifdef DEBUG
#define NSLog(...) NSLog(@"%s 第%d行 \n %@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])
#else
#define NSLog(...)
#endif

#define Print NSLog(@"%s", __func__)

#endif /* XFMacroLog_h */
