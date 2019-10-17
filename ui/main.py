#!/usr/bin/env python3

import sys
from PyQt5.QtCore import QUrl
from PyQt5.QtWidgets import QApplication, QWidget
from PyQt5.QtQuick import QQuickView
from PyQt5.QtQml import QQmlApplicationEngine
from data import *


if __name__ == '__main__':
	lakeLocation = "common"

	with open('data/' + lakeLocation + '/norm.txt', 'r') as f:
		boxes_norm = eval(f.read())
		for box in boxes_norm:
			box[3] = box[3] - box[1]
			box[2] = box[2] - box[0]
			box.append(0)

	with open('data/' + lakeLocation + '/sink.txt', 'r') as f:
		boxes_sink = eval(f.read())
		for box in boxes_sink:
			box[3] = box[3] - box[1]
			box[2] = box[2] - box[0]
			box.append(1)

	with open('data/' + lakeLocation + '/boats.txt', 'r') as f:
		boxes_boats = eval(f.read())
		for box in boxes_boats:
			box[3] = box[3] - box[1]
			box[2] = box[2] - box[0]
			box.append(2)

	app = QApplication(sys.argv)
	engine = QQmlApplicationEngine()

	boxes = boxes_norm + boxes_sink + boxes_boats

	ctxt = engine.rootContext()
	ctxt.setContextProperty('lakeLocation', lakeLocation)
	ctxt.setContextProperty('boxes', boxes)
	ctxt.setContextProperty('polygon', polygon)
	ctxt.setContextProperty('gpsDX', gpsDX)
	ctxt.setContextProperty('gpsDY', gpsDY)
	ctxt.setContextProperty('gps', gps)

	engine.load('main.qml')
	win = engine.rootObjects()[0]
	win.showFullScreen()

	app.exec_()
	sys.exit()
