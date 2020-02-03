//
//  RCTScrollRuler.m
//  RCTScrollRuler
//
//  Created by shenhuniurou on 2018/5/11.
//  Copyright © 2018年 shenhuniurou. All rights reserved.
//

#define ScreenWidth  ([[UIScreen mainScreen] bounds].size.width)
#define ScreenHeight  ([[UIScreen mainScreen] bounds].size.height)

#define TextColorGrayAlpha 1.0 //文字的颜色灰度
#define TextRulerFont  [UIFont systemFontOfSize:11]
#define RulerLineColor [UIColor grayColor]

#define RulerGap         12 //单位距离
#define RulerLong        35
#define IndicatorHeight  109
#define RulerShort       20
#define RulerMedium      23
#define TrangleWidth     16
#define CollectionHeight 80

#import "RCTScrollRuler.h"
#import <CoreGraphics/CoreGraphics.h>
#import <AVFoundation/AVFoundation.h>
#include <math.h>
//#import "RNRullerAccessbilityElement.h"
/**
 *  绘制三角形标示
 */
@interface DYTriangleView : UIView
@property(nonatomic,strong)UIColor *triangleColor;

@end
@implementation DYTriangleView

-(void)drawRect:(CGRect)rect{
    
    [[UIColor orangeColor]set];
    UIRectFill([self bounds]);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    //CGContextSetRGBStrokeColor(context, 0.0, 1.0, 0.0, 1.0);//设置线的颜色，默认是黑色
    CGContextSetStrokeColorWithColor(context, _triangleColor.CGColor);
    CGContextSetLineWidth(context, 2);//设置线的宽度，
    CGContextSetLineCap(context, kCGLineCapButt);
    
    //利用path路径进行绘制三角形
    //    CGContextBeginPath(context);//标记
    
    CGContextMoveToPoint(context, rect.size.width, 0);
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height);
    CGContextStrokePath(context);//开始绘制
}

@end


/***************DY************分************割************线***********/

@interface DYRulerView : UIView

@property (nonatomic,assign)NSInteger betweenNumber;
@property (nonatomic,assign)int minValue;
@property (nonatomic,assign)int maxValue;
@property (nonatomic,assign)int exponent;
@property (nonatomic,assign)float exponentFloatValue;
@property (nonatomic,assign)int totalMaxValue;
@property (nonatomic,assign)int baseMinValue;
@property (nonatomic,assign)int defaultValue;
@property (nonatomic,assign)BOOL isTime;
@property (nonatomic,assign)NSString *markerColor;
@property (nonatomic,assign)NSString *markerTextColor;
@property (nonatomic,assign)float step;
@property (nonatomic,assign)NSInteger row;
@property (nonatomic,assign)NSInteger totalRows;

-(float)calculateExponentValue:(int)exp;

@end
@implementation DYRulerView
@synthesize isTime;
@synthesize exponent;
@synthesize exponentFloatValue;


-(float)calculateExponentValue:(int)exp{
    
    //NSLog(@"%f",pow(10, exp));
    //return 1/pow(10, exp);
    
    if(exp == 1){
        return 0.1;
    }else if (exp == 2){
        return 0.01;
    }else if (exp == 3){
        return 0.001;
    }else if (exp == 4){
        return 0.0001;
    }else if (exp == 5){
        return 0.00001;
    }
    return 0.1;
}

