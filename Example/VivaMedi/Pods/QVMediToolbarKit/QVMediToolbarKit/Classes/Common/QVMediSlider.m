//
//  QVMediSlider.m
//  Pods-XYToolbarKit_Example
//
//  Created by chaojie zheng on 2020/4/17.
//

#import "QVMediSlider.h"

const int GB_HANDLE_TOUCH_AREA_EXPANSION = -30; //expand the touch area of the handle by this much (negative values increase size) so that you don't have to touch right on the handle to activate it.
const float GB_TEXT_HEIGHT = 14;

const float GB_TEXT_WIDTH = 35;

const float GB_TEXT_WIDTH_ADD = 10;

@interface QVMediSlider ()

@property (nonatomic, strong) CALayer *sliderLine;
@property (nonatomic, strong) CALayer *sliderLineBetweenHandles;

@property (nonatomic, strong) CALayer *sliderHandle;
@property (nonatomic, assign) BOOL handleSelected;

@property (nonatomic, strong) CATextLayer *curValueLabel;
@property (nonatomic, strong) CATextLayer *minLabel;
@property (nonatomic, strong) CATextLayer *maxLabel;

@property (nonatomic, assign) CGSize curValueLabelTextSize;
@property (nonatomic, assign) CGSize minLabelTextSize;
@property (nonatomic, assign) CGSize maxLabelTextSize;

@property (nonatomic, strong) NSNumberFormatter *decimalNumberFormatter;

// strong reference needed for UIAccessibilityContainer
@property (nonatomic, strong) NSMutableArray *accessibleElements;

@property (nonatomic, assign) BOOL customInit;

@end

/**
 An accessibility element that increments and decrements the slider
 */
@interface XYSliderElement : UIAccessibilityElement
@end

static const CGFloat kLabelsFontSize = 12.0f;

@implementation QVMediSlider

- (instancetype)initWithMinValue:(float)minValue maxValue:(float)maxValue selectValue:(float)selectValue {
    _customInit = YES;
    _minValue = minValue;
    _maxValue = maxValue;
    _selectedValue = selectValue;
    QVMediSlider *slider = [self initWithFrame:CGRectZero];
    return slider;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initialiseControl];
    }
    return self;
}

- (UIColor *)gb_colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue {
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
                           green:((float)((hexValue & 0xFF00) >> 8))/255.0
                            blue:((float)(hexValue & 0xFF))/255.0
                           alpha:alphaValue];
}


