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

#define RulerGap        12 //单位距离
#define RulerLong       35
#define IndicatorHeight  79
#define RulerShort      20
#define TrangleWidth    16
#define CollectionHeight 70

#import "RCTScrollRuler.h"
#import <CoreGraphics/CoreGraphics.h>
#import <AVFoundation/AVFoundation.h>
/**
 *  绘制三角形标示
 */
@interface DYTriangleView : UIView
@property(nonatomic,strong)UIColor *triangleColor;

@end
@implementation DYTriangleView

-(void)drawRect:(CGRect)rect{
    //设置背景颜色
    [[UIColor clearColor]set];
    
    UIRectFill([self bounds]);
    
    //拿到当前视图准备好的画板
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
@property (nonatomic,assign)BOOL isTime;
@property (nonatomic,assign)NSString *markerColor;
@property (nonatomic,assign)NSString *markerTextColor;
@property (nonatomic,assign)float step;

@end
@implementation DYRulerView
@synthesize isTime;

-(void)drawRect:(CGRect)rect{
    CGFloat startX = 0;
    CGFloat lineCenterX = RulerGap;
    CGFloat shortLineY  = rect.size.height - RulerShort;
    CGFloat longLineY = rect.size.height - RulerLong;
    CGFloat topY = rect.size.height;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, (float)192/255.0, (float)192/255.0, (float)192/255.0, 1.0);//设置线的颜色，默认是黑色
    CGContextSetLineWidth(context, 1);//设置线的宽度，
    CGContextSetLineCap(context, kCGLineCapButt);
    
    if(isTime == true){
        for (int i = 0; i <= _betweenNumber; i ++){
            CGContextMoveToPoint(context, startX+lineCenterX*i, topY);
            if (i%_betweenNumber == 0){
                int numeric = (int)(i * _step) + _minValue;
                
                int minutes =  floor(numeric / 60);
                int seconds = numeric - minutes * 60;
                NSString * secStr = (seconds < 10) ? [NSString stringWithFormat:@"0%d",seconds] :  [NSString stringWithFormat:@"%d",seconds];
                NSString *num = [NSString stringWithFormat:@"%d:%@", minutes, secStr];
                //NSString *num = [NSString stringWithFormat:@"%d:%d", minutes, seconds];
                NSLog(@"Num: %@, Step : %f, Min : %d, i: %d ",num, _step, _minValue, i );
                if ([num isEqualToString:@"0"]||[num isEqualToString:@"0:00"]) {
                    num = @"";
                }
                
                
                NSDictionary *attribute = @{NSFontAttributeName:TextRulerFont, NSForegroundColorAttributeName:[UIColor blackColor]};
                
                CGFloat width = [num boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:0 attributes:attribute context:nil].size.width;
                [num drawInRect:CGRectMake(startX+lineCenterX*i-width/2, longLineY-14, width, 16) withAttributes:attribute];
                CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
                CGContextAddLineToPoint(context, startX+lineCenterX*i, longLineY);
            }else{
                CGContextAddLineToPoint(context, startX+lineCenterX*i, shortLineY);
            }
            CGContextStrokePath(context);//开始绘制
        }
    }else{
        for (int i = 0; i <= _betweenNumber; i ++){
            CGContextMoveToPoint(context, startX+lineCenterX*i, topY);
            if (i%_betweenNumber == 0){
                NSString *num = [NSString stringWithFormat:@"%d", (int)(i * _step) + _minValue];
                if ([num isEqualToString:@"0"]) {
                    num = @"";
                }
                
                NSDictionary *attribute = @{NSFontAttributeName:TextRulerFont, NSForegroundColorAttributeName:[UIColor blackColor]};
                CGFloat width = [num boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:0 attributes:attribute context:nil].size.width;
                [num drawInRect:CGRectMake(startX+lineCenterX*i-width/2, longLineY-14, width, 16) withAttributes:attribute];
                CGContextAddLineToPoint(context, startX+lineCenterX*i, longLineY);
            }else{
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
    CGContextSetLineWidth(context, 1.0);
    CGContextSetLineCap(context, kCGLineCapButt);
    
    CGContextMoveToPoint(context, 0, 0);//起始点
    NSString *num = [NSString stringWithFormat:@"%d",_maxValue];
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
@property(nonatomic, assign)int           step;//间隔值，每两条相隔多少值
@property(nonatomic, assign)NSInteger     betweenNum;
@property(nonatomic, strong)NSString      *unit;//单位
@property (nonatomic,assign)int defaultValue;
@property (nonatomic,assign)int num;
@property(nonatomic, assign)BOOL           isTime;
@property(nonatomic, assign)NSString *markerColor;
@property(nonatomic, assign)NSString *markerTextColor;
@end
@implementation RCTScrollRuler

- (void)setMinValue:(int)minValue {
    NSLog(@"设置最小值");
    [[self subviews]makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _minValue = minValue;
    
    _stepNum    = (_maxValue-_minValue)/_step/_betweenNum;
    _bgColor    = [UIColor whiteColor];
    _triangleColor          = [RCTScrollRuler colorFromHexString:_markerColor];
    self.backgroundColor    = [UIColor whiteColor];
    
    
    
    [self addSubview:self.unitLab];
    [self addSubview:self.collectionView];
    [self addSubview:self.triangle];
    //[self addSubview:self.grayLine];
    [self setDefaultValue:_defaultValue];
    self.unitLab.text = _unit;
    [self addSubview:self.valueLab];
}

- (void)setMaxValue:(int)maxValue {
    NSLog(@"设置最大值");
    [[self subviews]makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _maxValue = maxValue;
    _stepNum    = (_maxValue-_minValue)/_step/_betweenNum;
    _bgColor    = [UIColor whiteColor];
    _triangleColor          = [RCTScrollRuler colorFromHexString:_markerColor];
    self.backgroundColor    = [UIColor whiteColor];
    
    // [self addSubview:self.valueLab];
    [self addSubview:self.unitLab];
    [self addSubview:self.collectionView];
    [self addSubview:self.triangle];
    // [self addSubview:self.grayLine];
    [self setDefaultValue:_defaultValue];
    self.unitLab.text = _unit;
    [self addSubview:self.valueLab];
}

- (void)setIsTime:(BOOL)isTime {
    NSLog(@"设置最大值");
    [[self subviews]makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _isTime = isTime;
    _stepNum    = (_maxValue-_minValue)/_step/_betweenNum;
    _bgColor    = [UIColor whiteColor];
    _triangleColor         = [RCTScrollRuler colorFromHexString:_markerColor];
    self.backgroundColor    = [UIColor whiteColor];
    
    //[self addSubview:self.valueLab];
    [self addSubview:self.unitLab];
    [self addSubview:self.collectionView];
    [self addSubview:self.triangle];
    // [self addSubview:self.grayLine];
    [self setDefaultValue:_defaultValue];
    self.unitLab.text = _unit;
    [self addSubview:self.valueLab];
}

- (void)setMarkerColor:(NSString *)markerColor{
    [[self subviews]makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    _markerColor = markerColor;
    
    _stepNum    = (_maxValue-_minValue)/_step/_betweenNum;
    _bgColor    = [UIColor whiteColor];
    
    _triangleColor          = [RCTScrollRuler colorFromHexString:_markerColor];
    self.backgroundColor    = [UIColor whiteColor];
    
    //[self addSubview:self.valueLab];
    [self addSubview:self.unitLab];
    [self addSubview:self.collectionView];
    [self addSubview:self.triangle];
    // [self addSubview:self.grayLine];
    [self setDefaultValue:_defaultValue];
    self.unitLab.text = _unit;
    self.valueLab.backgroundColor = [RCTScrollRuler colorFromHexString:_markerColor];
    //self.valueLab.textColor = [RCTScrollRuler colorFromHexString:_markerTextColor];
    _triangle.triangleColor     = [RCTScrollRuler colorFromHexString:_markerColor];
    [self addTriangleTipToLayer:_valueLab.layer];
    [self bringSubviewToFront:_valueLab];
    [self addSubview:self.valueLab];
}


- (void)setMarkerTextColor:(NSString *)markerTextColor{
    [[self subviews]makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    _markerTextColor = markerTextColor;
    
    _stepNum    = (_maxValue-_minValue)/_step/_betweenNum;
    _bgColor    = [UIColor whiteColor];
    _triangleColor          = [RCTScrollRuler colorFromHexString:_markerColor];
    self.backgroundColor    = [UIColor whiteColor];
    
    // [self addSubview:self.valueLab];
    [self addSubview:self.unitLab];
    [self addSubview:self.collectionView];
    [self addSubview:self.triangle];
    // [self addSubview:self.grayLine];
    [self setDefaultValue:_defaultValue];
    self.unitLab.text = _unit;
    self.valueLab.backgroundColor = [RCTScrollRuler colorFromHexString:_markerColor];
    self.valueLab.textColor = [RCTScrollRuler colorFromHexString:_markerTextColor];
    _triangle.triangleColor     = [RCTScrollRuler colorFromHexString:_markerColor];
    [self addSubview:self.valueLab];
}

- (void)setStep:(float)step {
    NSLog(@"设置步长");
    [[self subviews]makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _step = step;
    _stepNum    = (_maxValue-_minValue)/_step/_betweenNum;
    _bgColor    = [UIColor whiteColor];
    _triangleColor          = [RCTScrollRuler colorFromHexString:_markerColor];
    self.backgroundColor    = [UIColor whiteColor];
    
    // [self addSubview:self.valueLab];
    [self addSubview:self.unitLab];
    [self addSubview:self.collectionView];
    [self addSubview:self.triangle];
    // [self addSubview:self.grayLine];
    [self setDefaultValue:_defaultValue];
    self.unitLab.text = _unit;
    [self addSubview:self.valueLab];
}

- (void)setDefaultValue:(float)defaultValue {
    NSLog(@"设置默认值");
    _defaultValue      = defaultValue;
    if (_maxValue != 0) {
        [self setRealValue:defaultValue];
        [_collectionView setContentOffset:CGPointMake(((defaultValue-_minValue)/(float)_step)*RulerGap, 0) animated:YES];
    }
    NSLog(@"setDefaultValue被调用了，defaultValue=%.2f", defaultValue);
}


- (void)setNum:(float)num {
    NSLog(@"设置间隔");
    [[self subviews]makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _num = num;
    _stepNum    = (_maxValue-_minValue)/_step/_betweenNum;
    _bgColor    = [UIColor whiteColor];
    //_triangleColor         = [UIColor yellowColor];// //_triangleColor          = [RCTScrollRuler colorFromHexString:_markerColor];
    self.backgroundColor    = [UIColor whiteColor];
    
    //[self addSubview:self.valueLab];
    // [self addSubview:self.unitLab];
    [self addSubview:self.collectionView];
    //[self addSubview:self.triangle];
    //[self addSubview:self.grayLine];
    [self setDefaultValue:_defaultValue];
    self.unitLab.text = _unit;
    [self addSubview:self.valueLab];
}

- (void)setUnit:(NSString *)unit {
    NSLog(@"设置单位");
    [[self subviews]makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _unit = unit;
    _stepNum    = (_maxValue-_minValue)/_step/_betweenNum;
    _bgColor    = [UIColor whiteColor];
    //_triangleColor         = [UIColor redColor];// = [RCTScrollRuler colorFromHexString:_markerColor];
    self.backgroundColor    = [UIColor whiteColor];
    
    //[self addSubview:self.valueLab];
    // [self addSubview:self.unitLab];
    [self addSubview:self.collectionView];
    //[self addSubview:self.triangle];
    //[self addSubview:self.grayLine];
    [self setDefaultValue:_defaultValue];
    self.unitLab.text = _unit;
    [self addSubview:self.valueLab];
}

-(instancetype)initWithFrame:(CGRect)frame theMinValue:(float)minValue theMaxValue:(float)maxValue theStep:(float)step theNum:(NSInteger)betweenNum theUnit:unit isTime:(BOOL)isTime markerColor:(NSString*)markerColor markerTextColor:(NSString*)markerTextColor {
    
    self = [super initWithFrame:frame];
    if (self) {
        _minValue   = minValue;
        _maxValue   = maxValue;
        _step       = step;
        _unit       = unit;
        _stepNum    = (_maxValue-_minValue)/_step/betweenNum;
        _betweenNum = betweenNum;
        _isTime = isTime;
        _markerColor = markerColor;
        markerTextColor = markerTextColor;
        
        _bgColor    = [UIColor whiteColor];
        _triangleColor          = [UIColor greenColor];//[RCTScrollRuler colorFromHexString:_markerColor];
        self.backgroundColor    = [UIColor whiteColor];
        
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
    
    CGPoint startPoint = CGPointMake(targetLayer.frame.size.width / 2 - 10 / 2, side);
    CGPoint endPoint = CGPointMake(targetLayer.frame.size.width / 2 + 10  / 2, side);
    UIBezierPath *trianglePath = [UIBezierPath bezierPath];
    
    CGFloat middleX = targetLayer.frame.size.width / 2;
    CGFloat middleY = (side / 2) * tan(M_PI / 3) + 10;
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
        _triangle = [[DYTriangleView alloc]initWithFrame:CGRectMake(self.bounds.size.width/2-0.5, CGRectGetMaxY(_valueLab.frame), 1, IndicatorHeight)];
        //_triangle.backgroundColor   = [UIColor orangeColor];
        _triangle.triangleColor     = [RCTScrollRuler colorFromHexString:_markerColor];
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
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(-10, CGRectGetMaxY(_valueLab.frame) + 30, self.bounds.size.width + 20, CollectionHeight) collectionViewLayout:flowLayout];
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
        _valueLab = [[UILabel alloc]initWithFrame:CGRectMake(self.bounds.size.width/2-40, -12, 80, 40)];
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
            _triangle.triangleColor     = [RCTScrollRuler colorFromHexString:_markerColor];
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
    [_collectionView setContentOffset:CGPointMake((int)realValue*RulerGap, 0) animated:animated];
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
            headerView = [[DYHeaderRulerView alloc]initWithFrame:CGRectMake(0, 20, self.frame.size.width/2, CollectionHeight)];
            headerView.backgroundColor  =  [UIColor clearColor];
            headerView.tag              =  1000;
            headerView.minValue         = _minValue;
            //headerView.backgroundColor = UIColor.redColor;
            [cell.contentView addSubview:headerView];
        }
        CGAffineTransform move = CGAffineTransformMakeRotation(110);//CGAffineTransformMakeTranslation(1, 1);
        //cell.transform = CGAffineTransformRotate(move, 0.0);
        
        return cell;
    }else if( indexPath.item == _stepNum +1){
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"footerCell" forIndexPath:indexPath];
        DYFooterRulerView *footerView = [cell.contentView viewWithTag:1001];
        if (!footerView){
            footerView = [[DYFooterRulerView alloc]initWithFrame:CGRectMake(50, 20, self.frame.size.width/2, CollectionHeight)];
            footerView.backgroundColor  = [UIColor clearColor];
            footerView.tag              = 1001;
            footerView.maxValue         = _maxValue;
            [cell.contentView addSubview:footerView];
        }
        CGAffineTransform move = CGAffineTransformMakeRotation(110);//CGAffineTransformMakeTranslation(1, 1);
        //cell.transform = CGAffineTransformRotate(move, 0.0);
        return cell;
    }else{
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"custemCell" forIndexPath:indexPath];
        DYRulerView *rulerView = [cell.contentView viewWithTag:1002];
        if (!rulerView){
            rulerView  = [[DYRulerView alloc]initWithFrame:CGRectMake(0, -20, RulerGap*_betweenNum, CollectionHeight)];
            rulerView.tag               = 1002;
            rulerView.step              = _step;
            rulerView.betweenNumber     = _betweenNum;
            rulerView.markerColor = _markerColor;
            // rulerView.backgroundColor  = [UIColor blueColor];
            [cell.contentView addSubview:rulerView];
        }
        //        if(indexPath.item>=8 && indexPath.item<=12){
        //            rulerView.backgroundColor   =  [UIColor greenColor];
        //        }else if(indexPath.item>=13 && indexPath.item<=18){
        //            rulerView.backgroundColor   =  [UIColor redColor];
        //        }else{
        //            rulerView.backgroundColor   =  [UIColor grayColor];
        //        }
        rulerView.backgroundColor   =  [UIColor whiteColor];
        rulerView.minValue = (int)(_step*(indexPath.item-1)*_betweenNum+_minValue);
        rulerView.maxValue = (int)(_step*indexPath.item*_betweenNum);
        rulerView.markerColor = _markerColor;
        rulerView.isTime = _isTime;
        // rulerView.backgroundColor  = [UIColor yellowColor];
        [rulerView setNeedsDisplay];
        //CGAffineTransform move = CGAffineTransformMakeRotation(110);//CGAffineTransformMakeTranslation(1, 1);
        //cell.transform = CGAffineTransformRotate(move, 0.0);
        return cell;
    }
}

-(CGSize )collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == 0 || indexPath.item == _stepNum+1){
        return CGSizeMake(self.frame.size.width/2, CollectionHeight);
    }else{
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

- (void)playAudio {
    [self playSound:@"tickering" :@"mp3"];
}

- (void)playSound :(NSString *)fName :(NSString *) ext{
    SystemSoundID audioEffect;
    NSString *path = [[NSBundle mainBundle] pathForResource : fName ofType :ext];
    if ([[NSFileManager defaultManager] fileExistsAtPath : path]) {
        NSURL *pathURL = [NSURL fileURLWithPath: path];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef) pathURL, &audioEffect);
        //AudioServicesCreateSystemSoundID(audioEffect);
        //AudioServicesCreateSystemSoundID(<#CFURLRef  _Nonnull inFileURL#>, <#SystemSoundID * _Nonnull outSystemSoundID#>)
    }
    else {
        NSLog(@"error, file not found: %@", path);
    }
}


#pragma mark -UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int value = scrollView.contentOffset.x/RulerGap;
    int totalValue = value*_step +_minValue;
    [self playAudio];
    if (self.delegate && [self.delegate respondsToSelector:@selector(dyScrollRulerView:valueChange:)]) {
        [self.delegate dyScrollRulerView:self valueChange:totalValue];
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
                
                int minutes =  floor(value / 60);
                int seconds = value - minutes * 60;
                NSString * secStr = (seconds < 10) ? [NSString stringWithFormat:@"0%d",seconds] :  [NSString stringWithFormat:@"%d",seconds];
                _valueLab.text = [NSString stringWithFormat:@"%d:%@", minutes, secStr];
                
            }
        }else{
            if (totalValue >= _maxValue) {
                _valueLab.text = [NSString stringWithFormat:@"%d",_maxValue];
            }else if(totalValue <= _minValue){
                if(_minValue == 0) {
                    _valueLab.text = @"0";
                } else {
                    _valueLab.text = [NSString stringWithFormat:@"%d",_minValue];
                }
            }else{
                _valueLab.text = [NSString stringWithFormat:@"%d",(value*_step) +_minValue];
            }
        }
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

@end