-(void)drawRect:(CGRect)rect{
    
    CGFloat startX = 0;
    CGFloat lineCenterX = RulerGap;
    CGFloat topY = rect.size.height;
    CGFloat shortLineY  = topY-(rect.size.height - RulerLong);
    CGFloat longLineY = topY-(rect.size.height - RulerShort);
    CGFloat mediumLineY = topY-(rect.size.height - RulerMedium);
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, (float)192/255.0, (float)192/255.0, (float)192/255.0, 1.0);//设置线的颜色，默认是黑色
    CGContextSetLineWidth(context, 1);//设置线的宽度，
    CGContextSetLineCap(context, kCGLineCapButt);
    
    int stepInt = (int)_step;
    int skipValue = (_baseMinValue % (10*stepInt));
    _minValue = _minValue - skipValue;
    _maxValue = _maxValue - skipValue;
   
    if(isTime == true){
        
        for (int i = 0; i <= _betweenNumber; i ++){
            
            CGContextMoveToPoint(context, startX+lineCenterX*i, topY);
            int tempInt = (int)(i * _step) + _minValue;
            if(tempInt > _totalMaxValue){
                return;
            }
            if(tempInt < _baseMinValue){
                continue;
            }
            if (tempInt%10 == 0){
                
                int numeric = (int)(i * _step) + _minValue;
                int minutes =  floor(numeric / 60);
                int seconds = numeric - minutes * 60;
                NSString * secStr = (seconds < 10) ? [NSString stringWithFormat:@"0%d",seconds] :  [NSString stringWithFormat:@"%d",seconds];
                NSString *num = [NSString stringWithFormat:@"%d:%@", minutes, secStr];
                //NSString *num = [NSString stringWithFormat:@"%d:%d", minutes, seconds];
                // NSLog(@"Num: %@, Step : %f, Min : %d, i: %d ",num, _step, _minValue, i );
                if ([num isEqualToString:@"0"]||[num isEqualToString:@"0:00"]) {
                    num = @"0:00";
                }
                
                
                //NSDictionary *attribute = @{NSFontAttributeName:TextRulerFont, NSForegroundColorAttributeName:[UIColor blackColor]};
                NSDictionary *attribute = @{NSFontAttributeName:TextRulerFont, NSForegroundColorAttributeName:[RCTScrollRuler colorFromHexString:@"#434343"]};
                
                
                CGFloat width = [num boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:0 attributes:attribute context:nil].size.width;
                
                CGFloat predictedX = startX+lineCenterX*i-width/2;
                if(self.row == 0 && i == 0){
                    predictedX = (startX+lineCenterX*i-width/2)+width/2;
                }
                else if(self.row == self.totalRows-1 && i > 0 ){
                    predictedX = (startX+lineCenterX*i-width/2)-width/2;
                }
                [num drawInRect:CGRectMake(predictedX, longLineY-14, width+2, 16) withAttributes:attribute];
                CGContextMoveToPoint(context, startX+lineCenterX*i, topY);
                CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
                CGContextAddLineToPoint(context, startX+lineCenterX*i, longLineY);
            }else if(tempInt%(5) == 0){
                CGContextSetStrokeColorWithColor(context, [RCTScrollRuler colorFromHexString:@"#999999"].CGColor);
                CGContextAddLineToPoint(context, startX+lineCenterX*i, mediumLineY);
                
            }else{
                CGContextAddLineToPoint(context, startX+lineCenterX*i, shortLineY);
            }
            CGContextStrokePath(context);//开始绘制
        }
    }else{
        
        
        
        for (int i = 0; i <= _betweenNumber * _step ; i = i+1 ){
            
            CGContextMoveToPoint(context, startX+lineCenterX*i, topY);
            int tempInt = (int)(i * (_step)) + _minValue;
            if(tempInt > _totalMaxValue){
                
                return;
            }
            if(tempInt < _baseMinValue){
                
                continue;
            }
            
            
            if ((tempInt%(_betweenNumber*stepInt) == 0)){
                
                int pValue = (i * (_step) + _minValue);
                NSString *num = [RCTScrollRuler getFormattedString:pValue exponent:exponent];
                
                
                if ([num isEqualToString:@"0"]) {
                    
                    if(isTime == false){
                        num = @"0";
                    }else{
                        num = @"0:0";
                    }
                }
                //NSLog(@"%f",1/pow(10, tempInt));
                NSDictionary *attribute = @{NSFontAttributeName:TextRulerFont, NSForegroundColorAttributeName:[RCTScrollRuler colorFromHexString:@"#434343"]};
                
                CGFloat width = [num boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:0 attributes:attribute context:nil].size.width;
                
                CGFloat predictedX = startX+lineCenterX*i-width/2;
                if(self.row == 0 && i == 0){
                    predictedX = (startX+lineCenterX*i-width/2)+width/2;
                }
                else if(self.row == self.totalRows-1 && i > 0 ){
                    predictedX = ((startX+lineCenterX*i-width/2)-width/2);
                }
                
                [num drawInRect:CGRectMake(predictedX , longLineY-14, width + 40, 16) withAttributes:attribute];
                CGContextMoveToPoint(context, startX+lineCenterX*i, topY);
                CGContextSetStrokeColorWithColor(context, [RCTScrollRuler colorFromHexString:@"#999999"].CGColor);
                CGContextAddLineToPoint(context, startX+lineCenterX*i, longLineY);
                
            }else if(tempInt%(5*stepInt) == 0){
                CGContextSetStrokeColorWithColor(context, [RCTScrollRuler colorFromHexString:@"#999999"].CGColor);
                CGContextAddLineToPoint(context, startX+lineCenterX*i, mediumLineY);
                
            }else{
                
                CGContextSetStrokeColorWithColor(context, [RCTScrollRuler colorFromHexString:@"#999999"].CGColor);
                CGContextAddLineToPoint(context, startX+lineCenterX*i, shortLineY);
            }
            CGContextStrokePath(context);//开始绘制
        }
    }
}



@end


/***************DY************分************割************线***********/

@interface DYHeaderRulerView : UIView

@property(nonatomic,assign)int minValue;
@property(nonatomic,assign)BOOL isTime;

@end

@implementation DYHeaderRulerView

-(void)drawRect:(CGRect)rect{
    
    CGFloat longLineY = rect.size.height - RulerShort;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, (float)192/255.0, (float)192/255.0,(float)192/255.0, 1.0);
    CGContextSetLineWidth(context, 1.0);
    CGContextSetLineCap(context, kCGLineCapButt);
    
    CGContextMoveToPoint(context, rect.size.width, 0);
    
    NSString *num;
    if (_minValue == 0) {
        if(_isTime == false){
            num = @"0";
        }else{
            num = @"0:0";
        }
        
    } else {
        num = [NSString stringWithFormat:@"%d", _minValue];
    }
    
    NSDictionary *attribute = @{NSFontAttributeName:TextRulerFont,NSForegroundColorAttributeName:[UIColor clearColor]};
    CGFloat width = [num boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:0 attributes:attribute context:nil].size.width;
    [num drawInRect:CGRectMake(rect.size.width-width/2, longLineY+40, width, 16) withAttributes:attribute];
    CGContextAddLineToPoint(context, rect.size.width, longLineY);
    CGContextStrokePath(context);//开始绘制
}

@end




