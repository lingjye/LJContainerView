//
//  DelegateContainer.h
//  LJContainerView
//
//  Created by txooo on 16/11/8.
//  Copyright © 2016年 领琾. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface LJDelegateContainer : NSObject<UIScrollViewDelegate>

@property (nonatomic,weak) id firstDelegate;

@property (nonatomic,weak) id secondDelegate;

+ (instancetype)containerDelegateWithFirst:(id)firstDelegate second:(id)secondDelegate;

@end
