# -*- coding: utf-8 -*-

# Form implementation generated from reading ui file 'qtD_project.ui'
#
# Created by: PyQt5 UI code generator 5.12.1
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
        MainWindow.resize(926, 836)
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
        self.volume_slider.setStyleSheet("QSlider::groove:vertical {\n"
"background: pink;\n"
"position: absolute; /* absolutely position 4px from the left and right of the widget. setting margins on the widget should work too... */\n"
"left: 4px; right: 4px;\n"
"}\n"
"QSlider::handle:vertical {\n"
"height: 10px;\n"
"background: black;\n"
"margin: 0 -4px; /* expand outside the groove */\n"
"}\n"
"")
        self.volume_slider.setMaximum(100)
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
        self.attack_slider.setStyleSheet("QSlider::groove:vertical {\n"
"background: orange;\n"
"position: absolute; /* absolutely position 4px from the left and right of the widget. setting margins on the widget should work too... */\n"
"left: 4px; right: 4px;\n"
"}\n"
"QSlider::handle:vertical {\n"
"height: 10px;\n"
"background: black;\n"
"margin: 0 -4px; /* expand outside the groove */\n"
"}\n"
"")
        self.attack_slider.setMaximum(100)
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
        self.delay_slider.setStyleSheet("QSlider::groove:vertical {\n"
"background: yellow;\n"
"position: absolute; /* absolutely position 4px from the left and right of the widget. setting margins on the widget should work too... */\n"
"left: 4px; right: 4px;\n"
"}\n"
"QSlider::handle:vertical {\n"
"height: 10px;\n"
"background: black;\n"
"margin: 0 -4px; /* expand outside the groove */\n"
"}\n"
"")
        self.delay_slider.setMaximum(100)
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
        self.sustain_slider.setStyleSheet("QSlider::groove:vertical {\n"
"background: green;\n"
"position: absolute; /* absolutely position 4px from the left and right of the widget. setting margins on the widget should work too... */\n"
"left: 4px; right: 4px;\n"
"}\n"
"QSlider::handle:vertical {\n"
"height: 10px;\n"
"background: black;\n"
"margin: 0 -4px; /* expand outside the groove */\n"
"}\n"
"")
        self.sustain_slider.setMaximum(100)
        self.sustain_slider.setOrientation(QtCore.Qt.Vertical)
        self.sustain_slider.setObjectName("sustain_slider")
        self.release_slider = QtWidgets.QSlider(self.synth_tab)
        self.release_slider.setGeometry(QtCore.QRect(210, 10, 22, 160))
        self.release_slider.setStyleSheet("QScrollBar:vertical {\n"
"    border: 2px solid grey;\n"
"    background: #32CC99;\n"
"    width: 15px;\n"
"    margin: 22px 0 22px 0;\n"
"}\n"
"QScrollBar::handle:vertical {\n"
"    background: white;\n"
"    min-height: 20px;\n"
"}\n"
"QScrollBar::add-line:vertical {\n"
"    border: 2px solid grey;\n"
"    background: #32CC99;\n"
"    height: 20px;\n"
"    subcontrol-position: bottom;\n"
"    subcontrol-origin: margin;\n"
"}\n"
"\n"
"QScrollBar::sub-line:vertical {\n"
"    border: 2px solid grey;\n"
"    background: #32CC99;\n"
"    height: 20px;\n"
"    subcontrol-position: top;\n"
"    subcontrol-origin: margin;\n"
"}\n"
"QScrollBar::up-arrow:vertical, QScrollBar::down-arrow:vertical {\n"
"    border: 2px solid grey;\n"
"    width: 3px;\n"
"    height: 3px;\n"
"    background: white;\n"
"}\n"
"\n"
"QScrollBar::add-page:vertical, QScrollBar::sub-page:vertical {\n"
"    background: none;\n"
"}\n"
"QSlider::groove:vertical {\n"
"background: blue;\n"
"position: absolute; /* absolutely position 4px from the left and right of the widget. setting margins on the widget should work too... */\n"
"left: 4px; right: 4px;\n"
"}\n"
"QSlider::handle:vertical {\n"
"height: 10px;\n"
"background: black;\n"
"margin: 0 -4px; /* expand outside the groove */\n"
"}\n"
"\n"
"")
        self.release_slider.setMaximum(100)
        self.release_slider.setSingleStep(1)
        self.release_slider.setProperty("value", 0)
        self.release_slider.setOrientation(QtCore.Qt.Vertical)
        self.release_slider.setObjectName("release_slider")
        self.volume_label = QtWidgets.QLabel(self.synth_tab)
        self.volume_label.setGeometry(QtCore.QRect(0, 180, 55, 16))
        self.volume_label.setAlignment(QtCore.Qt.AlignCenter)
        self.volume_label.setObjectName("volume_label")
        self.attack_label = QtWidgets.QLabel(self.synth_tab)
        self.attack_label.setGeometry(QtCore.QRect(40, 190, 55, 16))
        self.attack_label.setAlignment(QtCore.Qt.AlignCenter)
        self.attack_label.setObjectName("attack_label")
        self.delay_label = QtWidgets.QLabel(self.synth_tab)
        self.delay_label.setGeometry(QtCore.QRect(90, 180, 55, 16))
        self.delay_label.setAlignment(QtCore.Qt.AlignCenter)
        self.delay_label.setObjectName("delay_label")
        self.sustain_label = QtWidgets.QLabel(self.synth_tab)
        self.sustain_label.setGeometry(QtCore.QRect(140, 190, 55, 16))
        self.sustain_label.setAlignment(QtCore.Qt.AlignCenter)
        self.sustain_label.setObjectName("sustain_label")
        self.release_label = QtWidgets.QLabel(self.synth_tab)
        self.release_label.setGeometry(QtCore.QRect(200, 180, 55, 16))
        self.release_label.setAlignment(QtCore.Qt.AlignCenter)
        self.release_label.setObjectName("release_label")
        self.effects_notebook = QtWidgets.QTabWidget(self.synth_tab)
        self.effects_notebook.setGeometry(QtCore.QRect(520, 10, 391, 151))
        self.effects_notebook.setLayoutDirection(QtCore.Qt.LeftToRight)
        self.effects_notebook.setAutoFillBackground(True)
        self.effects_notebook.setTabPosition(QtWidgets.QTabWidget.South)
        self.effects_notebook.setTabShape(QtWidgets.QTabWidget.Triangular)
        self.effects_notebook.setUsesScrollButtons(False)
        self.effects_notebook.setObjectName("effects_notebook")
        self.lfo_tab = QtWidgets.QWidget()
        self.lfo_tab.setObjectName("lfo_tab")
        self.lfo_active_Button = QtWidgets.QPushButton(self.lfo_tab)
        self.lfo_active_Button.setGeometry(QtCore.QRect(10, 10, 71, 61))
        self.lfo_active_Button.setObjectName("lfo_active_Button")
        #a list for the lfo shape buttons
        #"Square", "Sine", "Tri", "Saw", "Pulse" "Noise"
        self.lfo_shape_buttons = list()

        self.lfo_shape_square_Button = QtWidgets.QRadioButton(self.lfo_tab)
        self.lfo_shape_square_Button.setGeometry(QtCore.QRect(100, 0, 95, 20))
        self.lfo_shape_square_Button.setObjectName("lfo_shape_square_Button")
        #add the button to the list
        self.lfo_shape_buttons.append(self.lfo_shape_square_Button)

        self.lfo_shape_sine_Button = QtWidgets.QRadioButton(self.lfo_tab)
        self.lfo_shape_sine_Button.setGeometry(QtCore.QRect(100, 20, 95, 20))
        self.lfo_shape_sine_Button.setObjectName("lfo_shape_sine_Button")
        #add the button to the list
        self.lfo_shape_buttons.append(self.lfo_shape_sine_Button)

        self.lfo_shape_triangle_Button = QtWidgets.QRadioButton(self.lfo_tab)
        self.lfo_shape_triangle_Button.setGeometry(QtCore.QRect(100, 40, 95, 20))
        self.lfo_shape_triangle_Button.setObjectName("lfo_shape_triangle_Button")
        #add the button to the list
        self.lfo_shape_buttons.append(self.lfo_shape_triangle_Button)

        self.lfo_shape_saw_Button = QtWidgets.QRadioButton(self.lfo_tab)
        self.lfo_shape_saw_Button.setGeometry(QtCore.QRect(100, 60, 95, 20))
        self.lfo_shape_saw_Button.setObjectName("lfo_shape_saw_Button")
        #add the button to the list
        self.lfo_shape_buttons.append(self.lfo_shape_saw_Button)

        self.lfo_shape_pulse_Button = QtWidgets.QRadioButton(self.lfo_tab)
        self.lfo_shape_pulse_Button.setGeometry(QtCore.QRect(100, 80, 95, 20))
        self.lfo_shape_pulse_Button.setObjectName("lfo_shape_pulse_Button")
        #add the button to the list
        self.lfo_shape_buttons.append(self.lfo_shape_pulse_Button)

        self.lfo_shape_noise_Button = QtWidgets.QRadioButton(self.lfo_tab)
        self.lfo_shape_noise_Button.setGeometry(QtCore.QRect(100, 100, 95, 20))
        self.lfo_shape_noise_Button.setObjectName("lfo_shape_noise_Button")
        #add the button to the list
        self.lfo_shape_buttons.append(self.lfo_shape_noise_Button)
        self.lfo_shape_label = QtWidgets.QLabel(self.lfo_tab)
        self.lfo_shape_label.setGeometry(QtCore.QRect(40, 80, 71, 21))
        font = QtGui.QFont()
        font.setPointSize(9)
        self.lfo_shape_label.setFont(font)
        self.lfo_shape_label.setObjectName("lfo_shape_label")
        self.lfo_rate_dial = QtWidgets.QDial(self.lfo_tab)
        self.lfo_rate_dial.setGeometry(QtCore.QRect(190, 10, 50, 64))
        self.lfo_rate_dial.setObjectName("lfo_rate_dial")
        self.lfo_depth_dial = QtWidgets.QDial(self.lfo_tab)
        self.lfo_depth_dial.setGeometry(QtCore.QRect(250, 10, 50, 64))
        self.lfo_depth_dial.setInvertedControls(False)
        self.lfo_depth_dial.setObjectName("lfo_depth_dial")
        self.label_3 = QtWidgets.QLabel(self.lfo_tab)
        self.label_3.setGeometry(QtCore.QRect(190, 70, 55, 16))
        self.label_3.setAlignment(QtCore.Qt.AlignCenter)
        self.label_3.setObjectName("label_3")
        self.label_4 = QtWidgets.QLabel(self.lfo_tab)
        self.label_4.setGeometry(QtCore.QRect(250, 70, 55, 16))
        self.label_4.setAlignment(QtCore.Qt.AlignCenter)
        self.label_4.setObjectName("label_4")
        self.effects_notebook.addTab(self.lfo_tab, "")
        self.delay_tab = QtWidgets.QWidget()
        self.delay_tab.setObjectName("delay_tab")
        self.delay_active_button = QtWidgets.QPushButton(self.delay_tab)
        self.delay_active_button.setGeometry(QtCore.QRect(10, 10, 71, 61))
        self.delay_active_button.setObjectName("delay_active_button")
        self.delay_max_dial = QtWidgets.QDial(self.delay_tab)
        self.delay_max_dial.setGeometry(QtCore.QRect(100, 10, 50, 64))
        self.delay_max_dial.setObjectName("delay_max_dial")
        self.delay_delay_dial = QtWidgets.QDial(self.delay_tab)
        self.delay_delay_dial.setGeometry(QtCore.QRect(160, 10, 50, 64))
        self.delay_delay_dial.setObjectName("delay_delay_dial")
        self.label = QtWidgets.QLabel(self.delay_tab)
        self.label.setGeometry(QtCore.QRect(90, 80, 71, 16))
        self.label.setObjectName("label")
        self.label_2 = QtWidgets.QLabel(self.delay_tab)
        self.label_2.setGeometry(QtCore.QRect(160, 80, 71, 16))
        self.label_2.setObjectName("label_2")
        self.effects_notebook.addTab(self.delay_tab, "")
        self.reverb_tab = QtWidgets.QWidget()
        self.reverb_tab.setObjectName("reverb_tab")
        self.reverb_active_Button = QtWidgets.QPushButton(self.reverb_tab)
        self.reverb_active_Button.setGeometry(QtCore.QRect(10, 10, 71, 61))
        self.reverb_active_Button.setObjectName("reverb_active_Button")
        self.reverb_mix_label = QtWidgets.QLabel(self.reverb_tab)
        self.reverb_mix_label.setGeometry(QtCore.QRect(100, 80, 55, 16))
        self.reverb_mix_label.setAlignment(QtCore.Qt.AlignCenter)
        self.reverb_mix_label.setObjectName("reverb_mix_label")
        self.reverb_mix_dial = QtWidgets.QDial(self.reverb_tab)
        self.reverb_mix_dial.setGeometry(QtCore.QRect(100, 10, 50, 64))
        self.reverb_mix_dial.setMinimum(0)
        self.reverb_mix_dial.setMaximum(100)
        self.reverb_mix_dial.setObjectName("reverb_mix_dial")
        self.effects_notebook.addTab(self.reverb_tab, "")
        self.Chorus = QtWidgets.QWidget()
        self.Chorus.setObjectName("Chorus")
        self.chorus_active_Button = QtWidgets.QPushButton(self.Chorus)
        self.chorus_active_Button.setGeometry(QtCore.QRect(10, 10, 71, 61))
        self.chorus_active_Button.setObjectName("chorus_active_Button")
        self.chorus_modFreq_dial = QtWidgets.QDial(self.Chorus)
        self.chorus_modFreq_dial.setGeometry(QtCore.QRect(110, 10, 50, 64))
        self.chorus_modFreq_dial.setObjectName("chorus_modFreq_dial")
        self.chorus_modDepth_dial = QtWidgets.QDial(self.Chorus)
        self.chorus_modDepth_dial.setGeometry(QtCore.QRect(190, 10, 50, 64))
        self.chorus_modDepth_dial.setObjectName("chorus_modDepth_dial")
        self.chorus_mix_dial = QtWidgets.QDial(self.Chorus)
        self.chorus_mix_dial.setGeometry(QtCore.QRect(280, 10, 50, 64))
        self.chorus_mix_dial.setObjectName("chorus_mix_dial")
        self.label_12 = QtWidgets.QLabel(self.Chorus)
        self.label_12.setGeometry(QtCore.QRect(100, 70, 71, 41))
        self.label_12.setAlignment(QtCore.Qt.AlignCenter)
        self.label_12.setWordWrap(True)
        self.label_12.setObjectName("label_12")
        self.label_13 = QtWidgets.QLabel(self.Chorus)
        self.label_13.setGeometry(QtCore.QRect(190, 80, 61, 31))
        self.label_13.setAlignment(QtCore.Qt.AlignCenter)
        self.label_13.setWordWrap(True)
        self.label_13.setObjectName("label_13")
        self.label_14 = QtWidgets.QLabel(self.Chorus)
        self.label_14.setGeometry(QtCore.QRect(280, 80, 55, 16))
        self.label_14.setAlignment(QtCore.Qt.AlignCenter)
        self.label_14.setWordWrap(True)
        self.label_14.setObjectName("label_14")
        self.effects_notebook.addTab(self.Chorus, "")
        self.eq_tab = QtWidgets.QWidget()
        self.eq_tab.setObjectName("eq_tab")
        self.eq_active_Button = QtWidgets.QPushButton(self.eq_tab)
        self.eq_active_Button.setGeometry(QtCore.QRect(10, 10, 71, 61))
        self.eq_active_Button.setObjectName("eq_active_Button")
        self.eq_low_dial = QtWidgets.QDial(self.eq_tab)
        self.eq_low_dial.setGeometry(QtCore.QRect(90, 10, 50, 64))
        self.eq_low_dial.setObjectName("eq_low_dial")
        self.eq_mid_low_dial = QtWidgets.QDial(self.eq_tab)
        self.eq_mid_low_dial.setGeometry(QtCore.QRect(150, 10, 50, 64))
        self.eq_mid_low_dial.setObjectName("eq_mid_low_dial")
        self.eq_mid_dial = QtWidgets.QDial(self.eq_tab)
        self.eq_mid_dial.setGeometry(QtCore.QRect(200, 10, 50, 64))
        self.eq_mid_dial.setObjectName("eq_mid_dial")
        self.eq_high_mid_dial = QtWidgets.QDial(self.eq_tab)
        self.eq_high_mid_dial.setGeometry(QtCore.QRect(260, 10, 50, 64))
        self.eq_high_mid_dial.setObjectName("eq_high_mid_dial")
        self.eq_high_dial = QtWidgets.QDial(self.eq_tab)
        self.eq_high_dial.setGeometry(QtCore.QRect(320, 10, 50, 64))
        self.eq_high_dial.setObjectName("eq_high_dial")
        self.label_5 = QtWidgets.QLabel(self.eq_tab)
        self.label_5.setGeometry(QtCore.QRect(90, 70, 55, 51))
        self.label_5.setAlignment(QtCore.Qt.AlignCenter)
        self.label_5.setObjectName("label_5")
        self.label_6 = QtWidgets.QLabel(self.eq_tab)
        self.label_6.setGeometry(QtCore.QRect(140, 70, 55, 41))
        self.label_6.setAlignment(QtCore.Qt.AlignCenter)
        self.label_6.setObjectName("label_6")
        self.label_7 = QtWidgets.QLabel(self.eq_tab)
        self.label_7.setGeometry(QtCore.QRect(180, 70, 91, 41))
        self.label_7.setAlignment(QtCore.Qt.AlignCenter)
        self.label_7.setObjectName("label_7")
        self.label_8 = QtWidgets.QLabel(self.eq_tab)
        self.label_8.setGeometry(QtCore.QRect(260, 80, 55, 16))
        self.label_8.setAlignment(QtCore.Qt.AlignCenter)
        self.label_8.setObjectName("label_8")
        self.label_9 = QtWidgets.QLabel(self.eq_tab)
        self.label_9.setGeometry(QtCore.QRect(320, 80, 55, 16))
        self.label_9.setAlignment(QtCore.Qt.AlignCenter)
        self.label_9.setObjectName("label_9")
        self.effects_notebook.addTab(self.eq_tab, "")
        self.listView = QtWidgets.QListWidget(self.synth_tab)
        self.listView.setGeometry(QtCore.QRect(390, 60, 101, 192))
        self.listView.setObjectName("listView")
        self.listView.addItems(['UwU', 'OwO'])
        

        self.active_effects_label = QtWidgets.QLabel(self.synth_tab)
        self.active_effects_label.setGeometry(QtCore.QRect(370, 20, 111, 31))
        font = QtGui.QFont()
        font.setFamily("Verdana")
        font.setPointSize(10)
        self.active_effects_label.setFont(font)
        self.active_effects_label.setObjectName("active_effects_label")
        self.label_10 = QtWidgets.QLabel(self.synth_tab)
        self.label_10.setGeometry(QtCore.QRect(320, 60, 55, 16))
        font = QtGui.QFont()
        font.setFamily("Verdana")
        font.setPointSize(9)
        self.label_10.setFont(font)
        self.label_10.setObjectName("label_10")
        self.label_11 = QtWidgets.QLabel(self.synth_tab)
        self.label_11.setGeometry(QtCore.QRect(320, 230, 55, 16))
        font = QtGui.QFont()
        font.setFamily("Verdana")
        font.setPointSize(9)
        self.label_11.setFont(font)
        self.label_11.setObjectName("label_11")
        self.tabWidget.addTab(self.synth_tab, "")
        self.sampler_tab = QtWidgets.QWidget()
        self.sampler_tab.setObjectName("sampler_tab")
        self.tabWidget.addTab(self.sampler_tab, "")
        self.verticalLayout.addWidget(self.frame)
        MainWindow.setCentralWidget(self.centralwidget)

        self.retranslateUi(MainWindow)
        self.tabWidget.setCurrentIndex(0)
        self.effects_notebook.setCurrentIndex(3)
        QtCore.QMetaObject.connectSlotsByName(MainWindow)

    def retranslateUi(self, MainWindow):
        _translate = QtCore.QCoreApplication.translate
        MainWindow.setWindowTitle(_translate("MainWindow", "MainWindow"))
        self.volume_label.setText(_translate("MainWindow", "Volume"))
        self.attack_label.setText(_translate("MainWindow", "Attack"))
        self.delay_label.setText(_translate("MainWindow", "Delay"))
        self.sustain_label.setText(_translate("MainWindow", "Sustain"))
        self.release_label.setText(_translate("MainWindow", "Release"))
        self.lfo_active_Button.setText(_translate("MainWindow", "Active"))
        self.lfo_shape_square_Button.setText(_translate("MainWindow", "Square"))
        self.lfo_shape_sine_Button.setText(_translate("MainWindow", "Sine"))
        self.lfo_shape_triangle_Button.setText(_translate("MainWindow", "Tri"))
        self.lfo_shape_saw_Button.setText(_translate("MainWindow", "Saw"))
        self.lfo_shape_pulse_Button.setText(_translate("MainWindow", "Pulse"))
        self.lfo_shape_noise_Button.setText(_translate("MainWindow", "Noise"))
        self.lfo_shape_label.setText(_translate("MainWindow", "Shape:"))
        self.label_3.setText(_translate("MainWindow", "Rate"))
        self.label_4.setText(_translate("MainWindow", "Depth"))
        self.effects_notebook.setTabText(self.effects_notebook.indexOf(self.lfo_tab), _translate("MainWindow", "LFO"))
        self.delay_active_button.setText(_translate("MainWindow", "Active"))
        self.label.setText(_translate("MainWindow", "Buffer Size"))
        self.label_2.setText(_translate("MainWindow", "Time Delay"))
        self.effects_notebook.setTabText(self.effects_notebook.indexOf(self.delay_tab), _translate("MainWindow", "Delay"))
        self.reverb_active_Button.setText(_translate("MainWindow", "Active"))
        self.reverb_mix_label.setText(_translate("MainWindow", "Mix"))
        self.effects_notebook.setTabText(self.effects_notebook.indexOf(self.reverb_tab), _translate("MainWindow", "Reverb"))
        self.chorus_active_Button.setText(_translate("MainWindow", "Active"))
        self.label_12.setText(_translate("MainWindow", "Modulation Frequency"))
        self.label_13.setText(_translate("MainWindow", "Modulation Depth"))
        self.label_14.setText(_translate("MainWindow", "Mix"))
        self.effects_notebook.setTabText(self.effects_notebook.indexOf(self.Chorus), _translate("MainWindow", "Chorus"))
        self.eq_active_Button.setText(_translate("MainWindow", "Active"))
        self.label_5.setText(_translate("MainWindow", "<html><head/><body><p>Low<br/></p></body></html>"))
        self.label_6.setText(_translate("MainWindow", "<html><head/><body><p>Mid-Low</p></body></html>"))
        self.label_7.setText(_translate("MainWindow", "<html><head/><body><p>Mid</p></body></html>"))
        self.label_8.setText(_translate("MainWindow", "High-Mid"))
        self.label_9.setText(_translate("MainWindow", "<html><head/><body><p>High</p><p><br/></p></body></html>"))
        self.effects_notebook.setTabText(self.effects_notebook.indexOf(self.eq_tab), _translate("MainWindow", "Equalizer"))
        self.active_effects_label.setText(_translate("MainWindow", "ActiveEffects:"))
        self.label_10.setText(_translate("MainWindow", "Input"))
        self.label_11.setText(_translate("MainWindow", "Output"))
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
    #chuck must be initialized second because It sets up some of the UI
    chuck = ChuckManager.ChuckManager(ui)
    print('main show')
    MainWindow.show()
    sys.exit(app.exec_())