/***************DY************分************割************线***********/
@interface DYFooterRulerView : UIView

@property(nonatomic,assign)int maxValue;
@end
@implementation DYFooterRulerView

-(void)drawRect:(CGRect)rect{
    
    CGFloat longLineY = rect.size.height - RulerShort;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, (float)192/255.0, (float)192/255.0, (float)192/255.0, 1.0);
    CGContextSetLineWidth(context, 0.0);
    CGContextSetLineCap(context, kCGLineCapButt);
    
    CGContextMoveToPoint(context, 0, 0);//起始点
    NSString *num = [NSString stringWithFormat:@"%d",_maxValue];
    //NSLog(@"%@",num);
    NSDictionary *attribute = @{NSFontAttributeName:TextRulerFont,NSForegroundColorAttributeName:[UIColor lightGrayColor]};
    CGFloat width = [num boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:0 attributes:attribute context:nil].size.width;
    [num drawInRect:CGRectMake(0-width/2, longLineY+10, width, 16) withAttributes:attribute];
    CGContextAddLineToPoint(context, 0, longLineY);
    CGContextStrokePath(context);//开始绘制
}

@end

/***************DY************分************割************线***********/

typedef enum SCROLL_DIRECTION{
    DIRECTION_LEFT,
    DIRECTION_RIGHT,
}SCROLL_DIRECTION;

static NSNumberFormatter * _objFormatter = nil;
@interface RCTScrollRuler()<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    NSURL *soundFileURL;
}
@property(nonatomic, strong)UILabel         *valueLab;
@property(nonatomic, strong)UILabel         *unitLab;
@property(nonatomic, strong)UICollectionView*collectionView;
@property(nonatomic, strong)UIView          *grayLine;
@property(nonatomic, strong)DYTriangleView  *triangle;
@property(nonatomic, assign)float           realValue;
@property(nonatomic, assign)int           stepNum;//分多少个区
@property(nonatomic, assign)int           minValue;//游标的最小值
@property(nonatomic, assign)int           maxValue;//游标的最大值
@property(nonatomic, assign)int           exponent;
@property(nonatomic, assign)float           exponentFloatValue;
@property(nonatomic, assign)int           step;//间隔值，每两条相隔多少值
@property(nonatomic, assign)NSInteger     betweenNum;
@property(nonatomic, strong)NSString      *unit;//单位
@property (nonatomic,assign)int defaultValue;
@property (nonatomic,assign)int num;
@property(nonatomic, assign)BOOL           isTime;
@property(nonatomic, assign)NSString *markerColor;
@property(nonatomic, assign)NSString *markerTextColor;
@property(nonatomic, strong)NSString *accessbilityText;
@property (assign) SystemSoundID pewPewSound;
@property(nonatomic, assign)int previousRealValue;
@property (nonatomic, strong)AVAudioPlayer *audioPlayer;

@property(nonatomic, strong)UIButton *leftScrollBtn;
@property(nonatomic, strong)UIButton *rightScrollBtn;
@property(nonatomic, strong)NSTimer *timer;
@property(nonatomic, assign)int    currentValue;
@property(nonatomic, assign) SCROLL_DIRECTION direction;
//@property RNRullerAccessbilityElement * theRullerAccessbilityElement;
//@property NSMutableArray *accessbilityElements;
@property(nonatomic, assign)BOOL           isAccesbilityFocused;
@end
@implementation RCTScrollRuler

-(void)reconfigureValues{
    [[self subviews]makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _stepNum    = (_maxValue-_minValue)/_step/_betweenNum + 1;
    _bgColor    = [UIColor greenColor];
    _triangleColor          = [RCTScrollRuler colorFromHexString:_markerColor];
    self.backgroundColor    = [UIColor clearColor];
    
    //[self addSubview:self.unitLab];
    
    
    [self addSubview:self.collectionView];
    [self addSubview:self.triangle];
    
    //NSLog(@"%@",NSStringFromCGRect(self.collectionView.bounds));
    /*if(UIAccessibilityIsVoiceOverRunning() == YES)
    {
        [self addSubview:_leftScrollBtn];
        [self addSubview:_rightScrollBtn];
    }*/
    //[self addSubview:self.grayLine];
    
    [self setExponent:_exponent];
    self.unitLab.text = _unit;
    [self addSubview:self.valueLab];
    
}
- (void)setMinValue:(int)minValue {
    
    _minValue = 0;
    _stepNum = 0;
    [self.collectionView reloadData];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        _minValue = minValue;
        [self reconfigureValues];
        [self.collectionView reloadData];
    });
    
    [self lazyReload];
    // [self calculateDefaultValue];
}

- (void)setMaxValue:(int)maxValue {
    //NSLog(@"setMaxValue");
    _maxValue = maxValue;
    [self reconfigureValues];
}

- (void)setIsTime:(BOOL)isTime {
   
    _isTime = isTime;
    [self reconfigureValues];
    [self calculateDefaultValue];
    
}

- (void)setMarkerColor:(NSString *)markerColor{
    
   
    _markerColor = markerColor;
     [self reconfigureValues];
    //[self reconfigureValues];
    self.valueLab.backgroundColor = [RCTScrollRuler colorFromHexString:_markerColor];
    _triangle.triangleColor     = [UIColor orangeColor];
    [self addTriangleTipToLayer:_valueLab.layer];
    [self bringSubviewToFront:_valueLab];
    
}


