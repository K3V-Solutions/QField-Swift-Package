//
//  QFieldMap.h
//  QField
//
//  Created by Juan Carlos Aguilar Garcia on 24.06.25.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QFieldMap : NSObject


/**
 * @brief Type alias for canvas handles
 *
 * Canvas IDs are assigned starting from 1000.
 */
typedef int CANVAS_ID;


/**
 * @brief Type alias for result set handles
 *
 * Result set IDs are assigned starting from 2000 to avoid collision with CANVAS_ID.
 * Used by queryFeaturesResultSet() and identification callbacks.
 */
typedef int RESULTSET_ID;


/**
 * @brief Initializes the QFieldEmbedded system on iOS (must be called from main thread).
 *
 * This function performs the necessary startup routines required to initialize
 * the QFieldEmbedded environment. It configures the QGIS backend for iOS and
 * must be called from the main UI thread before any other API functions.
 *
 * @param debug If true, enables debug mode for detailed logging and troubleshooting
 * @return 0 on successful initialization, non-zero error code on failure
 */
- (bool) bootQField;


/**
 * @brief Initializes the QFieldEmbedded system on iOS (must be called from main thread).
 *
 * This function performs the necessary startup routines required to initialize
 * the QFieldEmbedded environment. It configures the QGIS backend for iOS and
 * must be called from the main UI thread before any other API functions.
 *
 * @param debug If true, enables debug mode for detailed logging and troubleshooting
 * @return 0 on successful initialization, non-zero error code on failure
 */
- (bool) runQField;


/**
 * @brief Creates a QField map canvas within the specified UIView container.
 *
 * This function creates a new interactive map canvas and embeds it within the
 * provided UIView container. The canvas will handle map rendering, user interactions,
 * and layer management. Call this after successful `boot()` and `run()` execution.
 *
 * @param nativeContainer Pointer to the UIView that will contain the map canvas
 * @return 0 on success, non-zero error code on failure
 */
- (bool) widget:(UIView *)view;


/**
 * @brief Loads a QGIS project file into the map canvas.
 *
 * This function loads a QGIS project (.qgs or .qgz) file and displays it
 * in all active map canvases. The project path can be relative to the app
 * bundle or absolute.
 *
 * @param projectPath Path to the QGIS project file to load
 * @param zoomToProject Whether to zoom the canvas to fit the project extent
 * @param absolutePath Whether the projectPath is absolute (true) or relative to app bundle (false)
 * @return true on success, non-zero error code on failure
 */
- (bool) loadProject:(NSString *)path zoomToProject:(bool)zoom absolutePath:(bool)absolute;


/**
 * @brief Reloads the currently loaded project from disk (re-reads the .qgs/.qgz file).
 *
 * Use when the project file or its source files changed structurally. Heavier
 * than reloadAllLayers().
 *
 * @param zoomToProject Whether to re-zoom to the project extent (false preserves the current view)
 * @return 0 on success, non-zero error code on failure (e.g. no project loaded)
 */
int reloadProject(bool zoomToProject);

/**
 * @brief Reloads every layer's data provider project-wide (QgsProject::reloadAllLayers()).
 *
 * Use when a source file's data changed. Lighter than reloadProject() and preserves the view.
 *
 * @return 0 on success, non-zero error code on failure (e.g. no project loaded)
 */
int reloadAllLayers();


/**
 * @brief Special constant representing all active canvases.
 *
 * Pass this value to single-canvas functions to apply the operation to all canvases.
 */
- (CANVAS_ID)allCanvases;


// MARK: - ============ Result Set API (Cursor Pattern) ============

/**
 * @brief Gets list of all active result set IDs as JSON.
 *
 * Useful for debugging and cleanup operations.
 *
 * @return JSON array of result set IDs: "[2001, 2002, ...]"
 */
- (NSString *)getActiveResultSets;


/**
 * @brief Closes and frees a result set.
 *
 * Releases all resources associated with the result set.
 * The result set ID becomes invalid after this call.
 *
 * @param resultSetId The result set handle to close
 */
- (void) closeResultSet:(RESULTSET_ID)resultSetId;


/**
 * @brief Gets metadata about a result set as JSON.
 *
 * Returns: {"id": int, "type": "sql"|"identify", "featureCount": int,
 *           "fields": [...], "geometryType": string, "crs": string}
 *
 * @param resultSetId The result set handle
 * @return JSON string with metadata, or empty string if not found
 */
