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

- (int)runQField {
    NSString *executablePath = NSBundle.mainBundle.executablePath;
    char *argv[] = {(char *)[executablePath fileSystemRepresentation]};
    return qfe::run(1, argv);
}


- (int)loadProject:(nonnull NSString *)path zoomToProject:(BOOL)zoom absolutePath:(BOOL)absolute {
    const char *cpath = [path fileSystemRepresentation];
	const char *absolutePath = strdup([path UTF8String]);

	return qfe::loadProject(cpath, zoom, absolute);
}



- (int)bootQField {
    return qfe::boot(true);
}



- (int)widget:(UIView *)view {
    qfe::widget(view);
}



- (CANVAS_ID)allCanvases {
	return qfe::ALL_CANVASES;
}



// ============ Result Set API (Cursor Pattern) ============

/**
 * @brief Gets list of all active result set IDs as JSON.
 *
 * Useful for debugging and cleanup operations.
 *
 * @return JSON array of result set IDs: "[2001, 2002, ...]"
 */
- (NSString *)getActiveResultSets {
	const char *cString = qfe::getActiveResultSets();
	NSString *string = [NSString stringWithUTF8String:cString];
	return string;
}



/**
 * @brief Closes and frees a result set.
 *
 * Releases all resources associated with the result set.
 * The result set ID becomes invalid after this call.
 *
 * @param resultSetId The result set handle to close
 */
- (void)closeResultSet:(RESULTSET_ID)resultSetId {
	qfe::closeResultSet(resultSetId);
}



/**
 * @brief Gets metadata about a result set as JSON.
 *
 * Returns: {"id": int, "type": "sql"|"identify", "featureCount": int,
 *           "fields": [...], "geometryType": string, "crs": string}
 *
 * @param resultSetId The result set handle
 * @return JSON string with metadata, or empty string if not found
 */
- (NSString *)getResultSetMetadata:(RESULTSET_ID)resultSetId {
	const char *cString = qfe::getResultSetMetadata(resultSetId);
	NSString *string = [NSString stringWithUTF8String:cString];
	return string;
}



/**
 * @brief Gets the total count of features in a result set.
 *
 * @param resultSetId The result set handle
 * @return Feature count, or -1 on error
 */
- (long)getResultSetCount:(RESULTSET_ID)resultSetId {
	return qfe::getResultSetCount(resultSetId);
}



/**
 * @brief Fetches a batch of features from a result set.
 *
 * Supports random access via offset/limit parameters.
 *
 * @param resultSetId The result set handle
 * @param offset Starting position (0-based)
 * @param limit Maximum features to return (-1 for all remaining)
 * @return JSON string with features, or empty string on error
 */
- (NSString *)fetchResultSetBatch:(RESULTSET_ID)resultSetId offset:(long)offset limit:(long)limit {
	const char *cString =  qfe::fetchResultSetBatch(resultSetId, offset, limit);
	NSString *string = [NSString stringWithUTF8String:cString];
	return string;
}



// ============ Layer Management ============

/**
 * @brief Adds a layer definition file to the root of the layer tree.
 *
 * This function loads a QGIS layer definition (.qlr) file and adds all
 * contained layers to the root of the current project's layer tree.
 *
 * @param layerPath Path to the layer definition file to add
 * @param absolutePath Whether the layerPath is absolute (true) or relative to app bundle (false)
 * @return 0 on success, non-zero error code on failure
 */
- (int)addLayerRoot:(nonnull char *)layerPath absolutePath:(bool)absolute {
	qfe::addLayerRoot(layerPath, absolute);
}



/**
 * @brief Adds a layer definition file to a specific group in the layer tree.
 *
 * This function loads a QGIS layer definition (.qlr) file and adds all
 * contained layers to the specified group in the layer tree. The group
 * is created if it doesn't exist.
 *
 * @param layerPath Path to the layer definition file to add
 * @param expression Group path expression (e.g., "Group1|SubGroup")
 * @param absolutePath Whether the layerPath is absolute (true) or relative to app bundle (false)
 * @return 0 on success, non-zero error code on failure
 */