- (void)setMarkerTextColor:(NSString *)markerTextColor{
    
    
    _markerTextColor = markerTextColor;
    [self reconfigureValues];
    self.valueLab.backgroundColor = [RCTScrollRuler colorFromHexString:_markerColor];
    self.valueLab.textColor = [RCTScrollRuler colorFromHexString:_markerTextColor];
    //_triangle.triangleColor     = [RCTScrollRuler colorFromHexString:_markerColor];
    _triangle.triangleColor     = [UIColor orangeColor];
    [self addSubview:self.valueLab];
}

- (void)setStep:(float)step {
   
    _step = step;
     [self reconfigureValues];
    [self lazyReload];
}
-(void)lazyReload{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self performSelectorOnMainThread:@selector(scrollToDefaultValue) withObject:nil waitUntilDone:YES];
        
    });
}
- (void)setAccessbilityText:(NSString *)accessbilityText
{
    _accessbilityText = [[NSString alloc] initWithFormat:@"%@",accessbilityText];
       [self postAccessbilityChanged];
}
- (void)setDefaultValue:(int)defaultValue {
    //NSLog(@"setDefaultValue");
     [self reconfigureValues];
}
-(void)calculateDefaultValue{
    
    _defaultValue = roundf(((float)(_maxValue + _minValue)) / 2.0f);
    _currentValue = _defaultValue;
    [self triggerSelectedValue];
    [self updateValueLabel:_currentValue];
}

-(void)scrollToDefaultValue{
    
    /*
     T = ( V * S ) + M
     T-M = V * S
     T-M/S = V
     */
    int skipValue = (_minValue % (10*_step));
    _defaultValue = roundf(((float)(_maxValue + _minValue)) / (2.0f * _step)) * _step;
    
    int value = roundf((float)(_defaultValue - _minValue + skipValue ) / (float)_step);
    if (value < 0) {
        value = 0;
    }
    
    _currentValue = _defaultValue;
    [self triggerSelectedValue];
    [self updateValueLabel:_currentValue];
    
    _collectionView.contentOffset = CGPointMake((value*RulerGap), 0);
    [_collectionView setContentOffset:CGPointMake((value*RulerGap), 0) animated:NO];
    
    
    
    
   // [self accessibilityElementDidBecomeFocused];
    
}

- (void)setExponentValue:(int)exponent {
    //NSLog(@"设置默认值");
    _exponent      = exponent;
}


- (void)setNum:(float)num {
    _num = num;
    [self reconfigureValues];
}

- (void)setBetweenNum:(NSInteger)betweenNum{
    _betweenNum = betweenNum;
    [self reconfigureValues];
}

- (void)setUnit:(NSString *)unit {
    _unit = unit;
    //[self reconfigureValues];
}

-(float)calculateExponentValue:(int)exp{
    
    if(exp == 1){
        return 0.10f;
    }else if (exp == 2){
        return 0.010f;
    }else if (exp == 3){
        return 0.0010f;
    }else if (exp == 4){
        return 0.00010f;
    }else if (exp == 5){
        return 0.000010f;
    }
    return 0.10f;
}


-(instancetype)initWithFrame:(CGRect)frame theMinValue:(float)minValue theMaxValue:(float)maxValue exponent:(int)exponent defaultValue:(float)defaultValue theStep:(float)step theNum:(NSInteger)betweenNum theUnit:unit isTime:(BOOL)isTime markerColor:(NSString*)markerColor markerTextColor:(NSString*)markerTextColor accessbilityText:(NSString*)accessbilityText {
    
    //@"use three finger swipe guesture to increase or decrease by 10 units";
    self = [super initWithFrame:frame];
    if (self) {
        _minValue   = minValue;
        _maxValue   = maxValue;
        _exponent   = exponent;
        _step       = step;
        _unit       = unit;
        _stepNum    = (_maxValue-_minValue)/_step/betweenNum + 1;
        _betweenNum = betweenNum;
        _isTime = isTime;
        _markerColor = markerColor;
        _accessbilityText = accessbilityText;
        markerTextColor = markerTextColor;
        
        _bgColor    = [UIColor clearColor];
        _triangleColor          = [UIColor greenColor];//[RCTScrollRuler colorFromHexString:_markerColor];
        self.backgroundColor    = [UIColor clearColor];
        
        //[self addSubview:self.valueLab];
        //[self addSubview:self.unitLab];
        [self addSubview:self.collectionView];
        [self addSubview:self.triangle];
        [self setupAccessabilityButton];
        //[self addSubview:self.grayLine];
        self.unitLab.text = _unit;
        [self addSubview:self.valueLab];
        self.collectionView.isAccessibilityElement = false;
        self.isAccessibilityElement = YES;
        self.shouldGroupAccessibilityChildren = false;
    }
    return self;
}
-(void)postAccessbilityChanged{
    UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, self);
}
- (NSString *)accessibilityValue{
    return self.valueLab.text;
}
- (void)accessibilityElementDidBecomeFocused
{
    self.isAccesbilityFocused = true;
}
- (void)accessibilityElementDidLoseFocus
{
    self.isAccesbilityFocused = false;
}

- (UIAccessibilityTraits)accessibilityTraits{
    return UIAccessibilityTraitAdjustable;
}

- (void)setAccessibilityTraits:(UIAccessibilityTraits)accessibilityTraits{
    [super setAccessibilityTraits:accessibilityTraits];
}

