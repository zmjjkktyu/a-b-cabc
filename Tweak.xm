#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

static NSInteger const kTips18Tag = 18418;

@interface Tips18Panel : UIView
@property(nonatomic,strong) UIVisualEffectView *blur;
@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UILabel *bodyLabel;
@property(nonatomic,strong) UIButton *closeButton;
@end

@implementation Tips18Panel
- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        self.backgroundColor = [UIColor colorWithWhite:0.08 alpha:0.72];
        self.layer.cornerRadius = 24.0;
        self.layer.cornerCurve = kCACornerCurveContinuous;
        self.layer.masksToBounds = YES;
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.16].CGColor;

        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemMaterialDark];
        _blur = [[UIVisualEffectView alloc] initWithEffect:effect];
        _blur.frame = self.bounds;
        _blur.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:_blur];

        UILabel *icon = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 48, 48)];
        icon.text = @"💡";
        icon.font = [UIFont systemFontOfSize:28];
        icon.textAlignment = NSTextAlignmentCenter;
        icon.backgroundColor = [UIColor colorWithWhite:1 alpha:0.12];
        icon.layer.cornerRadius = 14;
        icon.layer.masksToBounds = YES;
        [self addSubview:icon];

        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.text = @"iOS 18 新功能";
        _titleLabel.textColor = UIColor.whiteColor;
        _titleLabel.font = [UIFont systemFontOfSize:19 weight:UIFontWeightSemibold];
        [self addSubview:_titleLabel];

        _bodyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _bodyLabel.text = @"探索新的系统体验与实用功能。此界面为 iOS 16.1 上的第三方视觉复刻。";
        _bodyLabel.textColor = [UIColor colorWithWhite:1 alpha:0.72];
        _bodyLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
        _bodyLabel.numberOfLines = 0;
        [self addSubview:_bodyLabel];

        _closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_closeButton setTitle:@"知道了" forState:UIControlStateNormal];
        [_closeButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _closeButton.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightSemibold];
        _closeButton.backgroundColor = [UIColor colorWithWhite:1 alpha:0.14];
        _closeButton.layer.cornerRadius = 14;
        [self addSubview:_closeButton];
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat w = self.bounds.size.width;
    self.titleLabel.frame = CGRectMake(82, 20, w - 112, 28);
    self.bodyLabel.frame = CGRectMake(20, 82, w - 40, 56);
    self.closeButton.frame = CGRectMake(20, self.bounds.size.height - 52, w - 40, 40);
}
@end

static UIViewController *Tips18TopController(UIViewController *vc) {
    UIViewController *current = vc;
    while (current.presentedViewController) current = current.presentedViewController;
    if ([current isKindOfClass:UINavigationController.class]) {
        return Tips18TopController(((UINavigationController *)current).visibleViewController ?: current);
    }
    if ([current isKindOfClass:UITabBarController.class]) {
        return Tips18TopController(((UITabBarController *)current).selectedViewController ?: current);
    }
    return current;
}

static void Tips18ShowPanel(UIViewController *vc) {
    UIViewController *top = Tips18TopController(vc);
    if ([top.view viewWithTag:kTips18Tag]) return;

    UIView *dimming = [[UIView alloc] initWithFrame:top.view.bounds];
    dimming.tag = kTips18Tag;
    dimming.backgroundColor = [UIColor colorWithWhite:0 alpha:0.12];
    dimming.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [top.view addSubview:dimming];

    Tips18Panel *panel = [[Tips18Panel alloc] initWithFrame:CGRectMake(20, top.view.bounds.size.height - 300, top.view.bounds.size.width - 40, 260)];
    panel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    panel.transform = CGAffineTransformMakeTranslation(0, 40);
    panel.alpha = 0;
    [dimming addSubview:panel];

    [panel.closeButton addAction:[UIAction actionWithHandler:^(__unused UIAction *action) {
        [UIView animateWithDuration:0.22 animations:^{
            panel.alpha = 0;
            panel.transform = CGAffineTransformMakeTranslation(0, 30);
        } completion:^(__unused BOOL finished) {
            [dimming removeFromSuperview];
        }];
    }] forControlEvents:UIControlEventTouchUpInside];

    [UIView animateWithDuration:0.38 delay:0 usingSpringWithDamping:0.86 initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveEaseOut animations:^{
        panel.alpha = 1;
        panel.transform = CGAffineTransformIdentity;
    } completion:nil];
}

static void Tips18AddButton(UIViewController *vc) {
    if (!vc.isViewLoaded) return;
    if ([vc.view viewWithTag:kTips18Tag + 1]) return;

    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.tag = kTips18Tag + 1;
    button.frame = CGRectMake(vc.view.bounds.size.width - 58, 18, 42, 42);
    button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
    button.backgroundColor = [UIColor colorWithWhite:0.12 alpha:0.88];
    button.layer.cornerRadius = 21;
    button.layer.cornerCurve = kCACornerCurveContinuous;
    button.layer.shadowOpacity = 0.18;
    button.layer.shadowRadius = 8;
    button.layer.shadowOffset = CGSizeMake(0, 3);
    [button setTitle:@"💡" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:20];
    [button addAction:[UIAction actionWithHandler:^(__unused UIAction *action) {
        Tips18ShowPanel(vc);
    }] forControlEvents:UIControlEventTouchUpInside];
    [vc.view addSubview:button];
}

%hook UIViewController
- (void)viewDidAppear:(BOOL)animated {
    %orig;
    if ([[NSBundle mainBundle].bundleIdentifier isEqualToString:@"com.apple.tips"]) {
        dispatch_async(dispatch_get_main_queue(), ^{ Tips18AddButton(self); });
    }
}
%end
