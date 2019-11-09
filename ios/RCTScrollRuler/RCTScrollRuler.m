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
    
    //        CGContextAddLineToPoint(context, TrangleWidth, 0);
    //
    //        CGContextAddLineToPoint(context, TrangleWidth/2.0, TrangleWidth/2.0);
    //        CGContextSetLineCap(context, kCGLineCapButt);//线结束时是否绘制端点，该属性不设置。有方形，圆形，自然结束3中设置
    //        CGContextSetLineJoin(context, kCGLineJoinBevel);//线交叉时设置缺角。有圆角，尖角，缺角3中设置
    //
    //        CGContextClosePath(context);//路径结束标志，不写默认封闭
    
    // [_triangleColor setFill];//设置填充色
    // [_triangleColor setStroke];//设置边框色
    //        CGContextSetStrokeColorWithColor(context, [UIColor greenColor].CGColor);
    //        CGContextSetStrokeColorWithColor(context, [UIColor greenColor].CGColor);
    //        CGContextDrawPath(context, kCGPathFillStroke);//绘制路径path，后属性表示填充
    //
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
    
    if(isTime == true){
        
        for (int i = 0; i <= _betweenNumber; i ++){
            
            CGContextMoveToPoint(context, startX+lineCenterX*i, topY);
            int tempInt = (int)(i * _step) + _minValue;
            if(tempInt > _totalMaxValue){
                return;
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
            int stepInt = (int)_step;
            
            if ((tempInt%(_betweenNumber*stepInt) == 0)||(tempInt == _totalMaxValue)||(tempInt == _baseMinValue)){
                
                if(exponent > 0){
                    exponentFloatValue = [self calculateExponentValue:exponent];
                }else{
                    exponentFloatValue = 1;
                }
                NSString *num;
                if(exponent > 0){
                    NSString *formatStr = exponent == 1 ? @"%.1f" : (exponent == 2 ? @"%.2f" : exponent == 3 ? @"%.3f" : exponent == 4 ? @"%.4f" : @"");
                    num = [NSString stringWithFormat:formatStr, (float)(i * (_step) + _minValue) * exponentFloatValue];
                    
                }else{
                    
                    num = [NSString stringWithFormat:@"%d", (int)(i * (_step) + _minValue)];
                    
                }
                
                
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
                    predictedX = (startX+lineCenterX*i-width/2)-width/2;
                }
                
                [num drawInRect:CGRectMake(predictedX, longLineY-14, width, 16) withAttributes:attribute];
                CGContextMoveToPoint(context, startX+lineCenterX*i, topY);
                CGContextSetStrokeColorWithColor(context, [RCTScrollRuler colorFromHexString:@"#999999"].CGColor);
                CGContextAddLineToPoint(context, startX+lineCenterX*i, longLineY);
            }else if(tempInt%(5) == 0){
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

@interface RCTScrollRuler()<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

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
@property (assign) SystemSoundID pewPewSound;
@property(nonatomic, assign)int previousRealValue;
@property (nonatomic, strong)AVAudioPlayer *audioPlayer;

@end
@implementation RCTScrollRuler

- (void)setMinValue:(int)minValue {
    
    [[self subviews]makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _minValue = minValue;
    
    _stepNum    = (_maxValue-_minValue)/_step/_betweenNum + 1;
    _bgColor    = [UIColor greenColor];
    _triangleColor          = [RCTScrollRuler colorFromHexString:_markerColor];
    self.backgroundColor    = [UIColor clearColor];
    
    //[self addSubview:self.unitLab];
    [self addSubview:self.collectionView];
    [self addSubview:self.triangle];
    //[self addSubview:self.grayLine];
    [self setDefaultValue:_defaultValue];
    [self setExponent:_exponent];
    self.unitLab.text = _unit;
    [self addSubview:self.valueLab];
}

- (void)setMaxValue:(int)maxValue {
    
    [[self subviews]makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _maxValue = maxValue;
    _stepNum    = (_maxValue-_minValue)/_step/_betweenNum+1;
    _bgColor    = [UIColor clearColor];
    _triangleColor          = [RCTScrollRuler colorFromHexString:_markerColor];
    self.backgroundColor    = [UIColor clearColor];
    
    // [self addSubview:self.valueLab];
    [self addSubview:self.unitLab];
    [self addSubview:self.collectionView];
    [self addSubview:self.triangle];
    // [self addSubview:self.grayLine];
    [self setDefaultValue:_defaultValue];
    [self setExponent:_exponent];
    self.unitLab.text = _unit;
    [self addSubview:self.valueLab];
}

- (void)setIsTime:(BOOL)isTime {
    
    [[self subviews]makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _isTime = isTime;
    _stepNum    = (_maxValue-_minValue)/_step/_betweenNum + 1;
    _bgColor    = [UIColor clearColor];
    _triangleColor         = [RCTScrollRuler colorFromHexString:_markerColor];
    self.backgroundColor    = [UIColor clearColor];
    
    //[self addSubview:self.valueLab];
    [self addSubview:self.unitLab];
    [self addSubview:self.collectionView];
    [self addSubview:self.triangle];
    // [self addSubview:self.grayLine];
    [self setDefaultValue:_defaultValue];
    [self setExponent:_exponent];
    self.unitLab.text = _unit;
    [self addSubview:self.valueLab];
}

- (void)setMarkerColor:(NSString *)markerColor{
    [[self subviews]makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    _markerColor = markerColor;
    
    _stepNum    = (_maxValue-_minValue)/_step/_betweenNum + 1;
    _bgColor    = [UIColor clearColor];
    
    _triangleColor          = [RCTScrollRuler colorFromHexString:_markerColor];
    self.backgroundColor    = [UIColor clearColor];
    
    //[self addSubview:self.valueLab];
    [self addSubview:self.unitLab];
    [self addSubview:self.collectionView];
    [self addSubview:self.triangle];
    // [self addSubview:self.grayLine];
    [self setDefaultValue:_defaultValue];
    [self setExponent:_exponent];
    self.unitLab.text = _unit;
    self.valueLab.backgroundColor = [RCTScrollRuler colorFromHexString:_markerColor];
    //self.valueLab.textColor = [RCTScrollRuler colorFromHexString:_markerTextColor];
    //_triangle.triangleColor     = [RCTScrollRuler colorFromHexString:_markerColor];
    _triangle.triangleColor     = [UIColor orangeColor];
    [self addTriangleTipToLayer:_valueLab.layer];
    [self bringSubviewToFront:_valueLab];
    [self addSubview:self.valueLab];
}


- (void)setMarkerTextColor:(NSString *)markerTextColor{
    
    [[self subviews]makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    _markerTextColor = markerTextColor;
    
    _stepNum    = (_maxValue-_minValue)/_step/_betweenNum + 1;
    _bgColor    = [UIColor clearColor];
    _triangleColor          = [RCTScrollRuler colorFromHexString:_markerColor];
    self.backgroundColor    = [UIColor clearColor];
    
    // [self addSubview:self.valueLab];
    [self addSubview:self.unitLab];
    [self addSubview:self.collectionView];
    [self addSubview:self.triangle];
    // [self addSubview:self.grayLine];
    [self setDefaultValue:_defaultValue];
    [self setExponent:_exponent];
    self.unitLab.text = _unit;
    self.valueLab.backgroundColor = [RCTScrollRuler colorFromHexString:_markerColor];
    self.valueLab.textColor = [RCTScrollRuler colorFromHexString:_markerTextColor];
    //_triangle.triangleColor     = [RCTScrollRuler colorFromHexString:_markerColor];
    _triangle.triangleColor     = [UIColor orangeColor];
    [self addSubview:self.valueLab];
}

- (void)setStep:(float)step {
    
    [[self subviews]makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _step = step;
    _stepNum    = (_maxValue-_minValue)/_step/_betweenNum + 1;
    _bgColor    = [UIColor clearColor];
    _triangleColor          = [RCTScrollRuler colorFromHexString:_markerColor];
    self.backgroundColor    = [UIColor clearColor];
    
    // [self addSubview:self.valueLab];
    [self addSubview:self.unitLab];
    [self addSubview:self.collectionView];
    [self addSubview:self.triangle];
    // [self addSubview:self.grayLine];
    [self setDefaultValue:_defaultValue];
    [self setExponent:_exponent];
    self.unitLab.text = _unit;
    [self addSubview:self.valueLab];
}

- (void)setDefaultValue:(int)defaultValue {
    
    _defaultValue      = defaultValue;
    if (_maxValue != 0) {
        [self setRealValue:defaultValue];
        [_collectionView setContentOffset:CGPointMake(((defaultValue-_minValue)/(float)_step)*RulerGap, 0) animated:YES];
    }
    //NSLog(@"setDefaultValue被调用了，defaultValue=%.2f", defaultValue);
}

- (void)setExponentValue:(int)exponent {
    //NSLog(@"设置默认值");
    _exponent      = exponent;
}


- (void)setNum:(float)num {
    //NSLog(@"设置间隔");
    [[self subviews]makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _num = num;
    _stepNum    = (_maxValue-_minValue)/_step/_betweenNum + 1;
    _bgColor    = [UIColor clearColor];
    //_triangleColor         = [UIColor yellowColor];// //_triangleColor          = [RCTScrollRuler colorFromHexString:_markerColor];
    self.backgroundColor    = [UIColor clearColor];
    
    //[self addSubview:self.valueLab];
    // [self addSubview:self.unitLab];
    [self addSubview:self.collectionView];
    //[self addSubview:self.triangle];
    //[self addSubview:self.grayLine];
    [self setDefaultValue:_defaultValue];
    [self setExponent:_exponent];
    self.unitLab.text = _unit;
    [self addSubview:self.valueLab];
}

- (void)setBetweenNum:(NSInteger)betweenNum{
    
    [[self subviews]makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _betweenNum = betweenNum;
    _stepNum    = (_maxValue-_minValue)/_step/_betweenNum + 1;
    _bgColor    = [UIColor clearColor];
    self.backgroundColor    = [UIColor clearColor];
    [self addSubview:self.collectionView];
    [self setDefaultValue:_defaultValue];
    [self setExponent:_exponent];
    self.unitLab.text = _unit;
    [self addSubview:self.valueLab];
}

- (void)setUnit:(NSString *)unit {
    //NSLog(@"设置单位");
    [[self subviews]makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _unit = unit;
    _stepNum    = (_maxValue-_minValue)/_step/_betweenNum;
    _bgColor    = [UIColor clearColor];
    //_triangleColor         = [UIColor redColor];// = [RCTScrollRuler colorFromHexString:_markerColor];
    self.backgroundColor    = [UIColor clearColor];
    
    //[self addSubview:self.valueLab];
    // [self addSubview:self.unitLab];
    [self addSubview:self.collectionView];
    //[self addSubview:self.triangle];
    //[self addSubview:self.grayLine];
    [self setDefaultValue:_defaultValue];
    [self setExponent:_exponent];
    self.unitLab.text = _unit;
    [self addSubview:self.valueLab];
}

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


-(instancetype)initWithFrame:(CGRect)frame theMinValue:(float)minValue theMaxValue:(float)maxValue exponent:(int)exponent defaultValue:(float)defaultValue theStep:(float)step theNum:(NSInteger)betweenNum theUnit:unit isTime:(BOOL)isTime markerColor:(NSString*)markerColor markerTextColor:(NSString*)markerTextColor {
    
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
        markerTextColor = markerTextColor;
        
        _bgColor    = [UIColor clearColor];
        _triangleColor          = [UIColor greenColor];//[RCTScrollRuler colorFromHexString:_markerColor];
        self.backgroundColor    = [UIColor clearColor];
        
        //[self addSubview:self.valueLab];
        //[self addSubview:self.unitLab];
        [self addSubview:self.collectionView];
        [self addSubview:self.triangle];
        //[self addSubview:self.grayLine];
        self.unitLab.text = _unit;
        [self addSubview:self.valueLab];
    }
    return self;
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
        //[self addTriangleTipToLayer:_valueLab.superview.layer];
        //[self addTriangleTipToLayer:_triangle.layer];
    }
    return _triangle;
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
-(UILabel *)valueLab{
    if (!_valueLab) {
        _valueLab = [[UILabel alloc]initWithFrame:CGRectMake(self.bounds.size.width/2-30, -20, 80, 40)];
        _valueLab.textColor = [UIColor whiteColor];//[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        
        //set the label to fit text content before rendered as a image
        //[_valueLab sizeToFit];
        
        //        UIBezierPath* trianglePath = [UIBezierPath bezierPath];
        //        [trianglePath moveToPoint:CGPointMake(_valueLab.frame.size.height, _valueLab.frame.size.height)];
        //        [trianglePath addLineToPoint:CGPointMake(_valueLab.frame.size.width/4,_valueLab.frame.size.height)];
        //        [trianglePath addLineToPoint:CGPointMake(_valueLab.frame.size.width/4,_valueLab.frame.size.width - 10.0f)];
        //
        //        //Draw Line
        ////        [trianglePath addLineToPoint:CGPointMake(120.0f,200.0f)];
        ////        [trianglePath addLineToPoint:CGPointMake(100.0f,250.0f)];
        ////        [trianglePath addLineToPoint:CGPointMake(80.0f,200.0f)];
        ////
        ////        [trianglePath addLineToPoint:CGPointMake(0.0f,200.0f)];
        //
        //        CAShapeLayer *triangleMaskLayer = [CAShapeLayer layer];
        //        triangleMaskLayer.fillColor = [UIColor blueColor].CGColor;
        //        [triangleMaskLayer setPath:trianglePath.CGPath];
        //
        //        [_valueLab.layer addSublayer:triangleMaskLayer];
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
    int initalPadding = realValue == 0 ? 0: 0;
    [_collectionView setContentOffset:CGPointMake((realValue*RulerGap)+initalPadding, 0) animated:animated];
}

+(CGFloat)rulerViewHeight{
    return CollectionHeight;
}

#pragma mark UICollectionViewDataSource & Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    
    return 2+_stepNum;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
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
        
    }else if( indexPath.item == _stepNum +1){
        
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
        
        rulerView.markerColor = _markerColor;
        rulerView.isTime = _isTime;
        rulerView.row               = indexPath.item-1;
        rulerView.totalRows         = _stepNum;
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
        NSString *soundFilePath = [NSString stringWithFormat:@"%@/tickering.mp3",[[NSBundle mainBundle] resourcePath]];
        NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
        
        if (self.audioPlayer == nil){
            self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
        }
        //    player.numberOfLoops = -1; //Infinite
        
        [self.audioPlayer play];
    }else{
        //NSLog(@"already there!");
    }
}


#pragma mark -UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int value = scrollView.contentOffset.x/RulerGap;
    //NSLog(@"%d , %f , %d, %d", RulerGap, scrollView.contentOffset.x, _step, value);
    int totalValue = value*_step +_minValue;
    [self playAudio:totalValue];
    if((totalValue >= _minValue)&&(totalValue <= _maxValue)){
        if (self.delegate && [self.delegate respondsToSelector:@selector(dyScrollRulerView:valueChange:exponent: exponentFValue:)]) {
            [self.delegate dyScrollRulerView:self valueChange:totalValue exponent:_exponent exponentFValue:_exponentFloatValue];
            
        }
    }else{
        if(totalValue > _maxValue){
            [scrollView setContentOffset:CGPointMake((_maxValue - _minValue) * RulerGap / _step, 0) animated:NO];
        }
    }
    _scrollByHand = YES;
    if (_scrollByHand) {
        if(_isTime == true){
            if (totalValue >= _maxValue) {
                int minutes =  floor(_maxValue / 60);
                int seconds = _maxValue - minutes * 60;
                _valueLab.text = [NSString stringWithFormat:@"%d:%d", minutes, seconds];
            }else if(totalValue <= _minValue){
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
                
                int minutes =  floor((value + _minValue)/ 60);
                int seconds = (value + _minValue) - minutes * 60;
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
                if(_exponent > 0){
                    NSString *formatStr = _exponent == 1 ? @"%.1f" : (_exponent == 2 ? @"%.2f" : _exponent == 3 ? @"%.3f" : _exponent == 4 ? @"%.4f" : @"");
                    _valueLab.text = [NSString stringWithFormat:formatStr,_maxValue * _exponentFloatValue];
                }else{
                    _valueLab.text = [NSString stringWithFormat:@"%d",_maxValue];
                }
                
            }else if(totalValue <= _minValue){
                if(_minValue == 0) {
                    _valueLab.text = @"0";
                } else {
                    
                    if(_exponent > 0){
                        NSString *formatStr = _exponent == 1 ? @"%.1f" : (_exponent == 2 ? @"%.2f" : _exponent == 3 ? @"%.3f" : _exponent == 4 ? @"%.4f" : @"");
                        
                        _valueLab.text = [NSString stringWithFormat:formatStr,_minValue * _exponentFloatValue];
                    }else{
                        _valueLab.text = [NSString stringWithFormat:@"%d",_minValue];
                    }
                }
            }else{
                if(_exponent > 0){
                    NSString *formatStr = _exponent == 1 ? @"%.1f" : (_exponent == 2 ? @"%.2f" : _exponent == 3 ? @"%.3f" : _exponent == 4 ? @"%.4f" : @"");
                    
                    // _valueLab.text = [NSString stringWithFormat:formatStr,(value*_step) * _exponentFloatValue +_minValue];
                    _valueLab.text = [NSString stringWithFormat:formatStr,(value*_step) * _exponentFloatValue + _minValue * _exponentFloatValue];
                }else{
                    
                    _valueLab.text = [NSString stringWithFormat:@"%d",(value*_step)  +_minValue];
                }
            }
        }
    }else{
        // _valueLab.text = [NSString stringWithFormat:@"%d",_defaultValue];
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{//拖拽时没有滑动动画
    if (!decelerate){
        [self setRealValue:round(scrollView.contentOffset.x/(RulerGap)) animated:YES];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int value = scrollView.contentOffset.x/RulerGap;
    [self setRealValue:round(value) animated:YES];
}

-(BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView{
    return false;
}

@end