- (NSString *)accessibilityHint{
    return _accessbilityText;
}

- (void)setAccessibilityHint:(NSString *)accessibilityHint{
    [super setAccessibilityHint:accessibilityHint];
}

- (void)accessibilityDecrement{
    NSLog(@"accessibilityDecrement");
    [self repeatLeft:1];
}

- (void)accessibilityIncrement {
    NSLog(@"accessibilityIncrement");
    [self repeatRight:1];
}
- (BOOL)accessibilityScroll:(UIAccessibilityScrollDirection)direction
{
    NSLog(@"accessibilityScroll");
    if (direction == UIAccessibilityScrollDirectionUp || direction == UIAccessibilityScrollDirectionRight) {
        [self repeatLeft:10];
    }
    else {
        [self repeatRight:10];
        
    }
    
    return YES;
}

//The event handling method
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
    if (soundFileURL == nil) {
        NSString *soundFilePath = [NSString stringWithFormat:@"%@/tickering.mp3",[[NSBundle mainBundle] resourcePath]];
        soundFileURL = [NSURL fileURLWithPath:soundFilePath];
        
    }
    
    if (self.audioPlayer == nil){
        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
    }
    //    player.numberOfLoops = -1; //Infinite
    
    [self.audioPlayer play];
}

-(UIView *)grayLine {
    if (!_grayLine) {
        _grayLine = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_valueLab.frame), self.bounds.size.width, 1)];
        _grayLine.backgroundColor = [UIColor cyanColor];
    }
    return _grayLine;
}

+ (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

- (void) addTriangleTipToLayer: (CALayer *) targetLayer{
    //[targetLayer setBackgroundColor: [UIColor whiteColor].CGColor];
    
    CGFloat side = targetLayer.frame.size.height;
    
    CGPoint startPoint = CGPointMake(targetLayer.frame.size.width / 2 - 20 / 2, side);
    CGPoint endPoint = CGPointMake(targetLayer.frame.size.width / 2 + 20  / 2, side);
    UIBezierPath *trianglePath = [UIBezierPath bezierPath];
    
    CGFloat middleX = targetLayer.frame.size.width / 2;
    CGFloat middleY = (side / 2) * tan(M_PI / 3) + 15;
    CGPoint middlePoint = CGPointMake(middleX, middleY);
    
    [trianglePath moveToPoint:startPoint];
    [trianglePath addLineToPoint:middlePoint];
    [trianglePath addLineToPoint:endPoint];
    [trianglePath closePath];
    
    CAShapeLayer *triangleLayer = [CAShapeLayer layer];
    [triangleLayer setFillColor: [self triangleColor].CGColor];
    [triangleLayer setPath:trianglePath.CGPath];
    [targetLayer addSublayer:triangleLayer];
}

-(DYTriangleView *)triangle{
    if (!_triangle) {
        // _triangle = [[DYTriangleView alloc]initWithFrame:CGRectMake(self.bounds.size.width/2-0.5-TrangleWidth/2, CGRectGetMaxY(_valueLab.frame), TrangleWidth, TrangleWidth)];
        //   _triangle.backgroundColor   = [UIColor clearColor];
        //   _triangle.triangleColor     = _triangleColor;
        _triangle = [[DYTriangleView alloc]initWithFrame:CGRectMake((self.bounds.size.width/2)+9, CGRectGetMaxY(_valueLab.frame), 2, IndicatorHeight)];
        // _triangle.backgroundColor   = [UIColor orangeColor];
        
        // _triangle.triangleColor     = [UIColor orangeColor];//[RCTScrollRuler colorFromHexString:[UIColor orangeColor]];
        _triangle.triangleColor     = [RCTScrollRuler colorFromHexString:_markerColor];
        _triangle.tintColor = [RCTScrollRuler colorFromHexString:_markerColor];
        _triangle.backgroundColor = [RCTScrollRuler colorFromHexString:_markerColor];
        
        UITapGestureRecognizer *singleFingerTap =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(handleSingleTap:)];
        [self addGestureRecognizer:singleFingerTap];
        //[self addTriangleTipToLayer:_valueLab.superview.layer];
        //[self addTriangleTipToLayer:_triangle.layer];
    }
    return _triangle;
}
- (void)voiceOverStatusChanged
{
    //if(!    ())
    {
        //do your changes
        NSLog(@"ACCESSIBILTY: %@",UIAccessibilityIsVoiceOverRunning());
    }
}
-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        [flowLayout setSectionInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_valueLab.frame) + 30, self.bounds.size.width + 20, CollectionHeight) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = _bgColor;
        _collectionView.bounces         = YES;
        _collectionView.showsHorizontalScrollIndicator  = NO;
        _collectionView.showsVerticalScrollIndicator    = NO;
        _collectionView.dataSource      = self;
        _collectionView.delegate        = self;
        _collectionView.contentSize     = CGSizeMake(_stepNum*_step+ScreenWidth/2, CollectionHeight);
        
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"headCell"];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"footerCell"];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"custemCell"];
        
    }
    return _collectionView;
}