- (void)initialiseControl {
    if (!_customInit) {
        _minValue = 0;
        _maxValue = 100;
        _selectedValue = 50;
    }
    
    self.tintColor = [self gb_colorWithHex:0xFFFFFF alpha:0.2];
        
    _autoChangeTitleLabelW = YES;
    
    _step = 0.1f;

    _hideLabel = NO;
    
    _handleDiameter = 16.0;
    _selectedHandleDiameterMultiplier = 1.7;
    
    _lineHeight = 2.0;

    _maxLabelColour = [self gb_colorWithHex:0XFFFFFF alpha:.5];
    _minLabelColour = [self gb_colorWithHex:0XFFFFFF alpha:.5];
    _curValueLabelColour = UIColor.whiteColor;
    
    _minLabelString = [NSString stringWithFormat:@"%@",@(_minValue)];
    _maxLabelString = [NSString stringWithFormat:@"%@",@(_maxValue)];
    
    _hideMinMaxValueLabel = YES;
    
    _labelPadding = 8.0;
    
    //draw the slider line
    self.sliderLine = [CALayer layer];
    self.sliderLine.backgroundColor = self.tintColor.CGColor;
    [self.layer addSublayer:self.sliderLine];

    
    //draw the track distline
    self.sliderLineBetweenHandles = [CALayer layer];
    self.sliderLineBetweenHandles.backgroundColor = self.tintColor.CGColor;
    [self.layer addSublayer:self.sliderLineBetweenHandles];
    
    //draw the minimum slider handle
    self.sliderHandle = [CALayer layer];
    self.sliderHandle.cornerRadius = self.handleDiameter / 2;
    self.sliderHandle.backgroundColor = UIColor.whiteColor.CGColor;
    [self.layer addSublayer:self.sliderHandle];
    self.sliderHandle.frame = CGRectMake(0, 0, self.handleDiameter, self.handleDiameter);

    //draw the text labels
    self.curValueLabel = [[CATextLayer alloc] init];
    self.curValueLabel.alignmentMode = kCAAlignmentCenter;
    self.curValueLabel.fontSize = kLabelsFontSize;
    self.curValueLabel.frame = CGRectMake(0, 0, 75, GB_TEXT_HEIGHT);
    self.curValueLabel.contentsScale = [UIScreen mainScreen].scale;
    self.curValueLabel.contentsScale = [UIScreen mainScreen].scale;
    if (self.curValueLabelColour == nil){
        self.curValueLabel.foregroundColor = UIColor.whiteColor.CGColor;
    } else {
        self.curValueLabel.foregroundColor = self.curValueLabelColour.CGColor;
    }
    self.curValueLabelFont =  [UIFont systemFontOfSize:12 weight:UIFontWeightBold];
    [self.layer addSublayer:self.curValueLabel];

    //draw the min text labels
    self.minLabel = [[CATextLayer alloc] init];
    self.minLabel.alignmentMode = kCAAlignmentCenter;
    self.minLabel.fontSize = kLabelsFontSize;
    self.minLabel.string = self.minLabelString;
    self.minLabel.frame = CGRectMake(0, 0, GB_TEXT_WIDTH, GB_TEXT_HEIGHT);
    self.minLabel.contentsScale = [UIScreen mainScreen].scale;
    self.minLabel.contentsScale = [UIScreen mainScreen].scale;
    if (self.minLabelColour == nil){
        self.minLabel.foregroundColor = UIColor.whiteColor.CGColor;
    } else {
        self.minLabel.foregroundColor = self.minLabelColour.CGColor;
    }
    self.minLabelFont =  [UIFont systemFontOfSize:12 weight:UIFontWeightBold];
    [self.layer addSublayer:self.minLabel];
    
    //draw the maxLabel text labels
    self.maxLabel = [[CATextLayer alloc] init];
    self.maxLabel.alignmentMode = kCAAlignmentCenter;
    self.maxLabel.fontSize = kLabelsFontSize;
    self.maxLabel.string = self.maxLabelString;
    self.maxLabel.frame = CGRectMake(0, 0, GB_TEXT_WIDTH, GB_TEXT_HEIGHT);
    self.maxLabel.contentsScale = [UIScreen mainScreen].scale;
    self.maxLabel.contentsScale = [UIScreen mainScreen].scale;
    if (self.maxLabelColour == nil){
        self.maxLabel.foregroundColor = UIColor.whiteColor.CGColor;
    } else {
        self.maxLabel.foregroundColor = self.maxLabelColour.CGColor;
    }
    self.maxLabelFont =  [UIFont systemFontOfSize:12 weight:UIFontWeightBold];
    [self.layer addSublayer:self.maxLabel];
    
    [self refresh];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    //positioning for the slider line
    float barSidePadding = 16.0f;
    float valueLabelLineSpace = 10.0f;

    CGRect currentFrame = self.frame;
    float yMiddle = currentFrame.size.height/2.0;
    CGPoint lineLeftSide = CGPointMake(barSidePadding, yMiddle);
    
    self.minLabelTextSize = [self.minLabel.string sizeWithAttributes:@{NSFontAttributeName:self.minLabelFont}];
    self.maxLabelTextSize = [self.maxLabel.string sizeWithAttributes:@{NSFontAttributeName:self.maxLabelFont}];

    CGSize minLabelTextSize = self.minLabelTextSize;
    CGSize maxLabelTextSize = self.maxLabelTextSize;

    
    if (!self.autoChangeTitleLabelW) {
        CGSize orMinLabelTextSize = minLabelTextSize;
        orMinLabelTextSize.width = 30;
        minLabelTextSize = orMinLabelTextSize;
        
        CGSize orMaxLabelTextSize = maxLabelTextSize;
        orMaxLabelTextSize.width = 30;
        maxLabelTextSize = orMaxLabelTextSize;
    }
    
    self.minLabel.frame = CGRectMake(0, lineLeftSide.y - (GB_TEXT_HEIGHT - self.lineHeight)/2, minLabelTextSize.width + GB_TEXT_WIDTH_ADD, GB_TEXT_HEIGHT);

    
    CGFloat minLabelStanding = GB_TEXT_WIDTH_ADD + minLabelTextSize.width + valueLabelLineSpace + barSidePadding/2;
    CGFloat maxLabelStanding = GB_TEXT_WIDTH_ADD + maxLabelTextSize.width + valueLabelLineSpace + barSidePadding/2;

    if (self.hideMinMaxValueLabel) {
        self.sliderLine.frame = CGRectMake(barSidePadding/2, lineLeftSide.y, currentFrame.size.width - barSidePadding, self.lineHeight);
    }else {
        self.sliderLine.frame = CGRectMake(GB_TEXT_WIDTH_ADD + minLabelTextSize.width + valueLabelLineSpace, lineLeftSide.y, currentFrame.size.width - minLabelStanding - maxLabelStanding, self.lineHeight);
    }

    self.maxLabel.frame = CGRectMake(CGRectGetMaxX(self.sliderLine.frame) + valueLabelLineSpace, lineLeftSide.y - (GB_TEXT_HEIGHT - self.lineHeight)/2, maxLabelTextSize.width + GB_TEXT_WIDTH_ADD, GB_TEXT_HEIGHT);

    self.sliderLine.cornerRadius = self.lineHeight / 2.0;

    [self updateLabelValues];
    [self updateHandlePositions];
    [self updateLabelPositions];
}

