#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "tiobescraper.hpp"

int main(int argc, char* argv[]) {
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    // Register TiobeScraper as a QML type
    qmlRegisterType<TiobeScraper>("com.tiobe", 1, 0, "TiobeScraper");

    TiobeScraper scraper;
    engine.rootContext()->setContextProperty("scraper", &scraper);

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("TIOBE", "Main");

    return app.exec();
}
