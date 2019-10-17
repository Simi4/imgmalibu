import QtQuick 2.13
import QtQuick.Window 2.13
import QtQuick.Controls 2.13
import QtQml.Models 2.13


Image {
	width: 100
	height: 100

	property var toY: 0.0
	property var type: 0

	source: type == 0 ? "data/quadro.png" : "data/quadro_vol.png"
	fillMode: Image.PreserveAspectFit

	Behavior on opacity {
		PropertyAnimation {
			duration: 1000 // в течении 1000 милисекунд
			onRunningChanged: {
				if (!running && type == 0) {
					source = 'data/circle-v2.png'
					opacity = 1
				}
			}
		}
	}

	NumberAnimation on y {
		to: toY
		duration: 1500
		onRunningChanged: {
			if (!running) {
				opacity = 0
			}
		}
	}
}
