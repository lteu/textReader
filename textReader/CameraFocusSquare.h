@import UIKit;

@interface CameraFocusSquare : UIView <CAAnimationDelegate>

- (instancetype)initWithTouchPoint:(CGPoint)touchPoint;
- (void)updatePoint:(CGPoint)touchPoint;
- (void)animateFocusingAction;

@end
