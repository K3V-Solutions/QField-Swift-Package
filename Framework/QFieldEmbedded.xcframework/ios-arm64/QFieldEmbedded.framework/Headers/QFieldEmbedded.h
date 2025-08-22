#include <string>

@class UIView;

/**
 * @namespace qfe
 * @brief Contains functions for bootstrapping, running, and interacting with the QFieldEmbedded application on iOS.
 */
namespace qfe {

    /**
     * @brief Initializes the QFieldEmbedded system (from the UI main thread).
     *
     * This function performs the necessary startup routines required to initialize
     * the QFieldEmbedded environment. It should be called before using any other
     * functionality provided by the system and must be called from the main thread.
     *
     * @param debug If true, enables debug mode in QGIS, which can help with troubleshooting.
     * @return Returns 0 on successful initialization, or a non-zero error code on failure.
     */
    int boot(bool debug = false);

    /**
     * @brief Runs the main application logic (from an asynchronous context).
     *
     * This function starts the QGIS application loop used for QFieldEmbedded widgets.
     * It processes command-line arguments and initializes the application state.
     * Should be called after the `boot()` function has been successfully executed,
     * but from an asynchronous context.
     *
     * @param argc The number of command-line arguments passed to the QGIS application.
     * @param argv The array of command-line argument strings passed to the QGIS application.
     * @return Returns 0 on success, or a non-zero error code on failure.
     */
    int run(int argc, char *argv[]);

    /**
     * @brief Binds a native UIView container to a new QField canvas (usually called right after run()).
     *
     * This function creates a new QField canvas and binds it to the provided native UIView container.
     * It allows the QFieldEmbedded application to render its UI within an existing iOS view.
     * Ensure `boot()` and `run()` have been called successfully (zero return code) before calling this function.
     *
     * @param nativeContainer Pointer to the native UIView container.
     * @return Returns 0 on success, or a non-zero error code on failure.
     */
    int widget(UIView* nativeContainer);

    /**
     * @brief Loads a project from the specified path.
     *
     * @param projectPath The path to the project file to load.
     * @param zoomToProject Whether to zoom the view to fit the project extent.
     * @param absolutePath Whether the provided path is absolute or relative.
     * @return Returns 0 on success, or a non-zero error code on failure.
     */
    int project(const std::string& projectPath, bool zoomToProject = true, bool absolutePath = false);

    /**
     * @brief Zooms in on the map canvas.
     */
    void zoomIn();

    /**
     * @brief Zooms out on the map canvas.
     */
    void zoomOut();

    /**
     * @brief Moves the map view up.
     */
    void moveUp();

    /**
     * @brief Moves the map view down.
     */
    void moveDown();

    /**
     * @brief Moves the map view left.
     */
    void moveLeft();

    /**
     * @brief Moves the map view right.
     */
    void moveRight();

} // namespace qfe