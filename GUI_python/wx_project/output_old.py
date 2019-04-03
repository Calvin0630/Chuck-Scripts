# -*- coding: utf-8 -*-

# Form implementation generated from reading ui file 'qtD_project.ui'
#
# Created by: PyQt5 UI code generator 5.11.3
#
# WARNING! All changes made in this file will be lost!

from PyQt5 import QtCore, QtGui, QtWidgets
import atexit
import ChuckManager

#import GLController
#import MyQGL
import MyGLWidget
import types


class Ui_MainWindow(object):
    def setupUi(self, MainWindow):
        MainWindow.setObjectName("MainWindow")
        MainWindow.resize(929, 836)
        self.centralwidget = QtWidgets.QWidget(MainWindow)
        self.centralwidget.setObjectName("centralwidget")
        self.verticalLayout = QtWidgets.QVBoxLayout(self.centralwidget)
        self.verticalLayout.setContentsMargins(0, 0, 0, 0)
        self.verticalLayout.setObjectName("verticalLayout")
        self.frame = QtWidgets.QFrame(self.centralwidget)
        self.frame.setFrameShape(QtWidgets.QFrame.StyledPanel)
        self.frame.setFrameShadow(QtWidgets.QFrame.Raised)
        self.frame.setObjectName("frame")
        #set up GL widget
        self.openGLWidget = MyGLWidget.MyGLWidget(parent=self.frame)

        self.openGLWidget.setGeometry(QtCore.QRect(0, 0, 931, 481))
        self.openGLWidget.setObjectName("openGLWidget")
        self.line = QtWidgets.QFrame(self.frame)
        self.line.setGeometry(QtCore.QRect(-20, 480, 971, 20))
        self.line.setFrameShape(QtWidgets.QFrame.HLine)
        self.line.setFrameShadow(QtWidgets.QFrame.Sunken)
        self.line.setObjectName("line")
        self.tabWidget = QtWidgets.QTabWidget(self.frame)
        self.tabWidget.setGeometry(QtCore.QRect(0, 490, 931, 351))
        self.tabWidget.setObjectName("tabWidget")
        self.synth_tab = QtWidgets.QWidget()
        self.synth_tab.setObjectName("synth_tab")
        self.volume_slider = QtWidgets.QSlider(self.synth_tab)
        self.volume_slider.setGeometry(QtCore.QRect(10, 10, 22, 160))
        palette = QtGui.QPalette()
        brush = QtGui.QBrush(QtGui.QColor(85, 255, 127))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Active, QtGui.QPalette.Highlight, brush)
        brush = QtGui.QBrush(QtGui.QColor(85, 255, 127))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Inactive, QtGui.QPalette.Highlight, brush)
        brush = QtGui.QBrush(QtGui.QColor(0, 120, 215))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Disabled, QtGui.QPalette.Highlight, brush)
        self.volume_slider.setPalette(palette)
        self.volume_slider.setOrientation(QtCore.Qt.Vertical)
        self.volume_slider.setObjectName("volume_slider")

        self.attack_slider = QtWidgets.QSlider(self.synth_tab)
        self.attack_slider.setGeometry(QtCore.QRect(60, 10, 22, 160))
        palette = QtGui.QPalette()
        brush = QtGui.QBrush(QtGui.QColor(85, 255, 127))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Active, QtGui.QPalette.Highlight, brush)
        brush = QtGui.QBrush(QtGui.QColor(85, 255, 127))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Inactive, QtGui.QPalette.Highlight, brush)
        brush = QtGui.QBrush(QtGui.QColor(0, 120, 215))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Disabled, QtGui.QPalette.Highlight, brush)
        self.attack_slider.setPalette(palette)
        self.attack_slider.setOrientation(QtCore.Qt.Vertical)
        self.attack_slider.setObjectName("attack_slider")
        self.delay_slider = QtWidgets.QSlider(self.synth_tab)
        self.delay_slider.setGeometry(QtCore.QRect(110, 10, 22, 160))
        palette = QtGui.QPalette()
        brush = QtGui.QBrush(QtGui.QColor(85, 255, 127))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Active, QtGui.QPalette.Highlight, brush)
        brush = QtGui.QBrush(QtGui.QColor(85, 255, 127))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Inactive, QtGui.QPalette.Highlight, brush)
        brush = QtGui.QBrush(QtGui.QColor(0, 120, 215))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Disabled, QtGui.QPalette.Highlight, brush)
        self.delay_slider.setPalette(palette)
        self.delay_slider.setOrientation(QtCore.Qt.Vertical)
        self.delay_slider.setObjectName("delay_slider")
        self.sustain_slider = QtWidgets.QSlider(self.synth_tab)
        self.sustain_slider.setGeometry(QtCore.QRect(160, 10, 22, 160))
        palette = QtGui.QPalette()
        brush = QtGui.QBrush(QtGui.QColor(85, 255, 127))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Active, QtGui.QPalette.Highlight, brush)
        brush = QtGui.QBrush(QtGui.QColor(85, 255, 127))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Inactive, QtGui.QPalette.Highlight, brush)
        brush = QtGui.QBrush(QtGui.QColor(0, 120, 215))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Disabled, QtGui.QPalette.Highlight, brush)
        self.sustain_slider.setPalette(palette)
        self.sustain_slider.setOrientation(QtCore.Qt.Vertical)
        self.sustain_slider.setObjectName("sustain_slider")
        self.release_slider = QtWidgets.QSlider(self.synth_tab)
        self.release_slider.setGeometry(QtCore.QRect(210, 10, 22, 160))
        self.release_slider.setMaximum(100)
        self.release_slider.setSingleStep(1)
        self.release_slider.setProperty("value", 0)
        self.release_slider.setOrientation(QtCore.Qt.Vertical)
        self.release_slider.setObjectName("release_slider")
        self.volume_label = QtWidgets.QLabel(self.synth_tab)
        self.volume_label.setGeometry(QtCore.QRect(0, 180, 55, 16))
        self.volume_label.setObjectName("volume_label")
        self.attack_label = QtWidgets.QLabel(self.synth_tab)
        self.attack_label.setGeometry(QtCore.QRect(40, 200, 55, 16))
        self.attack_label.setObjectName("attack_label")
        self.delay_label = QtWidgets.QLabel(self.synth_tab)
        self.delay_label.setGeometry(QtCore.QRect(90, 180, 55, 16))
        self.delay_label.setObjectName("delay_label")
        self.sustain_label = QtWidgets.QLabel(self.synth_tab)
        self.sustain_label.setGeometry(QtCore.QRect(140, 200, 55, 16))
        self.sustain_label.setObjectName("sustain_label")
        self.release_label = QtWidgets.QLabel(self.synth_tab)
        self.release_label.setGeometry(QtCore.QRect(200, 180, 55, 16))
        self.release_label.setObjectName("release_label")
        self.tabWidget.addTab(self.synth_tab, "")
        self.sampler_tab = QtWidgets.QWidget()
        self.sampler_tab.setObjectName("sampler_tab")
        self.tabWidget.addTab(self.sampler_tab, "")
        self.verticalLayout.addWidget(self.frame)
        MainWindow.setCentralWidget(self.centralwidget)

        self.retranslateUi(MainWindow)
        self.tabWidget.setCurrentIndex(0)
        QtCore.QMetaObject.connectSlotsByName(MainWindow)

    def retranslateUi(self, MainWindow):
        _translate = QtCore.QCoreApplication.translate
        MainWindow.setWindowTitle(_translate("MainWindow", "MainWindow"))
        self.volume_label.setText(_translate("MainWindow", "Volume"))
        self.attack_label.setText(_translate("MainWindow", "Attack"))
        self.delay_label.setText(_translate("MainWindow", "Delay"))
        self.sustain_label.setText(_translate("MainWindow", "Sustain"))
        self.release_label.setText(_translate("MainWindow", "Release"))
        self.tabWidget.setTabText(self.tabWidget.indexOf(self.synth_tab), _translate("MainWindow", "Synth"))
        self.tabWidget.setTabText(self.tabWidget.indexOf(self.sampler_tab), _translate("MainWindow", "Sampler pre alpha"))

def onClose() :
    chuck.close()
    ui.openGLWidget.timer.stop()
    print('bye!')

if __name__ == "__main__":
    global chuck, ui
    import sys
    atexit.register(onClose)
    app = QtWidgets.QApplication(sys.argv)
    MainWindow = QtWidgets.QMainWindow()
    ui = Ui_MainWindow()
    ui.setupUi(MainWindow)
    #set up chuck
    chuck = ChuckManager.ChuckManager(ui)
    print('main show')
    MainWindow.show()
    sys.exit(app.exec_())

def updateChuckVars():
    #todo tomorrow
    pass
