import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import com.tiobe 1.0

ApplicationWindow {
    visible: true
    width: 800
    height: 600
    title: "TIOBE Index"
    color: "#f9f9f9"  // Soft background color for the app

    Component.onCompleted: {
        if (!scraper) {
            console.error("Scraper is not available.");
        } else {
            scraper.getTiobeIndex();
        }
    }

    // Header Bar
    Rectangle {
        id: header
        width: parent.width
        height: 60
        color: "#007BFF"  // Primary blue color
        radius: 0
        anchors.top: parent.top

        Text {
            anchors.centerIn: parent
            text: "TIOBE Index"
            font.bold: true
            font.pointSize: 20
            color: "white"
        }
    }

    // Loading Indicator
    Rectangle {
        id: loadingIndicator
        width: parent.width
        height: parent.height
        color: "#ffffff"  // Background color for loading
        z: 10
        visible: scraper ? scraper.languages.length === 0 : true

        Column {
            anchors.centerIn: parent
            spacing: 20

            Text {
                text: "Fetching TIOBE Index..."
                font.bold: true
                font.pointSize: 18
                color: "#555555"
            }

            ProgressBar {
                width: 200
                height: 5
                from: 0
                to: 100
                value: 50
                indeterminate: true
            }
        }
    }

    // ListView to display the languages
    ListView {
        id: languageList
        anchors {
            top: header.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        model: scraper ? scraper.languages : []
        spacing: 10  // Space between items
        clip: true

        // Delegate for each item in the list
        delegate: Item {
            width: languageList.width
            height: 100

            // Container for shadow and content
            Item {
                width: parent.width
                height: parent.height

                // Simulated shadow using a semi-transparent Rectangle
                Rectangle {
                    anchors.fill: parent
                    z: -1  // Place shadow behind the content
                    anchors.margins: 4  // Offset to simulate shadow spread
                }

                // Card-style container with rounded corners
                Rectangle {
                    id: rowContainer
                    anchors.fill: parent
                    color: "white"
                    border.color: "#ddd"
                    border.width: 1

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 6

                        RowLayout {
                            spacing: 20

                            Text {
                                text: "Rank: " + modelData.rank
                                font.bold: true
                                font.pointSize: 16
                                color: "#333333"
                                Layout.alignment: Qt.AlignVCenter
                            }

                            Text {
                                text: modelData.name
                                font.bold: true
                                font.pointSize: 16
                                color: "#007BFF"
                                Layout.alignment: Qt.AlignVCenter
                            }

                            Text {
                                text: modelData.percentage + "%"
                                font.pointSize: 14
                                color: "#555555"
                                Layout.alignment: Qt.AlignVCenter
                            }

                            Text {
                                text: modelData.change
                                font.pointSize: 14
                                font.bold: true
                                color: modelData.change.startsWith('+') ? "green" : "red"
                                Layout.alignment: Qt.AlignVCenter
                            }
                        }

                        // Divider line
                        Rectangle {
                            height: 1
                            color: "#eeeeee"
                            width: parent.width
                        }
                    }

                    // Hover effect
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor

                        property bool isHovered: false

                        onEntered: {
                            isHovered = true;
                            rowContainer.color = "#f0f0f0";  // Highlight color when hovered
                        }

                        onExited: {
                            isHovered = false;
                            rowContainer.color = "white";  // Default color
                        }
                    }
                }
            }
        }

        // Fetch data when the component is ready
        Component.onCompleted: {
            scraper.getTiobeIndex()
        }
    }

    // Update the ListView model when data changes
    Connections {
        target: scraper
        function onLanguagesChanged() {
            languageList.model = scraper.languages
        }
    }
}
