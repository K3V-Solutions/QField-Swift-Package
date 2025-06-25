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
    
    return runQFieldEmbedded(1, argv);
}

- (int)loadProject:(nonnull NSString *)path zoomToProject:(BOOL)zoom absolutePath:(BOOL)absolute {
    return QfeProject(path.UTF8String, zoom, absolute);
}

- (int)bootQField {
    return bootQFieldEmbedded();
}

- (void)zoomIn {
    QfeZoomIn();
}

- (void)zoomOut {
    QfeZoomOut();
}

- (void)moveUp {
    QfeMoveUp();
}

- (void)moveDown {
    QfeMoveDown();
}

- (void)moveLeft {
    QfeMoveLeft();
}

- (void)moveRight {
    QfeMoveRight();
}

@end
