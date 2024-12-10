#include "tiobescraper.hpp"

TiobeScraper::TiobeScraper(QObject* parent)
    : QObject(parent),
    manager(new QNetworkAccessManager(this)) {
    languagesList = {};  // Initialize the list to avoid null reference
    connect(manager, &QNetworkAccessManager::finished, this, &TiobeScraper::onFinished);
}

void TiobeScraper::getTiobeIndex() {
    QUrl url(INDEX_URL);
    QNetworkRequest request(url);
    manager->get(request);
}

const QList<QVariantMap>& TiobeScraper::languages() const {
    return languagesList;
}

void TiobeScraper::onFinished(QNetworkReply* reply) {
    if (reply->error() != QNetworkReply::NoError) {
        qWarning() << "Error:" << reply->errorString();
        reply->deleteLater();
        return;
    }

    QByteArray data = reply->readAll();
    QString htmlContent = QString::fromUtf8(data);

    QRegularExpression regex(
        "<tr>.*?<td>(\\d+)</td>.*?<td class=\"td-top20\"><img [^>]+alt=\"([^\"]+)\".*?</td><td>([^<]+)%</td><td>([\\+\\-\\d.]+%)</td>"
        );

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
