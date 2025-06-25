#include <string>

int bootQFieldEmbedded();

int runQFieldEmbedded(int argc, char *argv[]);

int QfeProject(const std::string& projectPath, bool zoomToProject = true, bool absolutePath = false);

void QfeZoomIn();
void QfeZoomOut();
void QfeMoveUp();
void QfeMoveDown();
void QfeMoveLeft();
void QfeMoveRight();