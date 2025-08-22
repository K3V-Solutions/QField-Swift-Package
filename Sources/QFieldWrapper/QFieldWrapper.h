//
//  QFieldWrapper.h
//  QField
//
//  Created by Juan Carlos Aguilar Garcia on 24.06.25.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QFieldWrapper : NSObject

- (int) bootQField;
- (int) runQField;
- (int) widget:(UIView *)nativeController;
- (int) loadProject:(NSString *)path zoomToProject:(BOOL)zoom absolutePath:(BOOL)absolute;
- (void) zoomIn;
- (void) zoomOut;
- (void) moveUp;
- (void) moveDown;
- (void) moveLeft;
- (void) moveRight;

@end

NS_ASSUME_NONNULL_END
