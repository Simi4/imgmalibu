import QtQuick 2.13
import QtQuick.Window 2.13
import QtQuick.Controls 2.13
import QtQml.Models 2.13


Rectangle {
	anchors.fill: parent
	anchors.rightMargin: 220
	color: "steelblue"
	property Component quadcopter: Qt.createComponent("Quadcopter.qml")

	MouseArea {
		id: rootMouseArea
		anchors.fill: parent
		hoverEnabled: true

		function getLatFromX(inX) {
			return (gps[0][0] + gpsDX * inX/width).toFixed(6)
		}

		function getLonFromY(inY) {
			return (gps[1][1] + (1-gpsDY*inY/height)).toFixed(6)
		}

		onPositionChanged: {
			gpsText.text = getLatFromX(mouseX) + '\n' + getLonFromY(mouseY)
		}

		Image {
			id: img
			source: "data/" + lakeLocation + "/source.jpg"
			fillMode: Image.PreserveAspectFit
			anchors {
				left: parent.left
				top: parent.top
				bottom: parent.bottom
			}

			function mapX(inX) { return inX * (img.paintedWidth / img.sourceSize.width); }
			function mapY(inY) { return inY * (img.paintedHeight / img.sourceSize.height); }

			function mapAbsX(inX) { return inX * (img.sourceSize.width / img.paintedWidth); }
			function mapAbsY(inY) { return inY * (img.sourceSize.height / img.paintedHeight); }

			function inside(point) {
				var x = point[0], y = point[1]
				var inside = false
				for (var i = 0, j = polygon.length - 1; i < polygon.length; j = i++) {
					var xi = mapX(polygon[i][0]), yi = mapY(polygon[i][1])
					var xj = mapX(polygon[j][0]), yj = mapY(polygon[j][1])
					var intersect = ((yi > y) != (yj > y)) && (x < (xj - xi) * (y - yi) / (yj - yi) + xi)
					if (intersect) {
						inside = !inside
					}
				}
				return inside
			}

			Canvas {
				anchors.fill: parent
				onPaint: {
					var ctx = getContext("2d");
					ctx.strokeStyle = Qt.rgba(1, 0, 0, 0.8)
					ctx.fillStyle = Qt.rgba(0.8, 0, 0, 0.25)
					ctx.lineWidth = 3

					ctx.beginPath();
					for (var i = 0; i < polygon.length; i++) {
						ctx.lineTo(img.mapX(polygon[i][0]), img.mapY(polygon[i][1]))
					}
					ctx.closePath()

					ctx.fill()
					ctx.stroke()
				}
			}

			Repeater {
				model: boxes
				delegate: Rectangle {
					x: img.mapX(boxes[index][1]-10)
					y: img.mapY(boxes[index][0]-10)
					width: img.mapX(boxes[index][3]+20)
					height: img.mapY(boxes[index][2]+20)
					color: "transparent"
					border {
						width : 1
						color : "white"
					}

					Rectangle {
						anchors.fill: parent
						anchors.margins: 1
						color: "transparent"
						border {
							width : 4
							color : (boxes[index][4] == 2) ? "blue"
								: (boxes[index][4] == 1) ? "red"
									: img.inside([parent.x, parent.y]) ?
										"orange" : "green"
						}
						MouseArea {
							anchors.fill: parent
							id: mouseArea
							acceptedButtons: Qt.LeftButton | Qt.RightButton

							function createSpriteObjects(type) {
								let obj = quadcopter.createObject(img, {
									x: parent.parent.x + parent.parent.width/2 - 50,
									y: 0,
									toY: parent.parent.y + parent.parent.height/2 - 50,
									type: type
								})
							}

							onClicked: {
								if (mouse.button == Qt.RightButton) {
									contextMenu.popup()
								} else {
									var ctx = zoomed.getContext("2d")
									ctx.reset()
									ctx.drawImage('data/' + lakeLocation + '/source.jpg',
												  img.mapAbsX(parent.parent.x),
												  img.mapAbsY(parent.parent.y),
												  img.mapAbsX(parent.parent.width),
												  img.mapAbsY(parent.parent.height), 0, 0, 205, 205 * parent.height/parent.width)
									zoomed.requestPaint()
								}
								gpsInfo.text = 'lat: ' + rootMouseArea.getLatFromX(parent.parent.x) + '\nlon: ' + rootMouseArea.getLonFromY(parent.parent.y)
							}

							Menu {
								id: contextMenu

								Action {
									text: "Сбросить круг"
									onTriggered: mouseArea.createSpriteObjects(0)
								}
								Action {
									text: "Голосовое предупреждение"
									onTriggered: mouseArea.createSpriteObjects(1)
								}
							}
						}
					}
				}
			}
		}
	}
	
	Text {
		styleColor: "green"
		font.pixelSize: 18
		antialiasing: true
		id: gpsText
		width: 100
		height: 100
		x: rootMouseArea.mouseX + 15
		y: rootMouseArea.mouseY + 10
	}
}
