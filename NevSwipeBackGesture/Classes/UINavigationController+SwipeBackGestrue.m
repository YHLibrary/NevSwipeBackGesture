//
//  UINavigationController+SwipeBackGestrue.m
//  NevSwipeBackGesture
//
//  Created by 王英辉 on 2024/11/13.
//

#import "UINavigationController+SwipeBackGestrue.h"
#import <objc/runtime.h>

@interface UINavigationController () <UINavigationControllerDelegate>

@end

@implementation UINavigationController (SwipeBackGestrue)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method originalPush = class_getInstanceMethod(self, @selector(pushViewController:animated:));
        Method swizzledPush = class_getInstanceMethod(self, @selector(swizzled_pushViewController:animated:));
        
        method_exchangeImplementations(originalPush, swizzledPush);
    });
}

- (void)swizzled_pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    self.delegate = self;
    [self swizzled_pushViewController:viewController animated:animated];
}


- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [self enableSwipeBackGesture];
}

- (void)enableSwipeBackGesture {
    self.interactivePopGestureRecognizer.enabled = self.childViewControllers.count > 1;
    self.interactivePopGestureRecognizer.delegate = nil;
}
@end