- (NSString *)getResultSetMetadata:(RESULTSET_ID) resultSetId;


/**
 * @brief Gets the total count of features in a result set.
 *
 * @param resultSetId The result set handle
 * @return Feature count, or -1 on error
 */
- (long)getResultSetCount:(RESULTSET_ID) resultSetId;


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
- (NSString *) fetchResultSetBatch:(RESULTSET_ID)resultSetId offset:(long)offset limit:(long)limit;



// MARK: - ============ Layer Management ============

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
- (int) addLayerRoot:(NSString *)layerPath absolutePath:(bool)absolute;


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
- (int) addLayerGroup:(NSString *)layerPath expression:(NSString *)expression absolutePath:(bool)absolute;


/**
 * @brief Gets the layer ID from a layer expression.
 *
 * This function resolves a layer expression to its actual layer ID, which can then
 * be used with other layer functions like toggleLayerVisibility, setLayerVisibility, etc.
 *
 * @param expression Layer expression (e.g., "layerName" or "Group1|SubGroup|layerName")
 * @return The layer ID as a C string, or empty string if layer not found
 */
- (NSString *) getLayerId:(NSString *)expression;


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
- (NSString *) getLayerTree;


/**
 * @brief Gets the visibility state of a layer by its ID.
 *
 * @param layerId The unique identifier of the layer
 * @return true if the layer is visible, false if hidden or layer not found
 */
- (bool) getLayerVisibility:(NSString *)layerId;


/**
 * @brief Sets the visibility state of a layer by its ID.
 *
 * @param layerId The unique identifier of the layer
 * @param visible true to make the layer visible, false to hide it
 */
- (void) setLayerVisibility:(NSString *)layerId visible:(bool)visible;


/**
 * @brief Toggles the visibility state of a layer by its ID.
 *
 * @param layerId The unique identifier of the layer
 * @return true if the layer is now visible after toggling, false if now hidden or layer not found
 */
- (bool) toggleLayerVisibility:(NSString *)layerId;


/**
 * @brief Gets the visibility state of a layer group by its path expression.
 *
 * @param expression Group path expression (e.g., "Group1|SubGroup")
 * @return true if the group is visible, false if hidden or group not found
 */
- (bool) getGroupVisibility:(NSString *)expression;


/**
 * @brief Sets the visibility state of a layer group by its path expression.
 *
 * @param expression Group path expression (e.g., "Group1|SubGroup")
 * @param visible true to make the group visible, false to hide it
 */
- (void) setGroupVisibility:(NSString *)expression visible:(bool)visible;


/**
 * @brief Toggles the visibility state of a layer group by its path expression.
 *
 * @param expression Group path expression (e.g., "Group1|SubGroup")
 * @return true if the group is now visible after toggling, false if now hidden or group not found
 */
- (bool) toggleGroupVisibility:(NSString *)expression;


/**
 * @brief Gets the current map scale of a specific canvas.
 *
 * Returns the scale denominator of the map (e.g., 1000 for a 1:1000 scale map).
 * If the canvas is not found, returns a negative error code.
 *
 * @param canvasId The ID of the canvas to query
 * @return The map scale denominator, or negative error code if canvas not found
 */
- (double) getCanvasScale:(int)canvasId;


/**
 * @brief Gets the center point of a specific canvas as JSON.
 *
 * Returns a JSON string containing the center coordinates and CRS of the canvas.
 * Format: {"x": <double>, "y": <double>, "crs": "<auth_id>"}
 *
 * @param canvasId The ID of the canvas to query
 * @return JSON string with center point information, or empty JSON object if canvas not found
 */
- (NSString *) getCanvasCenter:(int)canvasId;


/**
 * @brief Gets the current extent of a specific canvas as JSON.
 *
 * Returns a JSON string containing the bounding box and CRS of the canvas.
 * Format: {"xMin": <double>, "yMin": <double>, "xMax": <double>, "yMax": <double>, "crs": "<auth_id>"}
 *
 * @param canvasId The ID of the canvas to query
 * @return JSON string with extent information, or empty JSON object if canvas not found
 */
- (NSString *) getCanvasExtent:(int)canvasId;



// MARK: - ============ Canvas Zoom ============