- (void)refresh {
    _selectedValue = roundf(self.selectedValue/self.step)*self.step;
    
    if (self.selectedValue < self.minValue) {
        _selectedValue = self.minValue;
    }
    
    if (self.selectedValue > self.maxValue) {
        _selectedValue = self.maxValue;
    }
    
    //update the frames in a transaction so that the tracking doesn't continue until the frame has moved.
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [self updateHandlePositions];
    [self updateLabelPositions];
    [CATransaction commit];
    [self updateLabelValues];
    [self updateAccessibilityElements];
    
    //update the delegate
//    if ([self.delegate respondsToSelector:@selector(rangeSlider:didChangeSelectedValue:)] && self.handleSelected){
    if ([self.delegate respondsToSelector:@selector(rangeSlider:didChangeSelectedValue:)]){
        [self.delegate rangeSlider:self didChangeSelectedValue:self.selectedValue];
    }
    NSNumberFormatter *formatter = (self.numberFormatterOverride != nil) ? self.numberFormatterOverride : self.decimalNumberFormatter;
    if (self.didChangeSelectedValueBlock) {
        self.didChangeSelectedValueBlock(self, [[formatter stringFromNumber:@(self.selectedValue)] floatValue]);
    }

    [self sendActionsForControlEvents:UIControlEventValueChanged];
}


