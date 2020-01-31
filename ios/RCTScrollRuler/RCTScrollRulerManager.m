//
//  RCTScrollRulerManager.m
//  RCTScrollRuler
//
//  Created by Daniel on 2018/5/15.
//  Copyright © 2018年 Daniel. All rights reserved.
//

#import "RCTScrollRulerManager.h"
#import "RCTScrollRuler.h"
#import <React/RCTBridge.h>
#import <React/RCTEventDispatcher.h>
#import <React/UIView+React.h>

#define ScreenWidth  ([[UIScreen mainScreen] bounds].size.width)
#define ScreenHeight  ([[UIScreen mainScreen] bounds].size.height)

@interface RCTScrollRulerManager() <RCTScrollRulerDelegate>

@property(nonatomic,strong)RCTScrollRuler *noneZeroRullerView;

@end

@implementation RCTScrollRulerManager

RCT_EXPORT_MODULE()

RCT_EXPORT_VIEW_PROPERTY(minValue, int);

RCT_EXPORT_VIEW_PROPERTY(maxValue, int);

RCT_EXPORT_VIEW_PROPERTY(exponent, int);

RCT_EXPORT_VIEW_PROPERTY(step, float);

RCT_EXPORT_VIEW_PROPERTY(defaultValue, int);

RCT_EXPORT_VIEW_PROPERTY(num, int);

RCT_EXPORT_VIEW_PROPERTY(unit, NSString);

RCT_EXPORT_VIEW_PROPERTY(markerColor, NSString);

RCT_EXPORT_VIEW_PROPERTY(markerTextColor, NSString);

RCT_EXPORT_VIEW_PROPERTY(isTime, BOOL);

RCT_EXPORT_VIEW_PROPERTY(onSelect, RCTBubblingEventBlock);

RCT_EXPORT_VIEW_PROPERTY(accessbilityText, NSString);

- (UIView *)view
{
    
    CGFloat rullerHeight = [RCTScrollRuler rulerViewHeight];
    _noneZeroRullerView = [[RCTScrollRuler alloc]initWithFrame:CGRectMake(10, 0, ScreenWidth-20, rullerHeight) theMinValue:0 theMaxValue:0 exponent:0 defaultValue:5 theStep:1.0 theNum:10 theUnit:@"" isTime:false markerColor:@"#ff8d2a" markerTextColor:@"#ffffff" accessbilityText:@""];
    _noneZeroRullerView.bgColor = [UIColor whiteColor];
    _noneZeroRullerView.delegate        = self;
    _noneZeroRullerView.scrollByHand    = NO;
    
    return _noneZeroRullerView;
}

#pragma RCTScrollRulerDelegate
-(void)dyScrollRulerView:(RCTScrollRuler *)rulerView valueChange:(float)value exponent:(int)exponent exponentFValue:(float)exponentFloatValue{
    if(rulerView.onSelect){
        if(exponent > 0){
//            NSLog(@"TEMP %f",(float)value * exponentFloatValue);
//            NSLog(@"VAL %f",value);
//            NSLog(@"EXP %f", 1/exponentFloatValue);
//            NSLog(@"EXP VAL %f", exponentFloatValue);
            
            NSString *formatStr = exponent == 1 ? @"%.1f" : (exponent == 2 ? @"%.2f" : exponent == 3 ? @"%.3f" : exponent == 4 ? @"%.4f" : @"");
            NSString *valueStr = [NSString stringWithFormat:formatStr,value * exponentFloatValue];
            //NSLog(@"%f",[valueStr floatValue]);
            // rulerView
            rulerView.onSelect(@{@"value": @([valueStr floatValue])});
        }else{
            rulerView.onSelect(@{@"value": @((int)value)});
        }
    }
}

@end
