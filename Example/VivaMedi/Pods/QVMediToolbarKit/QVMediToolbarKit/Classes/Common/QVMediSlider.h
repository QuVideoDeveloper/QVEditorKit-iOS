//
//  QVMediSlider.h
//  Pods-XYToolbarKit_Example
//
//  Created by chaojie zheng on 2020/4/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class QVMediSlider;
@protocol QVMediSliderDelegate <NSObject>

@optional

/**
 * Called when the Slider values are changed
 */
- (void)rangeSlider:(QVMediSlider *)sender didChangeSelectedValue:(float)selectedValue;

/**
 * Called when the user has finished interacting with the Slider
 */
- (void)didEndTouchesInRangeSlider:(QVMediSlider *)sender;

/**
 * Called when the user has started interacting with the Slider
 */
- (void)didStartTouchesInRangeSlider:(QVMediSlider *)sender;

@end


@interface QVMediSlider : UIControl <UIGestureRecognizerDelegate>

- (instancetype)initWithMinValue:(float)minValue maxValue:(float)maxValue selectValue:(float)selectValue;

@property (nonatomic, copy) void(^didChangeSelectedValueBlock)(QVMediSlider *slider, float selectedValue);

/**
 * Optional delegate.
 */
@property (nonatomic, weak) id<QVMediSliderDelegate> delegate;

/**
 * The minimum possible value to select in the range
 */
@property (nonatomic, assign) float minValue;

/**
 * The maximum possible value to select in the range
 */
@property (nonatomic, assign) float maxValue;

/**
 * The preselected minumum value
 * (note: This should be less than the selectedMaximum)
 */
@property (nonatomic, assign) float selectedValue;

/**
 * Each handle in the slider has a label above it showing the current selected value. By default, this is displayed as a decimal format.
 * You can override this default here by supplying your own NSNumberFormatter. For example, you could supply an NSNumberFormatter that has a currency style, or a prefix or suffix.
 * If this property is nil, the default decimal format will be used. Note: If you want no labels at all, please use the hideLabels flag. */
@property (nonatomic, strong) NSNumberFormatter *numberFormatterOverride;

/**
 * Hides the labels above the slider controls. YES = labels will be hidden. NO = labels will be shown. Default is NO.
 */
@property (nonatomic, assign) BOOL hideLabel;

@property (nonatomic, assign) BOOL hideCurValueLabel;

@property (nonatomic, assign) BOOL hideMinMaxValueLabel;


/**
* The color of the curValueLabel value text label. If not set, the default is the tintColor.
*/
@property (nonatomic, strong) UIColor *curValueLabelColour;

/**
* The color of the minimum value text label. If not set, the default is the tintColor.
*/
@property (nonatomic, strong) UIColor *minLabelColour;

/**
 * The color of the maximum value text label. If not set, the default is the tintColor.
 */
@property (nonatomic, strong) UIColor *maxLabelColour;

/**
 * The font of the curValue text label. If not set, the default is system font size 12.
 */
@property (nonatomic, strong) UIFont *curValueLabelFont;

/**
 * The font of the minimum value text label. If not set, the default is system font size 12.
 */
@property (nonatomic, strong) UIFont *minLabelFont;

/**
 * The font of the maximum value text label. If not set, the default is system font size 12.
 */
@property (nonatomic, strong) UIFont *maxLabelFont;

@property (nonatomic,   copy) NSString *minLabelString;

@property (nonatomic,   copy) NSString *maxLabelString;

/// default YES
@property (nonatomic, assign) BOOL autoChangeTitleLabelW;

/**
 *Handle slider with custom color, you can set custom color for your handle
 */
@property (nonatomic, strong) UIColor *handleColor;

/**
 *Handle diameter (default 16.0)
 */
@property (nonatomic, assign) CGFloat handleDiameter;

/**
 *Selected handle diameter multiplier (default 1.7)
 */
@property (nonatomic, assign) CGFloat selectedHandleDiameterMultiplier;

/**
 *Set slider line tint color between handles
 */
@property (nonatomic, strong) UIColor *tintColorBetweenHandles;

/**
 * The step value, this control the value of each step. If not set the default is 0.1.
 * (note: this is ignored if <= 0.0)
 */
@property (nonatomic, assign) float step;

/**
 *Set padding between label and handle (default 8.0)
 */
@property (nonatomic, assign) CGFloat labelPadding;

/**
 *Set the slider line height (default 1.0)
 */
@property (nonatomic, assign) CGFloat lineHeight;

@end

NS_ASSUME_NONNULL_END