#pragma mark - Set Positions
- (void)updateHandlePositions {
    CGPoint handleCenter = CGPointMake([self getXPositionAlongLineForValue:self.selectedValue], CGRectGetMidY(self.sliderLine.frame));
    self.sliderHandle.position = handleCenter;
    float valueLabelLineSpace = 10.0f;

    //positioning for the dist slider line
//    self.sliderLineBetweenHandles.frame = CGRectMake(self.sliderHandle.position.x, self.sliderLine.frame.origin.y, CGRectGetMaxX(self.sliderLine.frame) - self.sliderHandle.position.x, self.lineHeight);
    CGSize minLabelTextSize = self.minLabelTextSize;
    if (!self.autoChangeTitleLabelW) {
        CGSize orMinLabelTextSize = minLabelTextSize;
        orMinLabelTextSize.width = 30;
        minLabelTextSize = orMinLabelTextSize;
    }
    
    if (self.hideMinMaxValueLabel) {
        self.sliderLineBetweenHandles.frame = CGRectMake(0, self.sliderLine.frame.origin.y, self.sliderHandle.position.x, self.lineHeight);
    }else {
        self.sliderLineBetweenHandles.frame = CGRectMake(minLabelTextSize.width +  GB_TEXT_WIDTH_ADD + valueLabelLineSpace, self.sliderLine.frame.origin.y, self.sliderHandle.position.x - GB_TEXT_WIDTH_ADD - valueLabelLineSpace - minLabelTextSize.width, self.lineHeight);
    }
}

- (float)getXPositionAlongLineForValue:(float)value {
    //first get the percentage along the line for the value
    float percentage = [self getPercentageAlongLineForValue:value];

    //get the difference between the maximum and minimum coordinate position x values (e.g if max was x = 310, and min was x=10, difference is 300)
    float maxMinDif = CGRectGetMaxX(self.sliderLine.frame) - CGRectGetMinX(self.sliderLine.frame);

    //now multiply the percentage by the minMaxDif to see how far along the line the point should be, and add it onto the minimum x position.
    float offset = percentage * maxMinDif;

    return CGRectGetMinX(self.sliderLine.frame) + offset;
}

- (float)getPercentageAlongLineForValue:(float) value {
    if (self.minValue == self.maxValue){
        return 0; //stops divide by zero errors where maxMinDif would be zero. If the min and max are the same the percentage has no point.
    }

    //get the difference between the maximum and minimum values (e.g if max was 100, and min was 50, difference is 50)
    float maxMinDif = self.maxValue - self.minValue;

    //now subtract value from the minValue (e.g if value is 75, then 75-50 = 25)
    float valueSubtracted = value - self.minValue;

    //now divide valueSubtracted by maxMinDif to get the percentage (e.g 25/50 = 0.5)
    return valueSubtracted / maxMinDif;
}

- (void)updateLabelPositions {
    //the centre points for the labels are X = the same x position as the relevant handle. Y = the y center of the handle plus or minus (depending on the label position) the handle size / 2 + padding + label size/2
    float padding = self.labelPadding + 5;
    
    CGPoint sliderHandleCentre = [self getCentreOfRect:self.sliderHandle.frame];
    CGPoint newCurValueLabelCenter = CGPointMake(sliderHandleCentre.x, (self.sliderHandle.frame.origin.y + (self.sliderHandle.frame.size.height/2)) + ((self.minLabel.frame.size.height/2) + padding + (self.sliderHandle.frame.size.height/2)) * -1);
    
    CGSize curValueLabelTextSize = self.curValueLabelTextSize;
    
    self.curValueLabel.frame = CGRectMake(0, 0, curValueLabelTextSize.width, curValueLabelTextSize.height);
    
    self.curValueLabel.position = newCurValueLabelCenter;

}

- (void)updateLabelValues {
    if (self.hideLabel) {
        self.curValueLabel.string = @"";
        self.maxLabel.string = @"";
        self.minLabel.string = @"";
        return;
    }
    if (self.hideCurValueLabel) {
        self.curValueLabel.string = @"";
    }else {
        NSNumberFormatter *formatter = (self.numberFormatterOverride != nil) ? self.numberFormatterOverride : self.decimalNumberFormatter;
        self.curValueLabel.string = [formatter stringFromNumber:@(self.selectedValue)];
        self.curValueLabelTextSize = [self.curValueLabel.string sizeWithAttributes:@{NSFontAttributeName:self.curValueLabelFont}];
    }
    if (self.hideMinMaxValueLabel) {
        self.maxLabel.string = @"";
        self.minLabel.string = @"";
    }else {
        self.maxLabel.string = self.maxLabelString;
        self.minLabel.string = self.minLabelString;
        self.minLabelTextSize = [self.minLabel.string sizeWithAttributes:@{NSFontAttributeName:self.minLabelFont}];
        self.maxLabelTextSize = [self.maxLabel.string sizeWithAttributes:@{NSFontAttributeName:self.maxLabelFont}];
    }
}