/**
 * @brief Zooms in on a specific map canvas.
 *
 * @param canvasId The ID of the canvas to zoom in on, or ALL_CANVASES to zoom in on all canvases
 */
- (void) zoomIn:(int)canvasId;


/**
 * @brief Zooms out on a specific map canvas.
 *
 * @param canvasId The ID of the canvas to zoom out on, or ALL_CANVASES to zoom out on all canvases
 */
- (void) zoomOut:(int)canvasId;


/**
 * @brief Zooms a specific map canvas to a named bookmark.
 *
 * Searches for a bookmark by name (case-insensitive) and zooms the canvas
 * to that bookmark's extent. If the bookmark is not found, a warning is logged.
 *
 * @param canvasId The ID of the canvas to zoom, or ALL_CANVASES to zoom all canvases
 * @param bookmarkName The name of the bookmark to zoom to
 */
- (void) zoomCanvasToBookmark:(int)canvasId bookmarkName:(NSString *)bookmarkName;


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
- (void) zoomCanvasToPoint:(int)canvasId x:(double)x y:(double)y scale:(double)scale;


/**
 * @brief Zooms the canvas to the visible extent of all layers.
 *
 * This function adjusts the canvas view to show the combined extent of all
 * visible layers in the project.
 *
 * @param canvasId The ID of the canvas to zoom, or ALL_CANVASES to zoom all canvases
 */
- (void) zoomCanvasToVisibleExtent:(int)canvasId;


/**
 * @brief Zooms a specific map canvas to the project's configured extent.
 *
 * Uses the preset full extent from the project's view settings (configured in
 * QGIS Desktop under Project -> Properties -> View Settings). If no project extent
 * is configured, this function is a no-op.
 *
 * @param canvasId The ID of the canvas to zoom, or ALL_CANVASES to zoom all canvases
 */
- (void) zoomCanvasToProjectExtent:(int)canvasId;


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
- (void *)zoomCanvasToRectangle: (int)canvasId xMin:(double)minX yMin:(double)minY xMax:(double)maxX yMax:(double)maxY;


/**
 * @brief Moves a specific map canvas view upward.
 *
 * @param canvasId The ID of the canvas to move, or ALL_CANVASES to move all canvases
 */
- (void) moveUp:(int)canvasId;


/**
 * @brief Moves a specific map canvas view to the left.
 *
 * @param canvasId The ID of the canvas to move, or ALL_CANVASES to move all canvases
 */
- (void) moveDown:(int)canvasId;


/**
 * @brief Moves a specific map canvas view to the left.
 *
 * @param canvasId The ID of the canvas to move, or ALL_CANVASES to move all canvases
 */
- (void) moveLeft:(int)canvasId;


/**
 * @brief Moves a specific map canvas view to the right.
 *
 * @param canvasId The ID of the canvas to move, or ALL_CANVASES to move all canvases
 */
- (void) moveRight:(int)canvasId;



// MARK: -============ Feature Queries ============

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
- (NSString *) queryFeaturesJSON:(NSString *)query;


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
- (RESULTSET_ID) queryFeaturesResultSet:(NSString *)query;



// MARK: - ============ Feature Identification ============

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
- (void) registerCanvasIdentificationCallbackJSON:(int)canvasId completion:(void (^)(NSString* json)) completion;


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
- (void) registerCanvasIdentificationCallbackResultSet:(int)canvasId completion:(void (^)(RESULTSET_ID resultSetId))completion;



// ============ Canvas Listeners ============

/**
 * @brief Registers a callback fired on every map interaction (pan/zoom/move/scale/rotate).
 *
 * @param canvasId The ID of the canvas to observe, or ALL_CANVASES
 * @param callback Function pointer called with (canvasId, CanvasState JSON)
 */
- (void)registerCanvasExtentChangedCallback:(int)canvasId completion:(void (^)(int canvasId, NSString *stateJson))completion;


/**
 * @brief Registers a callback fired when a canvas starts or finishes rendering.
 *
 * @param canvasId The ID of the canvas to observe, or ALL_CANVASES
 * @param callback Function pointer called with (canvasId, isRendering)
 */
- (void)registerCanvasRenderingChangedCallback:(int)canvasId completion:(void (^)(int canvasId, bool isRendering))completion;


/**
 * @brief Registers a callback fired when the runtime transitions between busy and idle.
 *
 * @param callback Function pointer called with (busy)
 */