- (int)addLayerGroup:(nonnull NSString *)layerPath expression:(nonnull NSString *)expression absolutePath:(bool)absolute {
	const char *cpath = [layerPath fileSystemRepresentation];
	const char *expressionString = strdup([expression UTF8String]);
	qfe::addLayerGroup(cpath, expressionString, absolute);
}



/**
 * @brief Gets the layer ID from a layer expression.
 *
 * This function resolves a layer expression to its actual layer ID, which can then
 * be used with other layer functions like toggleLayerVisibility, setLayerVisibility, etc.
 *
 * @param expression Layer expression (e.g., "layerName" or "Group1|SubGroup|layerName")
 * @return The layer ID as a C string, or empty string if layer not found
 */
- (NSString *)getLayerId:(NSString *)expression {
	const char *expressionChars = strdup([expression UTF8String]);
	const char *cString = qfe::getLayerId(expressionChars);
	NSString *string = [NSString stringWithUTF8String:cString];
	return string;
}



/**
 * @brief Gets the layer tree structure as a JSON string.
 *
 * This function returns the complete layer tree structure including groups and layers
 * with their IDs, names, types, and hierarchical relationships. The returned JSON
 * contains an array of objects where each object represents either a layer or group.
 * Groups contain a 'children' array with their nested items.
 *
 * @return JSON string representing the layer tree structure
 */
- (NSString *)getLayerTree {
	const char *cString = qfe::getLayerTree();
	NSString *string = [NSString stringWithUTF8String:cString];
	return string;
}



/**
 * @brief Gets the visibility state of a layer by its ID.
 *
 * @param layerId The unique identifier of the layer
 * @return true if the layer is visible, false if hidden or layer not found
 */
- (bool)getLayerVisibility:(NSString *)layerId {
	const char *layerIdChars = strdup([layerId UTF8String]);
	return qfe::getLayerVisibility(layerIdChars);
}



/**
 * @brief Sets the visibility state of a layer by its ID.
 *
 * @param layerId The unique identifier of the layer
 * @param visible true to make the layer visible, false to hide it
 */
- (void)setLayerVisibility:(NSString *)layerId visible:(bool)visible {
	const char *layerIdChars = strdup([layerId UTF8String]);
	qfe::setLayerVisibility(layerIdChars, visible);
}



/**
 * @brief Toggles the visibility state of a layer by its ID.
 *
 * @param layerId The unique identifier of the layer
 * @return true if the layer is now visible after toggling, false if now hidden or layer not found
 */
- (bool)toggleLayerVisibility:(nonnull NSString *)layerId {
	const char *chars = strdup([layerId UTF8String]);
	return qfe::toggleLayerVisibility(chars);
}



/**
 * @brief Gets the visibility state of a layer group by its path expression.
 *
 * @param expression Group path expression (e.g., "Group1|SubGroup")
 * @return true if the group is visible, false if hidden or group not found
 */
- (bool)getGroupVisibility:(nonnull NSString *)expression {
	const char *expressionChars = strdup([expression UTF8String]);
	return qfe::getGroupVisibility(expressionChars);
}



/**
 * @brief Sets the visibility state of a layer group by its path expression.
 *
 * @param expression Group path expression (e.g., "Group1|SubGroup")
 * @param visible true to make the group visible, false to hide it
 */
- (void)setGroupVisibility:(nonnull NSString *)expression visible:(bool)visible {
	const char *chars = strdup([expression UTF8String]);
	qfe::setGroupVisibility(chars, visible);
}



/**
 * @brief Toggles the visibility state of a layer group by its path expression.
 *
 * @param expression Group path expression (e.g., "Group1|SubGroup")
 * @return true if the group is now visible after toggling, false if now hidden or group not found
 */
- (bool)toggleGroupVisibility:(nonnull NSString *)expression {
	const char *chars = strdup([expression UTF8String]);
	return qfe::toggleGroupVisibility(chars);
}



/**
 * @brief Gets the current map scale of a specific canvas.
 *
 * Returns the scale denominator of the map (e.g., 1000 for a 1:1000 scale map).
 * If the canvas is not found, returns a negative error code.
 *
 * @param canvasId The ID of the canvas to query
 * @return The map scale denominator, or negative error code if canvas not found
 */
- (double)getCanvasScale:(int)canvasId {
	return qfe::getCanvasScale(canvasId);
}



