//
//  QFieldWrapper.h
//  QField
//
//  Created by Juan Carlos Aguilar Garcia on 24.06.25.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QFieldMap : NSObject

typedef int CANVAS_ID;
typedef int RESULTSET_ID;

- (int) bootQField;
- (int) runQField;
- (int) widget:(UIView *)view;
- (int) loadProject:(NSString *)path zoomToProject:(bool)zoom absolutePath:(bool)absolute;

- (CANVAS_ID)allCanvases;
- (NSString *)getActiveResultSets;
- (void) closeResultSet:(RESULTSET_ID)resultSetId;
- (NSString *)getResultSetMetadata:(RESULTSET_ID) resultSetId;
- (long)getResultSetCount:(RESULTSET_ID) resultSetId;
- (NSString *) fetchResultSetBatch:(RESULTSET_ID)resultSetId offset:(long)offset limit:(long)limit;

- (int) addLayerRoot:(char *)layerPath absolutePath:(bool)absolute;
- (int) addLayerGroup:(NSString *)layerPath expression:(NSString *)expression absolutePath:(bool)absolute;
- (NSString *) getLayerId:(NSString *)expression;
- (NSString *) getLayerTree;
- (bool) getLayerVisibility:(NSString *)layerId;
- (void) setLayerVisibility:(NSString *)layerId visible:(bool)visible;
- (bool) toggleLayerVisibility:(NSString *)layerId;

- (bool) getGroupVisibility:(NSString *)expression;
- (void) setGroupVisibility:(NSString *)expression visible:(bool)visible;
- (bool) toggleGroupVisibility:(NSString *)expression;

- (double) getCanvasScale:(int)canvasId;
- (NSString *) getCanvasCenter:(int)canvasId;
- (NSString *) getCanvasExtent:(int)canvasId;

- (NSString *) queryFeaturesJSON:(NSString *)query;
- (RESULTSET_ID) queryFeaturesResultSet:(NSString *)query;
- (void) registerCanvasIdentificationCallbackJSON:(int)canvasId completion:(void (^)(NSString* json)) completion;
- (void) registerCanvasIdentificationCallbackResultSet:(int)canvasId completion:(void (^)(RESULTSET_ID resultSetId))completion;

- (void) zoomCanvasToVisibleExtent:(int)canvasId;
- (void) zoomCanvasToProjectExtent:(int)canvasId;
- (void) zoomCanvasToBookmark:(int)canvasId bookmarkName:(NSString *)bookmarkName;
- (void) zoomCanvasToPoint:(int)canvasId x:(double)x y:(double)y scale:(double)scale;
- (void) zoomCanvasToRectangle:(int)canvasId xMin:(double)minX yMin:(double)minY xMax:(double)maxX yMax:(double)maxY;

- (void) zoomIn:(int)canvasId;
- (void) zoomOut:(int)canvasId;
- (void) moveUp:(int)canvasId;
- (void) moveDown:(int)canvasId;
- (void) moveLeft:(int)canvasId;
- (void) moveRight:(int)canvasId;

@end

NS_ASSUME_NONNULL_END
