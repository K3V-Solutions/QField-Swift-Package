//
//  QFieldWrapper.m
//  QField
//
//  Created by Juan Carlos Aguilar Garcia on 24.06.25.
//


#import <Foundation/Foundation.h>
#import <QFieldEmbedded/QFieldEmbedded.h>
#import "QFieldMap.h"
#import <vector>
#import <fstream>

@implementation QFieldMap : NSObject

- (bool)runQField {
    NSString *executablePath = NSBundle.mainBundle.executablePath;
    char *argv[] = {(char *)[executablePath fileSystemRepresentation]};
    return qfe::run(1, argv) == 0;
}


- (bool)loadProject:(nonnull NSString *)path zoomToProject:(bool)zoom absolutePath:(bool)absolute {
    const char *cpath = [path fileSystemRepresentation];
	const char *absolutePath = strdup([path UTF8String]);

	return qfe::loadProject(cpath, zoom, absolute) == 0;
}



- (bool)bootQField {
    return qfe::boot(true) == 0;
}



- (bool)widget:(UIView *)view {
    return qfe::widget(view) == 0;
}



- (CANVAS_ID)allCanvases {
	return qfe::ALL_CANVASES;
}



// MARK: - ============ Result Set API (Cursor Pattern) ============

- (NSString *)getActiveResultSets {
	const char *cString = qfe::getActiveResultSets();
	NSString *string = [NSString stringWithUTF8String:cString];
	return string;
}



- (void)closeResultSet:(RESULTSET_ID)resultSetId {
	qfe::closeResultSet(resultSetId);
}



- (NSString *)getResultSetMetadata:(RESULTSET_ID)resultSetId {
	const char *cString = qfe::getResultSetMetadata(resultSetId);
	NSString *string = [NSString stringWithUTF8String:cString];
	return string;
}



- (long)getResultSetCount:(RESULTSET_ID)resultSetId {
	return qfe::getResultSetCount(resultSetId);
}



- (NSString *)fetchResultSetBatch:(RESULTSET_ID)resultSetId offset:(long)offset limit:(long)limit {
	const char *cString =  qfe::fetchResultSetBatch(resultSetId, offset, limit);
	NSString *string = [NSString stringWithUTF8String:cString];
	return string;
}



// MARK: - ============ Layer Management ============

- (int)addLayerRoot:(nonnull char *)layerPath absolutePath:(bool)absolute {
	qfe::addLayerRoot(layerPath, absolute);
}


- (int)addLayerGroup:(nonnull NSString *)layerPath expression:(nonnull NSString *)expression absolutePath:(bool)absolute {
	const char *cpath = [layerPath fileSystemRepresentation];
	const char *expressionString = strdup([expression UTF8String]);
	qfe::addLayerGroup(cpath, expressionString, absolute);
}


- (NSString *)getLayerId:(NSString *)expression {
	const char *expressionChars = strdup([expression UTF8String]);
	const char *cString = qfe::getLayerId(expressionChars);
	NSString *string = [NSString stringWithUTF8String:cString];
	return string;
}


- (NSString *)getLayerTree {
	const char *cString = qfe::getLayerTree();
	NSString *string = [NSString stringWithUTF8String:cString];
	return string;
}



- (bool)getLayerVisibility:(NSString *)layerId {
	const char *layerIdChars = strdup([layerId UTF8String]);
	return qfe::getLayerVisibility(layerIdChars);
}



- (void)setLayerVisibility:(NSString *)layerId visible:(bool)visible {
	const char *layerIdChars = strdup([layerId UTF8String]);
	qfe::setLayerVisibility(layerIdChars, visible);
}



- (bool)toggleLayerVisibility:(nonnull NSString *)layerId {
	const char *chars = strdup([layerId UTF8String]);
	return qfe::toggleLayerVisibility(chars);
}



- (bool)getGroupVisibility:(nonnull NSString *)expression {
	const char *expressionChars = strdup([expression UTF8String]);
	return qfe::getGroupVisibility(expressionChars);
}



- (void)setGroupVisibility:(nonnull NSString *)expression visible:(bool)visible {
	const char *chars = strdup([expression UTF8String]);
	qfe::setGroupVisibility(chars, visible);
}



- (bool)toggleGroupVisibility:(nonnull NSString *)expression {
	const char *chars = strdup([expression UTF8String]);
	return qfe::toggleGroupVisibility(chars);
}



- (double)getCanvasScale:(int)canvasId {
	return qfe::getCanvasScale(canvasId);
}



- (nonnull NSString *)getCanvasCenter:(int)canvasId {
	const char *cString = qfe::getCanvasCenter(canvasId);
	NSString *string = [NSString stringWithUTF8String:cString];
	return string;
}



- (nonnull NSString *)getCanvasExtent:(int)canvasId {
	const char *cString = qfe::getCanvasExtent(canvasId);
	NSString *string = [NSString stringWithUTF8String:cString];
	return string;
}


