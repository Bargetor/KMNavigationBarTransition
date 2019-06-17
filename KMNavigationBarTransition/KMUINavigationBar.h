//
//  KMUINavigationBar.h
//  KMNavigationBarTransition
//
//  Created by 马进 on 2017/5/3.
//  Copyright © 2017年 Zhouqi Mo. All rights reserved.
//

#ifndef KMUINavigationBar_h
#define KMUINavigationBar_h

#import <UIKit/UIKit.h>

@interface KMUINavigationBarDSL : NSObject

@property (nonatomic, strong) UINavigationBar *bar;
@property (nonatomic, strong) UIView *overlay;
@property (nonatomic, strong) UIColor *backgroundColor;

-(instancetype)initWithBar:(UINavigationBar*) bar;
@end




@interface UINavigationBar(KMUINavigationBar)

@property (nonatomic, weak, readonly) KMUINavigationBarDSL* kmNav;

@end

#endif /* KMUINavigationBar_h */
