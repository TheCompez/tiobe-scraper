#include "tiobescraper.hpp"
#include <QJsonObject>
#include <QJsonDocument>

TiobeScraper::TiobeScraper(QObject* parent)
    : QObject(parent),
      manager(new QNetworkAccessManager(this)) {
    languagesList = {};  // Initialize the list to avoid null reference
    connect(manager, &QNetworkAccessManager::finished, this, &TiobeScraper::onFinished);
}

void TiobeScraper::getTiobeIndex() {
    QUrl url(INDEX_URL);  // URL to your PHP endpoint

    QNetworkRequest request(url);

    // Create a JSON object to send with the POST request
    QJsonObject jsonData;
    jsonData["target"] = "tiobe";  // Adding target parameter for PHP

    // Convert JSON object to QByteArray
    QJsonDocument doc(jsonData);
    QByteArray data = doc.toJson();

    // Make a POST request to the server
    manager->post(request, data);
}

const QList<QVariantMap>& TiobeScraper::languages() const {
    return languagesList;
}

void TiobeScraper::onFinished(QNetworkReply* reply) {
    if (reply->error() != QNetworkReply::NoError) {
        qWarning() << "Error:" << reply->errorString();
        qWarning() << "HTTP Status Code:" << reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
        reply->deleteLater();
        return;
    }

    QByteArray data = reply->readAll();
    QString htmlContent = QString::fromUtf8(data);

    // Parse the HTML content here (same logic as before)
    QRegularExpression regex("<tr>.*?<td>(\\d+)</td>.*?<td class=\"td-top20\"><img [^>]+alt=\"([^\"]+)\".*?</td><td>([^<]+)%</td><td>([\\+\\-\\d.]+%)</td>");

    QRegularExpressionMatchIterator i = regex.globalMatch(htmlContent);
    languagesList.clear();

    while (i.hasNext()) {
        QRegularExpressionMatch match = i.next();
        int rank = match.captured(1).toInt();
        QString languageAlt = match.captured(2);
        QString language = languageAlt.split(" page").first();
        double percentage = match.captured(3).toDouble();
        QString change = match.captured(4);

        languagesList.append({
            {"rank", rank},
            {"name", language},
            {"percentage", percentage},
            {"change", change}
        });
    }

    emit languagesChanged();
    reply->deleteLater();
}