/**
 * @brief Gets the center point of a specific canvas as JSON.
 *
 * Returns a JSON string containing the center coordinates and CRS of the canvas.
 * Format: {"x": <double>, "y": <double>, "crs": "<auth_id>"}
 *
 * @param canvasId The ID of the canvas to query
 * @return JSON string with center point information, or empty JSON object if canvas not found
 */
- (nonnull NSString *)getCanvasCenter:(int)canvasId {
	const char *cString = qfe::getCanvasCenter(canvasId);
	NSString *string = [NSString stringWithUTF8String:cString];
	return string;
}



/**
* @brief Gets the current extent of a specific canvas as JSON.
*
* Returns a JSON string containing the bounding box and CRS of the canvas.
* Format: {"xMin": <double>, "yMin": <double>, "xMax": <double>, "yMax": <double>, "crs": "<auth_id>"}
*
* @param canvasId The ID of the canvas to query
* @return JSON string with extent information, or empty JSON object if canvas not found
*/
- (nonnull NSString *)getCanvasExtent:(int)canvasId {
	const char *cString = qfe::getCanvasExtent(canvasId);
	NSString *string = [NSString stringWithUTF8String:cString];
	return string;
}



// ============ Canvas Zoom ============

/**
 * @brief Zooms in on a specific map canvas.
 *
 * @param canvasId The ID of the canvas to zoom in on, or ALL_CANVASES to zoom in on all canvases
 */
- (void)zoomIn:(int)canvasId {
	qfe::zoomCanvasIn(canvasId);
}



/**
 * @brief Zooms out on a specific map canvas.
 *
 * @param canvasId The ID of the canvas to zoom out on, or ALL_CANVASES to zoom out on all canvases
 */
- (void)zoomOut:(int)canvasId {
	qfe::zoomCanvasOut(canvasId);
}



/**
 * @brief Zooms a specific map canvas to a named bookmark.
 *
 * Searches for a bookmark by name (case-insensitive) and zooms the canvas
 * to that bookmark's extent. If the bookmark is not found, a warning is logged.
 *
 * @param canvasId The ID of the canvas to zoom, or ALL_CANVASES to zoom all canvases
 * @param bookmarkName The name of the bookmark to zoom to
 */
- (void)zoomCanvasToBookmark:(int)canvasId bookmarkName:(nonnull NSString *)bookmarkName {
	const char *chars = strdup([bookmarkName UTF8String]);
	qfe::zoomCanvasToBookmark(canvasId, chars);
}



/**
 * @brief Zooms a specific map canvas to a point at a given scale.
 *
 * Centers the canvas on the specified point and sets the map scale.
 * Coordinates should be in the project's coordinate reference system.
 *
 * @param canvasId The ID of the canvas to zoom, or ALL_CANVASES to zoom all canvases
 * @param x The X coordinate of the center point (in project CRS)
 * @param y The Y coordinate of the center point (in project CRS)
 * @param scale The map scale denominator (e.g., 1000 for 1:1000)
 */
- (void)zoomCanvasToPoint:(int)canvasId x:(double)x y:(double)y scale:(double)scale {
	qfe::zoomCanvasToPoint(canvasId, x, y, scale);
}



/**
 * @brief Zooms the canvas to the visible extent of all layers.
 *
 * This function adjusts the canvas view to show the combined extent of all
 * visible layers in the project.
 *
 * @param canvasId The ID of the canvas to zoom, or ALL_CANVASES to zoom all canvases
 */
- (void)zoomCanvasToVisibleExtent:(int)canvasId {
	qfe::zoomCanvasToVisibleExtent(canvasId);
}



/**
 * @brief Zooms a specific map canvas to the project's configured extent.
 *
 * Uses the preset full extent from the project's view settings (configured in
 * QGIS Desktop under Project -> Properties -> View Settings). If no project extent
 * is configured, this function is a no-op.
 *
 * @param canvasId The ID of the canvas to zoom, or ALL_CANVASES to zoom all canvases
 */
- (void)zoomCanvasToProjectExtent:(int)canvasId {
	qfe::zoomCanvasToProjectExtent(canvasId);
}