-(void)setupAccessabilityButton {
   /* if(UIAccessibilityIsVoiceOverRunning() == YES)
    {
        _leftScrollBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 30, 50, _collectionView.frame.size.height + 0)];
        _rightScrollBtn = [[UIButton alloc]initWithFrame:CGRectMake((self.bounds.size.width+20) - 50, 30, 50, _collectionView.frame.size.height)];
        [_rightScrollBtn setBackgroundColor:[UIColor orangeColor]];
        [_leftScrollBtn setBackgroundColor:[UIColor orangeColor]];
        UIImage *leftBtnImage = [UIImage imageNamed:@"minus.png"];
        [_leftScrollBtn setImage:leftBtnImage forState:UIControlStateNormal];
        UIImage *rightBtnImage = [UIImage imageNamed:@"plus.png"];
        [_rightScrollBtn setImage:rightBtnImage forState:UIControlStateNormal];
        _leftScrollBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        _rightScrollBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(voiceOverStatusChanged)
                                                     name:UIAccessibilityVoiceOverStatusChanged
                                                   object:nil];
        //stopTimer
        //_timer = [NSTimer timerWithTimeInterval:(x) target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
        
        [_rightScrollBtn addTarget:self action:@selector(repeatLeft:) forControlEvents:UIControlEventTouchDown];
        [_leftScrollBtn addTarget:self action:@selector(repeatRight:) forControlEvents:UIControlEventTouchDown];
        
        [_rightScrollBtn addTarget:self action:@selector(stopTimer:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
        [_leftScrollBtn addTarget:self action:@selector(stopTimer:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    }*/
}

-(void)invalidateTimer{
    if(_timer && [_timer isValid]){
        [_timer invalidate];
    }
}
-(void)scheduleTimer{
    /*[self invalidateTimer];
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(scrollCollectionView) userInfo:nil repeats:YES];
    [_timer fire];*/
}
-(void)repeatRight:(int)time{
    _direction = DIRECTION_RIGHT;
    [self scrollCollectionView:time];
}

-(void)stopTimer:(int)time{
    [self invalidateTimer];
}

-(void)repeatLeft:(int)time{
    _direction = DIRECTION_LEFT;
    [self scrollCollectionView:time];
}

- (void)scrollCollectionView:(int)time
{
    
    CGPoint cx = self.collectionView.contentOffset;
    cx.x = _direction == DIRECTION_LEFT ? cx.x - (RulerGap *time) : cx.x + (RulerGap *time);
    [self.collectionView setContentOffset:cx animated:NO];
    
}


-(UILabel *)valueLab{
    if (!_valueLab) {
        _valueLab = [[UILabel alloc]initWithFrame:CGRectMake(self.bounds.size.width/2-40, -20, 100, 40)];
        _valueLab.textColor = [UIColor whiteColor];//[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        _valueLab.adjustsFontSizeToFitWidth = YES;
        
        if(![_markerColor isEqualToString:@"0"]){
            _valueLab.backgroundColor = [RCTScrollRuler colorFromHexString:_markerColor];;
            //_triangle.triangleColor     = [RCTScrollRuler colorFromHexString:_markerColor];
            _triangle.triangleColor     = [UIColor orangeColor];
        }
        [self addTriangleTipToLayer:_valueLab.layer];
        [_valueLab setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
        _valueLab.textAlignment = NSTextAlignmentCenter;
    }
    return _valueLab;
}

-(UILabel *)unitLab{
    if (!_unitLab) {
        _unitLab = [[UILabel alloc]initWithFrame:CGRectMake(self.bounds.size.width/2+10, 4, 40, 30)];
        //_unitLab.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        _unitLab.textColor = [UIColor greenColor];
        [_unitLab setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13]];
        _unitLab.textAlignment = NSTextAlignmentLeft;
    }
    return _unitLab;
}

-(void)setBgColor:(UIColor *)bgColor{
    _bgColor = bgColor;
    _collectionView.backgroundColor = _bgColor;
}
-(void)setTriangleColor:(UIColor *)triangleColor{
    _triangleColor = triangleColor;
    // _triangleColor = [UIColor yellowColor];
    _triangle.triangleColor = _triangleColor;
}

-(void)setRealValue:(float)realValue{
    [self setRealValue:realValue animated:NO];
}
-(void)setRealValue:(float)realValue animated:(BOOL)animated{
    _realValue      = realValue;
    int n = _realValue*_step+_minValue;
    if (n == 0) {
        _unitLab.hidden = YES;
        if(_isTime == true){
            _valueLab.text = @"0:00";
        }else{
            _valueLab.text = @"0";
        }
        
    } else {
        _unitLab.hidden = NO;
        //_valueLab.text = [NSString stringWithFormat:@"%d", n];
    }
    //int initalPadding = realValue == 0 ? 0: 0;
    
    //[_collectionView setContentOffset:CGPointMake((realValue*RulerGap), 0) animated:animated];
    [self scrollToExactPosition];
}


-(void)scrollToExactPosition{
    int offset = _collectionView.contentOffset.x;
    int value = _collectionView.contentOffset.x/RulerGap;
    //[Pull request test]
    //value = value -skipValue;
    int skipValue = (_minValue % (10*_step));
    int totalValue = value*_step + (_minValue-skipValue);
    //int maxValue = skipValue/_step * RulerGap;
    //(((skipValue)) * RulerGap ) / _step;
    int maxValue = (((totalValue-_minValue+skipValue)) * RulerGap ) / _step;
    [_collectionView setContentOffset:CGPointMake(maxValue, 0) animated:NO];
    
}