- (void)updateAccessibilityElements {
  [_accessibleElements removeAllObjects];
  [_accessibleElements addObject:[self sliderHandleAccessibilityElement]];
}

- (UIAccessibilityElement *)sliderHandleAccessibilityElement {
  XYSliderElement *element = [[XYSliderElement alloc] initWithAccessibilityContainer:self];
  element.isAccessibilityElement = YES;
  element.accessibilityValue = self.minLabel.string;
  element.accessibilityFrame = [self convertRect:self.sliderHandle.frame toView:nil];
  element.accessibilityTraits = UIAccessibilityTraitAdjustable;
  return element;
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(UIViewNoIntrinsicMetric, 65);
}

- (void)prepareForInterfaceBuilder {
    if (self.tintColorBetweenHandles == nil) {
        self.sliderLineBetweenHandles.backgroundColor = self.tintColor.CGColor;
    }
}

- (void)tintColorDidChange {
    CGColorRef color = self.tintColor.CGColor;

    [CATransaction begin];
    [CATransaction setAnimationDuration:0.5];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut] ];
    self.sliderLine.backgroundColor = color;
    if (self.handleColor == nil) {
        self.sliderHandle.backgroundColor = color;
    }

    if (self.minLabelColour == nil){
        self.minLabel.foregroundColor = color;
    }
    if (self.maxLabelColour == nil){
        self.maxLabel.foregroundColor = color;
    }
    [CATransaction commit];
}

#pragma mark - Touch Tracking
- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint gesturePressLocation = [touch locationInView:self];
    if (CGRectContainsPoint(CGRectInset(self.sliderHandle.frame, GB_HANDLE_TOUCH_AREA_EXPANSION, GB_HANDLE_TOUCH_AREA_EXPANSION), gesturePressLocation)) {
        self.handleSelected = YES;
        [self animateHandle:self.sliderHandle withSelection:YES];
        if ([self.delegate respondsToSelector:@selector(didStartTouchesInRangeSlider:)]) {
            [self.delegate didStartTouchesInRangeSlider:self];
        }
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {

    CGPoint location = [touch locationInView:self];

    //find out the percentage along the line we are in x coordinate terms (subtracting half the frames width to account for moving the middle of the handle, not the left hand side)
    float percentage = ((location.x-CGRectGetMinX(self.sliderLine.frame)) - self.handleDiameter/2) / (CGRectGetMaxX(self.sliderLine.frame) - CGRectGetMinX(self.sliderLine.frame));

    //multiply that percentage by self.maxValue to get the new selected minimum value
    float selectedValue = percentage * (self.maxValue - self.minValue) + self.minValue;
    self.selectedValue = selectedValue;

    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    if (self.handleSelected) {
        [self animateHandle:self.sliderHandle withSelection:NO];
    }
    if ([self.delegate respondsToSelector:@selector(didEndTouchesInRangeSlider:)]) {
        [self.delegate didEndTouchesInRangeSlider:self];
    }
}

- (void)cancelTrackingWithEvent:(nullable UIEvent *)event {
    if (self.handleSelected) {
         [self animateHandle:self.sliderHandle withSelection:NO];
     }
     if ([self.delegate respondsToSelector:@selector(didEndTouchesInRangeSlider:)]) {
         [self.delegate didEndTouchesInRangeSlider:self];
     }
}


#pragma mark - Animation
- (void)animateHandle:(CALayer*)handle withSelection:(BOOL)selected {
    if (selected){
        [CATransaction begin];
        [CATransaction setAnimationDuration:0.3];
        [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut] ];
        handle.transform = CATransform3DMakeScale(self.selectedHandleDiameterMultiplier, self.selectedHandleDiameterMultiplier, 1);

        //the label above the handle will need to move too if the handle changes size
        [self updateLabelPositions];

        [CATransaction setCompletionBlock:^{
        }];
        [CATransaction commit];

    } else {
        [CATransaction begin];
        [CATransaction setAnimationDuration:0.3];
        [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut] ];
        handle.transform = CATransform3DIdentity;

        //the label above the handle will need to move too if the handle changes size
        [self updateLabelPositions];

        [CATransaction commit];
    }
}

