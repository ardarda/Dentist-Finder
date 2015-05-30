#import <UIKit/UIKit.h>

@interface UILabel (dynamicSizeMe)

-(float)resizeToFit;
-(float)expectedHeight;
-(void)resizeToStretch;
-(float)expectedWidth;

@end
