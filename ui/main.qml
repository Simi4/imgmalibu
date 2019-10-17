import QtQuick 2.13
import QtQuick.Window 2.13
import QtQuick.Controls 2.13
import QtQml.Models 2.13

ApplicationWindow {
	id: root
	visible: true
	color: "#CCCCCC"

	Text {
		anchors {
			bottom: weatherImg.top
			right: parent.right
			bottomMargin: 5
			rightMargin: 50
		}
		font.pixelSize: 20
		text: 'Озеро Севан'
	}
	
	Image {
		id: weatherImg
		source: 'data/weather.png'
		width: 205
		fillMode: Image.PreserveAspectFit
		anchors {
			right: parent.right
			top: zoomed.parent.bottom
			bottomMargin: 5
			rightMargin: 5
		}
	}

	TopView {
		id: topView
	}

	Text {
		id: gpsInfo
		anchors {
			right: parent.right
			top: parent.top
			topMargin: 20
		}
		font.pixelSize: 16
		width: 160
		height: 50
	}

	Item {
		width: 205
		height: 300
		anchors {
			right: parent.right
			top: gpsInfo.bottom
			topMargin: 20
			rightMargin: 5
		}
		
		Canvas {
			id: zoomed
			anchors.fill: parent
			Component.onCompleted: loadImage('data/' + lakeLocation + '/source.jpg')
		}
	}

	Text {
		anchors {
			right: parent.right
			bottom: parent.bottom
			bottomMargin: 10
			rightMargin: 10
		}
		font.pixelSize: 14
		width: 180
		text: 'Спасатели Малибу (c) 2019'
	}
}

