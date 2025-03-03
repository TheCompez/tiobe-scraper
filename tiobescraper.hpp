#ifndef TIOBE_SCRAPER_HPP
#define TIOBE_SCRAPER_HPP

#include <QtNetwork/QNetworkAccessManager>
#include <QtNetwork/QNetworkReply>
#include <QRegularExpression>
#include <QNetworkRequest>
#include <QVariantMap>
#include <QObject>
#include <QString>
#include <QDebug>
#include <QList>

#define INDEX_URL "https://genyleap.com/api/wasm/redirect"

/**
 * @class TiobeScraper
 * @brief Fetches and parses the TIOBE programming language index.
 *
 * This class uses network requests to fetch data from the TIOBE index website,
 * parses the response, and exposes the information in a QML-compatible format.
 */
class TiobeScraper : public QObject {
    Q_OBJECT

    /**
     * @brief List of programming languages with their rank, percentage, and other details.
     * @return QList<QVariantMap> containing language information.
     */
    Q_PROPERTY(QList<QVariantMap> languages READ languages NOTIFY languagesChanged)

public:
    /**
     * @struct LanguageInfo
     * @brief Represents detailed information about a programming language.
     *
     * This struct contains the rank, name, percentage usage, change in popularity,
     * and an optional URL for the language's logo.
     */
    struct LanguageInfo {
        int rank;             ///< Rank of the programming language.
        QString name;         ///< Name of the programming language.
        double percentage;    ///< Percentage usage of the programming language.
        QString change;       ///< Change in usage percentage compared to the previous period.
        QString logoUrl;      ///< URL for the programming language's logo (optional).
    };

    /**
     * @brief Constructs a TiobeScraper object.
     * @param parent Parent QObject, defaults to nullptr.
     */
    explicit TiobeScraper(QObject* parent = nullptr);

    /**
     * @brief Initiates a network request to fetch the TIOBE index data.
     */
    Q_INVOKABLE void getTiobeIndex();

    /**
     * @brief Provides the parsed list of programming languages.
     * @return QList<QVariantMap> containing the parsed language data.
     */
    const QList<QVariantMap>& languages() const;

signals:
    /**
     * @brief Emitted when the language list is updated after data fetching and parsing.
     */
    void languagesChanged();

private slots:
    /**
     * @brief Handles the completion of the network request.
     *
     * Parses the response data and updates the `languagesList`.
     * @param reply The QNetworkReply object containing the fetched data.
     */
    void onFinished(QNetworkReply* reply);

private:
    QNetworkAccessManager* manager;  ///< Manages network requests for fetching TIOBE index data.
    QList<QVariantMap> languagesList;  ///< Stores the parsed list of programming language data.
};

#endif // TIOBE_SCRAPER_HPP
