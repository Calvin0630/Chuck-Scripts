from PyQt5 import Qt
import GLController
import glglue.qgl
class Window(Qt.QWidget):
    def __init__(self, parent=None):
        Qt.QWidget.__init__(self, parent)
        # setup opengl widget
        self.controller=GLController.GLController()
        self.glwidget=glglue.qgl.Widget(self, self.controller)
        # packing
        mainLayout = Qt.QHBoxLayout()
        mainLayout.addWidget(self.glwidget)
        self.setLayout(mainLayout)

import sys
app = Qt.QApplication(sys.argv)
window = Window()
window.resize(500,500)
window.show()
sys.exit(app.exec_())