- (void)registerRuntimeBusyChangedCallback:(void (^)(bool busy))completion;



// ============ Virtual Layer Management ============

/**
 * @brief Creates a virtual layer from a SQL query and adds it to the project.
 *
 * This function creates a QGIS virtual layer based on the provided SQL query,
 * optionally applies a .qml style file, and adds it to the current project's
 * layer tree. The layer appears on all active map canvases.
 *
 * @param query SQL query defining the virtual layer
 * @param name Display name for the virtual layer
 * @param stylePath Path to a .qml style file (nullptr or empty for no style)
 * @param absolutePath Whether the stylePath is absolute (true) or relative to app bundle (false)
 * @return Layer ID string on success, empty string on failure
 */
- (NSString *) addVirtualLayer:(NSString *)query name:(NSString *)name stylePath:(NSString *)stylePath absolute:(bool)absolute;


/**
 * @brief Removes a virtual layer from the project.
 *
 * @param layerId The layer ID (as returned by addVirtualLayer or getLayerId)
 * @return 0 on success, non-zero error code on failure
 */
- (int) removeVirtualLayer:(NSString *)layerId;


/**
 * @brief Updates the SQL query of an existing virtual layer.
 *
 * Changes the data source query while preserving the layer's style and position
 * in the layer tree.
 *
 * @param layerId The layer ID of the virtual layer to update
 * @param query New SQL query for the virtual layer
 * @return 0 on success, non-zero error code on failure
 */
- (int) setVirtualLayerSql:(NSString *)layerId query:(NSString *)query;


/**
 * @brief Applies a .qml style file to an existing virtual layer.
 *
 * @param layerId The layer ID of the virtual layer to style
 * @param stylePath Path to the .qml style file
 * @param absolutePath Whether the stylePath is absolute (true) or relative to app bundle (false)
 * @return 0 on success, non-zero error code on failure
 */
- (int) setVirtualLayerStyle:(NSString *)layerId stylePath:(NSString *)stylePath absolute:(bool)absolute;



// ============ Feature Selection ============

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
- (int) selectFeatures:(NSString *) layerId fidsJson:(NSString *)fidsJson behavior:(int)behavior;

/**
 * @brief Selects features in a vector layer matching a QGIS expression.
 *
 * @param layerId The QGIS layer ID of the target vector layer
 * @param expression QGIS expression (e.g. "status = 'open'")
 * @param behavior Selection behavior: 0=Set, 1=Add, 2=Intersect, 3=Remove
 * @return 0 on success, non-zero error code on failure
 */
- (int) selectFeaturesByExpression:(NSString *) layerId fidsJson:(NSString *)fidsJson behavior:(int) behavior;

/**
 * @brief Selects all features in a vector layer.
 *
 * @param layerId The QGIS layer ID of the target vector layer
 * @return 0 on success, non-zero error code on failure
 */
- (int) selectAllFeatures:(NSString *) layerId;

/**
 * @brief Inverts the selection of a vector layer.
 *
 * @param layerId The QGIS layer ID of the target vector layer
 * @return 0 on success, non-zero error code on failure
 */
- (int) invertSelection:(NSString *) layerId;

/**
 * @brief Clears the selection of a vector layer.
 *
 * @param layerId The QGIS layer ID of the target vector layer
 * @return 0 on success, non-zero error code on failure
 */
- (int) clearSelection:(NSString *) layerId;

/**
 * @brief Gets the IDs of the selected features in a vector layer as JSON.
 *
 * @param layerId The QGIS layer ID of the target vector layer
 * @return JSON object {"type":"SelectedFeatures","layerId":...,"count":N,"fids":[...]}, or empty string on error
 */
- (NSString *) getSelectedFeatureIds:(NSString *) layerId;

/**
 * @brief Gets the number of selected features in a vector layer.
 *
 * @param layerId The QGIS layer ID of the target vector layer
 * @return Selected feature count, or -1 on error
 */
- (int) getSelectedFeatureCount:(NSString *) layerId;

/**
 * @brief Zooms a canvas to the bounding box of the selected features of a layer.
 *
 * @param canvasId The ID of the canvas to zoom, or ALL_CANVASES
 * @param layerId The QGIS layer ID of the target vector layer
 */
- (void) zoomCanvasToSelection:(int) canvasId layerId:(NSString*) layerId;


@end

NS_ASSUME_NONNULL_END