+(CGFloat)rulerViewHeight{
    return CollectionHeight;
}

#pragma mark UICollectionViewDataSource & Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 3+_stepNum + [self skippingValue];
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    int newcount = _stepNum + [self skippingValue] ;
    
    if (indexPath.item == 0){
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"headCell" forIndexPath:indexPath];
        DYHeaderRulerView *headerView = [cell.contentView viewWithTag:1000];
        if (!headerView){
            headerView = [[DYHeaderRulerView alloc]initWithFrame:CGRectMake(0, 20, self.frame.size.width/2, CollectionHeight - 10)];
            headerView.backgroundColor  =  [UIColor clearColor];
            headerView.tag              =  1000;
            headerView.minValue         = _minValue;
            //headerView.backgroundColor = UIColor.redColor;
            [cell.contentView addSubview:headerView];
        }
        return cell;
        
    }else if( indexPath.item == newcount +1){
        
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"footerCell" forIndexPath:indexPath];
        DYFooterRulerView *footerView = [cell.contentView viewWithTag:1001];
        if (!footerView){
            footerView = [[DYFooterRulerView alloc]initWithFrame:CGRectMake(50, 20, self.frame.size.width/2, CollectionHeight - 10)];
            footerView.backgroundColor  = [UIColor clearColor];
            footerView.tag              = 1001;
            footerView.maxValue         = _maxValue;
            [cell.contentView addSubview:footerView];
        }
        return cell;
        
    }else{
        
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"custemCell" forIndexPath:indexPath];
        DYRulerView *rulerView = [cell.contentView viewWithTag:1002];
        if (!rulerView){
            rulerView  = [[DYRulerView alloc]initWithFrame:CGRectMake(0, 10, RulerGap*_betweenNum, CollectionHeight - 10)];
            rulerView.tag               = 1002;
            rulerView.step              = _step;
            rulerView.betweenNumber     = _betweenNum;
            rulerView.markerColor = _markerColor;
            // rulerView.backgroundColor  = [UIColor whiteColor];
            [cell.contentView addSubview:rulerView];
        }
        
        rulerView.backgroundColor   =  [UIColor whiteColor];
        rulerView.minValue = (int)(_step*(indexPath.item-1)*_betweenNum+_minValue);
        rulerView.maxValue = (int)(_step*indexPath.item*_betweenNum);
        rulerView.totalMaxValue = _maxValue;
        rulerView.baseMinValue = _minValue;
        rulerView.betweenNumber = _betweenNum;
        rulerView.defaultValue = (int)(_defaultValue);
        rulerView.exponent = _exponent;
        rulerView.step              = _step;
        rulerView.markerColor = _markerColor;
        rulerView.isTime = _isTime;
        rulerView.row               = indexPath.item-1;
        rulerView.totalRows         = newcount;
        [rulerView setNeedsDisplay];
        
        return cell;
    }
}

-(CGSize )collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == 0 || indexPath.item == _stepNum+1){
        
        return CGSizeMake(self.frame.size.width/2, CollectionHeight);
    }else{
        //NSLog(@"LARGE LINE");
        return CGSizeMake(RulerGap*_betweenNum, CollectionHeight);
    }
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0.f;
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0.f;
}

#pragma mark play sound



- (void)playSystemSound {
    AudioServicesPlaySystemSound(self.pewPewSound);
}
-(void)playAudio:(int)realValue{
    
    if (self.previousRealValue != realValue){
        self.previousRealValue = realValue;
        // NSLog(@"%@",[[NSBundle mainBundle] resourcePath]);
        if (soundFileURL == nil) {
            NSString *soundFilePath = [NSString stringWithFormat:@"%@/tickering.mp3",[[NSBundle mainBundle] resourcePath]];
            soundFileURL = [NSURL fileURLWithPath:soundFilePath];
            
        }
        
        if (self.audioPlayer == nil){
            self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
        }
        //    player.numberOfLoops = -1; //Infinite
        
        [self.audioPlayer play];
    }else{
        //NSLog(@"already there!");
    }
}

-(void)triggerSelectedValue{
    
    if((_currentValue >= _minValue)&&(_currentValue <= _maxValue)){
        if (self.delegate && [self.delegate respondsToSelector:@selector(dyScrollRulerView:valueChange:exponent: exponentFValue:)]) {
            
            [self.delegate dyScrollRulerView:self valueChange:_currentValue exponent:_exponent exponentFValue:_exponentFloatValue];
            
        }
    }
}

