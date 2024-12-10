# TIOBE Scraper

TIOBE Scraper is a C++/Qt-based application that fetches and parses the [TIOBE Programming Community Index](https://www.tiobe.com/tiobe-index/). It provides insights into programming language rankings, usage percentages, and changes in popularity, making the data accessible for QML-based applications.

## Features

- Fetches real-time programming language rankings from the TIOBE index.
- Parses data into a structured format using `QVariantMap`.
- Exposes data to QML for integration with modern Qt Quick user interfaces.
- Highlights programming language details, including:
  - **Rank**
  - **Name**
  - **Percentage Usage**
  - **Change in Popularity**
  - **Logo URL** (optional).

## Requirements

- **Qt 6.8** or later
- C++20 or later
- Internet connection to fetch data from the TIOBE website

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/thecompez/tiobe-scraper.git
   cd tiobe-scraper