// MARK: - ============ Canvas Zoom ============

- (void)zoomIn:(int)canvasId {
	qfe::zoomCanvasIn(canvasId);
}



- (void)zoomOut:(int)canvasId {
	qfe::zoomCanvasOut(canvasId);
}



- (void)zoomCanvasToBookmark:(int)canvasId bookmarkName:(nonnull NSString *)bookmarkName {
	const char *chars = strdup([bookmarkName UTF8String]);
	qfe::zoomCanvasToBookmark(canvasId, chars);
}



- (void)zoomCanvasToPoint:(int)canvasId x:(double)x y:(double)y scale:(double)scale {
	qfe::zoomCanvasToPoint(canvasId, x, y, scale);
}



- (void)zoomCanvasToVisibleExtent:(int)canvasId {
	qfe::zoomCanvasToVisibleExtent(canvasId);
}



- (void)zoomCanvasToProjectExtent:(int)canvasId {
	qfe::zoomCanvasToProjectExtent(canvasId);
}



- (void *)zoomCanvasToRectangle:(int)canvasId xMin:(double)minX yMin:(double)minY xMax:(double)maxX yMax:(double)maxY {
	qfe::zoomCanvasToRectangle(canvasId, minX, minY, maxX, maxY);
}



- (void)moveUp:(int)canvasId {
	qfe::moveCanvasUp(canvasId);
}



- (void)moveDown:(int)canvasId {
	qfe::moveCanvasDown(canvasId);
}



- (void)moveLeft:(int)canvasId {
	qfe::moveCanvasLeft(canvasId);
}



- (void)moveRight:(int)canvasId {
	qfe::moveCanvasRight(canvasId);
}



// MARK: -============ Feature Queries ============

- (nonnull NSString *)queryFeaturesJSON:(nonnull NSString *)query {
	const char *queryChars = strdup([query UTF8String]);
	const char *cString = qfe::queryFeaturesJson(queryChars);
	NSString *string = [NSString stringWithUTF8String:cString];
	return string;
}



- (RESULTSET_ID)queryFeaturesResultSet:(nonnull NSString *)query {
	const char *queryChars = strdup([query UTF8String]);
	const RESULTSET_ID resultSetId = qfe::queryFeaturesResultSet(queryChars);
	return resultSetId;
}



// MARK: - ============ Feature Identification ============

- (void)registerCanvasIdentificationCallbackJSON:(int)canvasId completion:(void (^)(NSString *json))completion {
	_jsonCompletion = [completion copy];
	qfe::registerCanvasIdentificationCallbackJson(canvasId, jsonCallback);
}

static void (^_jsonCompletion)(NSString *);

static void jsonCallback(const char *json) {
	if (_jsonCompletion) {
		NSString *result = json ? [NSString stringWithUTF8String:json] : nil;
		_jsonCompletion(result);
	}
}



- (void)registerCanvasIdentificationCallbackResultSet:(int)canvasId completion:(void (^)(RESULTSET_ID resultSetId))completion {
	_resultSetCompletion = [completion copy];
	qfe::registerCanvasIdentificationCallbackResultSet(canvasId, resultSetCallback);
}

static void (^_resultSetCompletion)(RESULTSET_ID resultSetId);

static void resultSetCallback(RESULTSET_ID resultSetId) {
	if (_resultSetCompletion) {
		_resultSetCompletion(resultSetId);
	}
}



// MARK: - ============ Virtual Layer ============

- (nonnull NSString *)addVirtualLayer:(nonnull NSString *)query name:(nonnull NSString *)name stylePath:(nonnull NSString *)stylePath absolute:(bool)absolute {
	const char *queryChars = strdup([query UTF8String]);
	const char *nameChars = strdup([name UTF8String]);
	const char *stylePathChars = strdup([stylePath UTF8String]);
	qfe::addVirtualLayer(queryChars, nameChars, stylePathChars, absolute);
}

- (int)removeVirtualLayer:(nonnull NSString *)layerId {
	const char *layerIdChars = strdup([layerId UTF8String]);
	qfe::removeVirtualLayer(layerIdChars);
}

- (int)setVirtualLayerSql:(nonnull NSString *)layerId query:(nonnull NSString *)query {
	const char *layerIdChars = strdup([layerId UTF8String]);
	const char *queryChars = strdup([query UTF8String]);
	qfe::setVirtualLayerSql(layerIdChars, queryChars);
}

- (int)setVirtualLayerStyle:(nonnull NSString *)layerId stylePath:(nonnull NSString *)stylePath absolute:(bool)absolute {
	const char *layerIdChars = strdup([layerId UTF8String]);
	const char *stylePathChars = strdup([stylePath UTF8String]);
	qfe::setVirtualLayerStyle(layerIdChars, stylePathChars, absolute);
}

@end