/**
 * @brief Zooms a specific map canvas to a rectangular extent.
 *
 * Sets the canvas extent to the specified rectangle.
 * Coordinates should be in the project's coordinate reference system.
 *
 * @param canvasId The ID of the canvas to zoom, or ALL_CANVASES to zoom all canvases
 * @param xMin The minimum X coordinate (in project CRS)
 * @param yMin The minimum Y coordinate (in project CRS)
 * @param xMax The maximum X coordinate (in project CRS)
 * @param yMax The maximum Y coordinate (in project CRS)
 */
- (void)zoomCanvasToRectangle:(int)canvasId xMin:(double)minX yMin:(double)minY xMax:(double)maxX yMax:(double)maxY {
	qfe::zoomCanvasToRectangle(canvasId, minX, minY, maxX, maxY);
}



/**
 * @brief Moves a specific map canvas view upward.
 *
 * @param canvasId The ID of the canvas to move, or ALL_CANVASES to move all canvases
 */
- (void)moveUp:(int)canvasId {
	qfe::moveCanvasUp(canvasId);
}



/**
 * @brief Moves a specific map canvas view to the left.
 *
 * @param canvasId The ID of the canvas to move, or ALL_CANVASES to move all canvases
 */
- (void)moveDown:(int)canvasId {
	qfe::moveCanvasDown(canvasId);
}



/**
 * @brief Moves a specific map canvas view to the left.
 *
 * @param canvasId The ID of the canvas to move, or ALL_CANVASES to move all canvases
 */
- (void)moveLeft:(int)canvasId {
	qfe::moveCanvasLeft(canvasId);
}



/**
 * @brief Moves a specific map canvas view to the right.
 *
 * @param canvasId The ID of the canvas to move, or ALL_CANVASES to move all canvases
 */
- (void)moveRight:(int)canvasId {
	qfe::moveCanvasRight(canvasId);
}



// ============ Feature Queries ============

/**
 * @brief Queries features using a SQL query.
 *
 * This function executes a SQL query against project layers using QGIS virtual
 * layer functionality. Results are returned as a GeoJSON string containing
 * matching features with their attributes and geometry.
 *
 * For large result sets, consider using queryFeaturesResultSet() instead.
 *
 * @param query SQL query string (e.g., "SELECT * FROM my_layer WHERE name = 'value'")
 * @return GeoJSON string containing matching features, or empty string on error
 */
- (nonnull NSString *)queryFeaturesJSON:(nonnull NSString *)query {
	const char *queryChars = strdup([query UTF8String]);
	const char *cString = qfe::queryFeaturesJson(queryChars);
	NSString *string = [NSString stringWithUTF8String:cString];
	return string;
}



/**
 * @brief Queries features and returns a result set handle for paginated access.
 *
 * Unlike queryFeaturesJson() which returns all results as a single JSON string,
 * this returns a handle that can be used to fetch results in batches.
 * Use this for large result sets that shouldn't be serialized at once.
 *
 * @param query SQL query string (e.g., "SELECT * FROM my_layer WHERE ...")
 * @return Result set ID on success (>= 2000), -1 on error
 */
- (RESULTSET_ID)queryFeaturesResultSet:(nonnull NSString *)query {
	const char *queryChars = strdup([query UTF8String]);
	const RESULTSET_ID resultSetId = qfe::queryFeaturesResultSet(queryChars);
	return resultSetId;
}



// ============ Feature Identification ============

/**
 * @brief Registers a callback for feature identification on a specific canvas.
 *
 * The callback function will be invoked when a feature is identified (tapped)
 * on the specified map canvas. The callback receives feature information as JSON.
 *
 * For large result sets, consider using registerCanvasIdentificationCallbackResultSet() instead.
 *
 * @param canvasId The ID of the canvas to register the callback for, or ALL_CANVASES for all canvases
 * @param callback Function pointer to be called with JSON feature data
 */
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



/**
 * @brief Registers a callback for feature identification that returns a result set handle.
 *
 * The callback function will be invoked when a feature is identified (tapped)
 * on the specified map canvas. The callback receives a result set ID that can be
 * used with fetchResultSetBatch() for paginated access to the identified features.
 *
 * @param canvasId The ID of the canvas to register the callback for, or ALL_CANVASES for all canvases
 * @param callback Function pointer to be called with result set ID
 */
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



@end