#pragma mark - Calculating nearest handle to point
- (float)distanceBetweenPoint:(CGPoint)point1 andPoint:(CGPoint)point2 {
    CGFloat xDist = (point2.x - point1.x);
    CGFloat yDist = (point2.y - point1.y);
    return sqrt((xDist * xDist) + (yDist * yDist));
}

- (CGPoint)getCentreOfRect:(CGRect)rect {
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}

#pragma mark - Properties
- (void)setTintColor:(UIColor *)tintColor {
    [super setTintColor:tintColor];

    struct CGColor *color = self.tintColor.CGColor;

    [CATransaction begin];
    [CATransaction setAnimationDuration:0.5];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut] ];
    self.sliderLine.backgroundColor = color;
    [CATransaction commit];
}

- (NSNumberFormatter *)decimalNumberFormatter {
    if (!_decimalNumberFormatter){
        _decimalNumberFormatter = [[NSNumberFormatter alloc] init];
        _decimalNumberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
        _decimalNumberFormatter.maximumFractionDigits = 0;
    }
    return _decimalNumberFormatter;
}

- (void)setMinValue:(float)minValue {
    _minValue = minValue;
    [self refresh];
}

- (void)setMaxValue:(float)maxValue {
    _maxValue = maxValue;
    [self refresh];
}

- (void)setSelectedValue:(float)selectedValue {
    if (selectedValue > self.maxValue){
        selectedValue = self.maxValue;
    }
    if (selectedValue < self.minValue) {
        selectedValue = self.minValue;
    }
    _selectedValue = selectedValue;
    NSNumberFormatter *formatter = (self.numberFormatterOverride != nil) ? self.numberFormatterOverride : self.decimalNumberFormatter;
    if (self.didChangeSelectedValueBlock) {
        self.didChangeSelectedValueBlock(self, [[formatter stringFromNumber:@(self.selectedValue)] floatValue]);
    }else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.didChangeSelectedValueBlock) {
                self.didChangeSelectedValueBlock(self, [[formatter stringFromNumber:@(self.selectedValue)] floatValue]);
            }
        });
    }
    [self refresh];
}


-(void)setMinLabelColour:(UIColor *)minLabelColour {
    _minLabelColour = minLabelColour;
    self.minLabel.foregroundColor = _minLabelColour.CGColor;
}

- (void)setDidChangeSelectedValueBlock:(void (^)(QVMediSlider * _Nonnull, float))didChangeSelectedValueBlock {
    _didChangeSelectedValueBlock = didChangeSelectedValueBlock;
}

-(void)setMaxLabelColour:(UIColor *)maxLabelColour {
    _maxLabelColour = maxLabelColour;
    self.maxLabel.foregroundColor = _maxLabelColour.CGColor;
}

- (void)setMinLabelFont:(UIFont *)minLabelFont {
    _minLabelFont = minLabelFont;
    CFStringRef fontName = (__bridge CFStringRef)minLabelFont.fontName;
    CGFontRef fontRef = CGFontCreateWithFontName(fontName);
    self.minLabel.font = fontRef;
    self.minLabel.fontSize = _minLabelFont.pointSize;
}

