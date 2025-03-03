import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import com.tiobe 1.0
import QtQuick.Controls.Material  // For elevation effect

ApplicationWindow {
    visible: true
    minimumWidth: 400
    minimumHeight: 300
    width: 600
    height: 500
    title: "TIOBE Index"
    color: "#eef2f6"

    Material.theme: Material.Light
    Material.accent: "#007bff"

    // Header with Gradient
    Rectangle {
        id: header
        width: parent.width
        height: 60
        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop { position: 0.0; color: "#007bff" }
            GradientStop { position: 1.0; color: "#00c4ff" }
        }

        Text {
            anchors.centerIn: parent
            text: "TIOBE Index"
            font.pointSize: 18
            font.bold: true
            font.family: "Helvetica"
            color: "white"
            style: Text.Raised
            styleColor: Qt.rgba(0, 0, 0, 0.2)
        }
    }

    // Loading with Pulse Effect
    Rectangle {
        anchors.fill: parent
        color: Qt.rgba(0, 0, 0, 0.3)
        visible: scraper ? scraper.languages.length === 0 : true
        z: 10

        BusyIndicator {
            anchors.centerIn: parent
            running: parent.visible
            width: 50
            height: 50
            opacity: 0.8

            SequentialAnimation on scale {
                loops: Animation.Infinite
                running: parent.visible
                PropertyAnimation { to: 1.1; duration: 800; easing.type: Easing.InOutQuad }
                PropertyAnimation { to: 1.0; duration: 800; easing.type: Easing.InOutQuad }
            }
        }
    }

    // Language List with Effects
    ListView {
        id: listView
        anchors {
            top: header.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            margins: 15
        }
        model: scraper ? scraper.languages : []
        clip: true
        spacing: 10

        delegate: Rectangle {
            width: listView.width
            height: 55
            radius: 8
            color: "white"
            opacity: 0
            Material.elevation: 2  // Built-in Qt 6 shadow effect

            // Entry Animation
            SequentialAnimation on opacity {
                running: true
                NumberAnimation { to: 1; duration: 400; easing.type: Easing.OutCubic }
            }
            Behavior on y { SpringAnimation { spring: 3; damping: 0.2 } }

            RowLayout {
                anchors.fill: parent
                anchors.margins: 12
                spacing: Math.max(10, parent.width * 0.03)

                // Rank with Gradient Circle
                Rectangle {
                    width: 35
                    height: 35
                    radius: 17.5
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: "#007bff" }
                        GradientStop { position: 1.0; color: "#00c4ff" }
                    }
                    Text {
                        anchors.centerIn: parent
                        text: modelData.rank
                        color: "white"
                        font.pointSize: 12
                        font.bold: true
                    }
                }

                Text {
                    text: modelData.name
                    font.pointSize: 13
                    font.family: "Helvetica"
                    color: "#1e293b"
                    Layout.fillWidth: true
                    elide: Text.ElideRight
                }

                Text {
                    text: modelData.percentage + "%"
                    font.pointSize: 12
                    color: "#64748b"
                    Layout.preferredWidth: 60
                }

                Text {
                    text: modelData.change
                    font.pointSize: 12
                    font.bold: true
                    color: modelData.change.startsWith('+') ? "#22c55e" : "#ef4444"
                    Layout.preferredWidth: 50

                    // Bounce animation for change
                    SequentialAnimation on scale {
                        running: modelData.change !== ""
                        loops: 1
                        PropertyAnimation { to: 1.2; duration: 200; easing.type: Easing.OutBack }
                        PropertyAnimation { to: 1.0; duration: 300; easing.type: Easing.OutBounce }
                    }
                }
            }

            // Hover and Scale Effect
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: {
                    parent.scale = 1.02
                    parent.color = "#f8fafc"
                    parent.Material.elevation = 4  // Increase elevation on hover
                }
                onExited: {
                    parent.scale = 1.0
                    parent.color = "white"
                    parent.Material.elevation = 2
                }
            }

            Behavior on scale { NumberAnimation { duration: 200; easing.type: Easing.InOutQuad } }
        }

        // Smooth Scroll
        ScrollBar.vertical: ScrollBar {
            policy: ScrollBar.AsNeeded
            active: true
            width: 8
            background: Rectangle { color: "#e2e8f0"; radius: 4 }
            contentItem: Rectangle { color: "#94a3b8"; radius: 4 }
        }
    }

    // Data Fetching
    Component.onCompleted: {
        if (scraper) {
            scraper.getTiobeIndex()
        } else {
            console.error("Scraper unavailable")
        }
    }

    Connections {
        target: scraper
        function onLanguagesChanged() {
            listView.model = scraper.languages
        }
    }
}
