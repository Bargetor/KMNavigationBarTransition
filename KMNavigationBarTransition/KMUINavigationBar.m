//
//  KMUINavigationBar.m
//  KMNavigationBarTransition
//
//  Created by 马进 on 2017/5/3.
//  Copyright © 2017年 Zhouqi Mo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KMUINavigationBar.h"
#import <objc/runtime.h>
#import "KMSwizzle.h"

@implementation KMUINavigationBarDSL

-(instancetype)initWithBar:(UINavigationBar *)bar{
    self = [super init];
    if(self){
        self.bar = bar;
        [self buildOverlay:bar];
    }
    return self;
}

-(void)buildOverlay:(UINavigationBar*)bar{
//    [bar addObserver:self forKeyPath:@"frame" options: NSKeyValueObservingOptionNew context: nil];
//    [bar addObserver:self forKeyPath:@"bounds" options: NSKeyValueObservingOptionNew context: nil];
    
    if(!self.overlay){
        UIView* backgroundRectView = [bar valueForKey:@"_backgroundView"];
        CGRect barRect = backgroundRectView.frame;
        
        CGFloat overlayHeight = barRect.size.height <= 0 ? bar.bounds.size.height : barRect.size.height;
        self.overlay = [[UIView alloc]initWithFrame:CGRectMake(0, 0, bar.bounds.size.width, overlayHeight)];
        [self.overlay setUserInteractionEnabled:NO];
        [self.overlay setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [backgroundRectView addSubview:self.overlay];
        [backgroundRectView bringSubviewToFront:self.overlay];
        
        [backgroundRectView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context: nil];
        [backgroundRectView addObserver:self forKeyPath:@"bounds" options:NSKeyValueObservingOptionNew context: nil];
         
        [self.overlay setBackgroundColor:UIColor.blackColor];
    }
}

-(UIColor*)backgroundColor{
    return self.overlay.backgroundColor;
}

-(void)setBackgroundColor:(UIColor *)color{
    [self.overlay setBackgroundColor:color];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([@"frame" isEqualToString: keyPath] || [@"bounds" isEqualToString:keyPath]) {
        NSNumber* newValue = [change objectForKey:NSKeyValueChangeNewKey];
        CGRect newFrame = newValue.CGRectValue;
        self.overlay.frame = CGRectMake(0, 0, newFrame.size.width, newFrame.size.height);
    }
}

@end

@implementation UINavigationBar(KMUINavigationBar)
   
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        KMSwizzleMethod([self class],
                        @selector(init),
                        [self class],
                        @selector(km_init));
        KMSwizzleMethod([self class],
                        @selector(setBackgroundImage:forBarMetrics:),
                        [self class],
                        @selector(km_setBackgroundImage:forBarMetrics:));
    });
}
    
-(instancetype)km_init{
    id bar = [self km_init];
    [self kmNav];
    return bar;
}
    
-(void)km_setBackgroundImage:(UIImage *)backgroundImage forBarMetrics:(UIBarMetrics)barMetrics{
    [[self kmNav] setBackgroundColor: [UIColor colorWithPatternImage:backgroundImage]];
    [self km_setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
}

-(KMUINavigationBarDSL*)kmNav{
    if(![self km_navDSL]){
        [self setKm_navDSL:[[KMUINavigationBarDSL alloc] initWithBar: self]];
    }
    return [self km_navDSL];
}

- (KMUINavigationBarDSL *)km_navDSL {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setKm_navDSL:(KMUINavigationBarDSL *)navDSL {
    objc_setAssociatedObject(self, @selector(km_navDSL), navDSL, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