- (void)setMaxLabelFont:(UIFont *)maxLabelFont {
    _maxLabelFont = maxLabelFont;
    CFStringRef fontName = (__bridge CFStringRef)maxLabelFont.fontName;
    CGFontRef fontRef = CGFontCreateWithFontName(fontName);
    self.maxLabel.font = fontRef;
    self.maxLabel.fontSize = _maxLabelFont.pointSize;
}

- (void)setNumberFormatterOverride:(NSNumberFormatter *)numberFormatterOverride {
    _numberFormatterOverride = numberFormatterOverride;
    [self updateLabelValues];
}

- (void)setHandleColor:(UIColor *)handleColor {
    _handleColor = handleColor;
    self.sliderHandle.backgroundColor = [handleColor CGColor];
}


- (void)setHandleDiameter:(CGFloat)handleDiameter {
    _handleDiameter = handleDiameter;
    
    self.sliderHandle.cornerRadius = self.handleDiameter / 2;
    self.sliderHandle.frame = CGRectMake(0, 0, self.handleDiameter, self.handleDiameter);
}

- (void)setTintColorBetweenHandles:(UIColor *)tintColorBetweenHandles {
    _tintColorBetweenHandles = tintColorBetweenHandles;
    self.sliderLineBetweenHandles.backgroundColor = [tintColorBetweenHandles CGColor];
}

- (void)setLineHeight:(CGFloat)lineHeight {
    _lineHeight = lineHeight;
    [self setNeedsLayout];
}

- (void)setAutoChangeTitleLabelW:(BOOL)autoChangeTitleLabelW {
    _autoChangeTitleLabelW = autoChangeTitleLabelW;
}

- (void)setHideCurValueLabel:(BOOL)hideCurValueLabel {
    _hideCurValueLabel = hideCurValueLabel;
    [self setNeedsLayout];
}

- (void)setLabelPadding:(CGFloat)labelPadding {
    _labelPadding = labelPadding;
    [self updateLabelPositions];
}

- (void)setMinLabelString:(NSString *)minLabelString {
    _minLabelString = minLabelString;
//    [self refresh];
    [self setNeedsLayout];
}

- (void)setMaxLabelString:(NSString *)maxLabelString {
    _maxLabelString = maxLabelString;
//    [self refresh];
    [self setNeedsLayout];
}

#pragma mark - UIAccessibilityContainer Protocol

- (NSArray *)accessibleElements {
  if(_accessibleElements != nil) {
    return _accessibleElements;
  }
  
  _accessibleElements = [[NSMutableArray alloc] init];
  [_accessibleElements addObject:[self sliderHandleAccessibilityElement]];
  
  return _accessibleElements;
}

- (NSInteger)accessibilityElementCount {
  return [[self accessibleElements] count];
}

- (id)accessibilityElementAtIndex:(NSInteger)index {
  return [[self accessibleElements] objectAtIndex:index];
}

- (NSInteger)indexOfAccessibilityElement:(id)element {
  return [[self accessibleElements] indexOfObject:element];
}

- (void)setCurValueLabelFont:(UIFont *)curValueLabelFont {
    _curValueLabelFont = curValueLabelFont;
    CFStringRef fontName = (__bridge CFStringRef)curValueLabelFont.fontName;
    CGFontRef fontRef = CGFontCreateWithFontName(fontName);
    self.curValueLabel.font = fontRef;
    self.curValueLabel.fontSize = _curValueLabelFont.pointSize;
}

- (void)setStep:(float)step {
    _step = step;
    [self setNeedsLayout];
}

#pragma mark - UIAccessibility

- (BOOL)isAccessibilityElement {
  return NO;
}

@end


@implementation XYSliderElement

- (void)accessibilityIncrement {
  QVMediSlider *slider = (QVMediSlider*)self.accessibilityContainer;
  slider.selectedValue += slider.step;
  self.accessibilityValue = slider.curValueLabel.string;
}

- (void)accessibilityDecrement {
  QVMediSlider* slider = (QVMediSlider*)self.accessibilityContainer;
  slider.selectedValue -= slider.step;
  self.accessibilityValue = slider.curValueLabel.string;
}

@end