#pragma mark -UIScrollViewDelegate
+(NSString *)getFormattedString:(int) toValue exponent:(int)exponent{
    
    NSNumberFormatter *formatter = _objFormatter;
    if (_objFormatter == nil) {
        _objFormatter = [[NSNumberFormatter alloc] init];
        formatter = _objFormatter;
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle]; // this line is important!
        [formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"de_DE"]];
        formatter.usesGroupingSeparator = YES;
        formatter.currencyGroupingSeparator = @".";
    }
    
    if(exponent > 0){
        [formatter setMinimumFractionDigits:exponent];
        [formatter setMaximumFractionDigits:exponent];
        double decimal = exponent == 1 ? 10.f : (exponent == 2 ? 100.f : exponent == 3 ? 1000.f : exponent == 4 ? 10000.f : 0.0f);
        double newValue = toValue;
        newValue = toValue/decimal;
        
        return [formatter stringFromNumber:[NSNumber numberWithDouble:newValue]];
    }
    else {
        [formatter setMinimumFractionDigits:0];
        [formatter setMaximumFractionDigits:0];
        
        return [formatter stringFromNumber:[NSNumber numberWithInt:toValue]];
    }
    
}
-(void)updateValueLabel:(int)totalValue{
    _currentValue = totalValue;
    if(_isTime == true){
        if (totalValue >= _maxValue) {
            _currentValue = _maxValue;
            int minutes =  floor(_maxValue / 60);
            int seconds = _maxValue - minutes * 60;
            NSString * secStr = (seconds < 10) ? [NSString stringWithFormat:@"0%d",seconds] :  [NSString stringWithFormat:@"%d",seconds];
            _valueLab.text = [NSString stringWithFormat:@"%d:%@", minutes, secStr];
        }else if(totalValue <= _minValue){
            _currentValue = _minValue;
            if(_minValue == 0) {
                _valueLab.text = @"0:00";
            } else {
                //_valueLab.text = [NSString stringWithFormat:@"%d",_minValue];
                int minutes =  floor(_minValue / 60);
                int seconds = _minValue - minutes * 60;
                NSString * secStr = (seconds < 10) ? [NSString stringWithFormat:@"0%d",seconds] :  [NSString stringWithFormat:@"%d",seconds];
                _valueLab.text = [NSString stringWithFormat:@"%d:%@", minutes, secStr];
            }
        }else{
            
            int minutes =  floor(totalValue/ 60);
            int seconds = totalValue - minutes * 60;
            NSString * secStr = (seconds < 10) ? [NSString stringWithFormat:@"0%d",seconds] :  [NSString stringWithFormat:@"%d",seconds];
            _valueLab.text = [NSString stringWithFormat:@"%d:%@", minutes, secStr];
            
        }
    }else{
        
        if(_exponent > 0){
            _exponentFloatValue = [self calculateExponentValue:_exponent];
        }else{
            _exponentFloatValue = 1;
        }
        
        if (totalValue >= _maxValue) {
            _currentValue = _maxValue;
            _valueLab.text = [RCTScrollRuler getFormattedString:_maxValue exponent:_exponent];
            //[self getFormattedString:_maxValue ];
            
        }else if(totalValue <= _minValue){
            _currentValue = _minValue;
            if(_minValue == 0) {
                _valueLab.text = @"0";
            } else {
                _valueLab.text = [RCTScrollRuler getFormattedString:_minValue exponent:_exponent];
                
            }
        }else{
            _valueLab.text = [RCTScrollRuler getFormattedString:totalValue exponent:_exponent];
        }
    }
    if(self.isAccesbilityFocused){
    UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, // announce
                                    _valueLab.text);
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int offset = scrollView.contentOffset.x;
    int value = scrollView.contentOffset.x/RulerGap;
    //[Pull request test]
    //value = value -skipValue;
    int skipValue = (_minValue % (10*_step));
    int totalValue = value*_step + (_minValue-skipValue);
    
    //totalValue -= skipValue;
    
    [self playAudio:totalValue];
    if((totalValue >= _minValue)&&(totalValue <= _maxValue)){
        if (self.delegate && [self.delegate respondsToSelector:@selector(dyScrollRulerView:valueChange:exponent: exponentFValue:)]) {
            
            if(UIAccessibilityIsVoiceOverRunning() == YES)
            {
                [self.delegate dyScrollRulerView:self valueChange:totalValue exponent:_exponent exponentFValue:_exponentFloatValue];
                
            }
        }
    }else{
        if(totalValue > _maxValue){
            int maxValue = (((_maxValue-_minValue+skipValue)) * RulerGap ) / _step;
            [scrollView setContentOffset:CGPointMake(maxValue, 0) animated:NO];
        }
        else  if(totalValue < _minValue){
            int maxValue = skipValue/_step * RulerGap;
            //(((skipValue)) * RulerGap ) / _step;
            [scrollView setContentOffset:CGPointMake(maxValue, 0) animated:NO];
        }
    }
    _scrollByHand = YES;
    if (_scrollByHand) {
        /*if((_currentValue >= _minValue)&&(_currentValue <= _maxValue)){
         _currentValue = totalValue;
         }*/
        
        [self updateValueLabel:totalValue];
    }else{
        // _valueLab.text = [NSString stringWithFormat:@"%d",_defaultValue];
    }
   // _rightScrollBtn.accessibilityLabel = _valueLab.text;
   // _leftScrollBtn.accessibilityLabel = _valueLab.text;
}

-(int)skippingValue{
    return (_minValue % (10*_step)) > 0 ? 1 : 0;
}
-(int)getContentOffset:(UIScrollView *)scrollView{
    int value = scrollView.contentOffset.x/(float)RulerGap;
    int skipValue = (_minValue % (5*_step));
    return  value - 0;
    
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{//拖拽时没有滑动动画
    if (!decelerate){
        int value = [self getContentOffset:scrollView];
        [self setRealValue:value animated:YES];
        [self triggerSelectedValue];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    int value = [self getContentOffset:scrollView];
    
    [self setRealValue:round(value) animated:NO];
    [self triggerSelectedValue];
    
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int value = [self getContentOffset:scrollView];
    
    [self setRealValue:round(value) animated:YES];
    [self triggerSelectedValue];
    
}

-(BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView{
    return false;
}

@end
