//
//  ViewController.h
//  StudyplusSDKDemo
//
//  Created by akitsukada on 2014/02/17.
//  Copyright (c) 2014年 studyplus.jp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPLStudyplusDelegate.h"

@interface ViewController : UIViewController<SPLStudyplusDelegate>
-(BOOL)openURL:(NSURL*)url;
@end
