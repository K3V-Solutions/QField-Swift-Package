//
//  QFieldWrapper.m
//  QField
//
//  Created by Juan Carlos Aguilar Garcia on 24.06.25.
//


#import <Foundation/Foundation.h>
#import <QFieldEmbedded/QFieldEmbedded.h>
#import "QFieldWrapper.h"
#import <vector>

@implementation QFieldWrapper : NSObject

- (int)runQField {
    NSString *executablePath = NSBundle.mainBundle.executablePath;
    char *argv[] = {(char *)[executablePath fileSystemRepresentation]};
    
    int argc = sizeof(argv) / sizeof(argv[0]);
    for (int i = 0; i < argc; i++) {
        NSLog(@"argv[%d]: %s", i, argv[i]);
    }
    
    return qfe::run(1, argv);
}

- (int)loadProject:(nonnull NSString *)path zoomToProject:(BOOL)zoom absolutePath:(BOOL)absolute {
    const char *cpath = [path fileSystemRepresentation];
    return qfe::project(cpath, zoom, absolute);
}

- (int)bootQField {
    return qfe::boot(true);
}

- (int)widget:(UIView *)nativeController {
    qfe::widget(nativeController);
}

- (void)zoomIn {
    qfe::zoomIn();
}

- (void)zoomOut {
    qfe::zoomOut();
}

- (void)moveUp {
    qfe::moveUp();
}

- (void)moveDown {
    qfe::moveDown();
}

- (void)moveLeft {
    qfe::moveLeft();
}

- (void)moveRight {
    qfe::moveRight();
}

@end
