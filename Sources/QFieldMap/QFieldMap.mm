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

- (int)addLayerRoot:(nonnull NSString *)layerPath absolutePath:(bool)absolute {
	const char *cPath = [layerPath fileSystemRepresentation];
	qfe::addLayerRoot(cPath, absolute);
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



- (void)registerCanvasExtentChangedCallback:(int)canvasId completion:(void (^)(int canvasId, NSString *stateJson))completion {
	_canvasExtentChangedCompletion = [completion copy];
	qfe::registerCanvasExtentChangedCallback(canvasId, canvasExtentChangedCallback);
}

static void (^_canvasExtentChangedCompletion)(int canvasId, NSString *stateJson);
static void canvasExtentChangedCallback(int canvasId, const char* stateJson) {
	if (_canvasExtentChangedCompletion) {
		NSString *state = stateJson ? [NSString stringWithUTF8String:stateJson] : nil;
		_canvasExtentChangedCompletion(canvasId, state);
	}
}



- (void)registerCanvasRenderingChangedCallback:(int)canvasId completion:(void (^)(int canvasId, bool isRendering))completion {
	_canvasRenderingChangedCompletion = [completion copy];
	qfe::registerCanvasRenderingChangedCallback(canvasId, canvasRenderingChangedCallback);
}

static void (^_canvasRenderingChangedCompletion)(int canvasId, bool isRendering);
static void canvasRenderingChangedCallback(int canvasId, bool isRendering) {
	if (_canvasRenderingChangedCompletion) {
		_canvasRenderingChangedCompletion(canvasId, isRendering);
	}
}



- (void)registerRuntimeBusyChangedCallback:(void (^)(bool busy))completion {
	_runtimeBusyChangedCompletion = [completion copy];
	qfe::registerRuntimeBusyChangedCallback(runtimeBusyChangedCallback);
}

static void (^_runtimeBusyChangedCompletion)(bool busy);
static void runtimeBusyChangedCallback(bool busy) {
	if (_runtimeBusyChangedCompletion) {
		_runtimeBusyChangedCompletion(busy);
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




// MARK: - ============ Feature Selection ============

/**
 * @brief Selects features in a vector layer by their feature IDs.
 *
 * Selected features are highlighted in the layer's selection color on every
 * canvas displaying the layer.
 *
 * @param layerId The QGIS layer ID of the target vector layer
 * @param fidsJson JSON array of feature IDs, e.g. "[1,2,3]"
 * @param behavior Selection behavior: 0=Set, 1=Add, 2=Intersect, 3=Remove
 * @return 0 on success, non-zero error code on failure
 */
- (int) selectFeatures:(nonnull NSString *) layerId fidsJson:(NSString *) fidsJson behavior:(int) behavior {
	const char *layerIdChars = strdup([layerId UTF8String]);
	const char *fidsJsonChars = strdup([fidsJson UTF8String]);
	return qfe::selectFeatures(layerIdChars, fidsJsonChars, behavior);
}

/**
 * @brief Selects features in a vector layer matching a QGIS expression.
 *
 * @param layerId The QGIS layer ID of the target vector layer
 * @param expression QGIS expression (e.g. "status = 'open'")
 * @param behavior Selection behavior: 0=Set, 1=Add, 2=Intersect, 3=Remove
 * @return 0 on success, non-zero error code on failure
 */
- (int) selectFeaturesByExpression:(nonnull NSString *) layerId fidsJson:(nonnull NSString *) fidsJson behavior:(int) behavior {
	const char *layerIdChars = strdup([layerId UTF8String]);
	const char *fidsJsonChars = strdup([fidsJson UTF8String]);
	return qfe::selectFeaturesByExpression(layerIdChars, fidsJsonChars, behavior);
}

/**
 * @brief Selects all features in a vector layer.
 *
 * @param layerId The QGIS layer ID of the target vector layer
 * @return 0 on success, non-zero error code on failure
 */
- (int) selectAllFeatures:(nonnull NSString*) layerId {
	const char *layerIdChars = strdup([layerId UTF8String]);
	return qfe::selectAllFeatures(layerIdChars);
}

/**
 * @brief Inverts the selection of a vector layer.
 *
 * @param layerId The QGIS layer ID of the target vector layer
 * @return 0 on success, non-zero error code on failure
 */
- (int) invertSelection:(nonnull NSString*) layerId {
	const char *layerIdChars = strdup([layerId UTF8String]);
	return qfe::invertSelection(layerIdChars);
}

/**
 * @brief Clears the selection of a vector layer.
 *
 * @param layerId The QGIS layer ID of the target vector layer
 * @return 0 on success, non-zero error code on failure
 */
- (int) clearSelection:(nonnull NSString*) layerId {
	const char *layerIdChars = strdup([layerId UTF8String]);
	return qfe::clearSelection(layerIdChars);
}

/**
 * @brief Gets the IDs of the selected features in a vector layer as JSON.
 *
 * @param layerId The QGIS layer ID of the target vector layer
 * @return JSON object {"type":"SelectedFeatures","layerId":...,"count":N,"fids":[...]}, or empty string on error
 */
- (nonnull NSString *) getSelectedFeatureIds:(NSString*) layerId {
	const char *layerIdChars = strdup([layerId UTF8String]);
	const char *featureIds = qfe::getSelectedFeatureIds(layerIdChars);
	NSString *string = [NSString stringWithUTF8String:featureIds];
	return string;

}

/**
 * @brief Gets the number of selected features in a vector layer.
 *
 * @param layerId The QGIS layer ID of the target vector layer
 * @return Selected feature count, or -1 on error
 */
- (int) getSelectedFeatureCount:(nonnull NSString*) layerId {
	const char *layerIdChars = strdup([layerId UTF8String]);
	return qfe::getSelectedFeatureCount(layerIdChars);
}

/**
 * @brief Zooms a canvas to the bounding box of the selected features of a layer.
 *
 * @param canvasId The ID of the canvas to zoom, or ALL_CANVASES
 * @param layerId The QGIS layer ID of the target vector layer
 */
- (void) zoomCanvasToSelection:(int) canvasId layerId:(nonnull NSString*)layerId {
	const char *layerIdChars = strdup([layerId UTF8String]);
	qfe::zoomCanvasToSelection(canvasId, layerIdChars);
}



@end
