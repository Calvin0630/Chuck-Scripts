import sys
from PyQt5 import QtCore
from PyQt5 import QtGui
from PyQt5 import QtOpenGL
import OpenGL.GL as GL
import OpenGL.GLU as GLU
import OpenGL.GLUT as GLUT
from numpy import array
import time
import math
import threading

class MyGLWidget(QtOpenGL.QGLWidget):

    def __init__(self, parent=None):
        self.parent = parent
        QtOpenGL.QGLWidget.__init__(self, parent)
        self.startTime = time.time()
        self.setMinimumSize(100, 100)
        self.initGeometry()
        self.timer = QtCore.QTimer()
        self.timer.timeout.connect(self.update)
        #self.doubleBuffer()
        #self.setAutoBufferSwap(True)
        #self.paintingActive(True)
        

    def initializeGL(self):
        '''
        Initialize GL
        '''
        
        # set viewing projection
        GL.glClearColor(0.0, 0.0, 0.0, 1.0)
        GL.glClearDepth(1.0)

        GL.glMatrixMode(GL.GL_PROJECTION)
        GL.glLoadIdentity()
        GLU.gluPerspective(40.0, 1.0, 1.0, 30.0)
        self.timer.start(20)


    def resizeGL(self, width, height):
        if height == 0: height = 1
        GL.glViewport(0, 0, width, height)
        GL.glMatrixMode(GL.GL_PROJECTION)
        GL.glLoadIdentity()
        GLU.gluPerspective(45.0, (width/height), 1.0, 100.0)
        GL.glMatrixMode(GL.GL_MODELVIEW)

    def paintGL(self):
        print('drawing')
        GL.glClear(GL.GL_COLOR_BUFFER_BIT | GL.GL_DEPTH_BUFFER_BIT)
        now = time.time() - self.startTime
        GL.glLoadIdentity()
        GL.glTranslate(0.0, 0.0, -50.0)
        GL.glScale(20.0, 20.0, 20.0)
        GL.glRotate(1000*math.sin(now/10), 0, 1, 0)
        GL.glRotate(1000*math.cos(now/10), 1, 0, 0)
        GL.glRotate(100*math.tan(now/10), 0, 0, 1)
        GL.glTranslate(-0.5, -0.5, -0.5)

        GL.glEnableClientState(GL.GL_VERTEX_ARRAY)
        GL.glEnableClientState(GL.GL_COLOR_ARRAY)
        GL.glVertexPointerf(self.cubeVtxArray)
        GL.glColorPointerf(self.cubeClrArray)
        GL.glDrawElementsui(GL.GL_QUADS, self.cubeIdxArray)
        GL.glFlush()
        #time.sleep(1)
        #self.paintGL()

    def initGeometry(self):
        self.cubeVtxArray = array(
                [[0.0, 0.0, 0.0],
                 [1.0, 0.0, 0.0],
                 [1.0, 1.0, 0.0],
                 [0.0, 1.0, 0.0],
                 [0.0, 0.0, 1.0],
                 [1.0, 0.0, 1.0],
                 [1.0, 1.0, 1.0],
                 [0.0, 1.0, 1.0]])
        self.cubeIdxArray = [
                0, 1, 2, 3,
                3, 2, 6, 7,
                1, 0, 4, 5,
                2, 1, 5, 6,
                0, 3, 7, 4,
                7, 6, 5, 4 ]
        self.cubeClrArray = [
                [0.0, 0.0, 0.0],
                [1.0, 0.0, 0.0],
                [1.0, 1.0, 0.0],
                [0.0, 1.0, 0.0],
                [0.0, 0.0, 1.0],
                [1.0, 0.0, 1.0],
                [1.0, 1.0, 1.0],
                [0.0, 1.0, 1.0 ]]
        def spin(self):
            self.yRotDeg = (self.yRotDeg  + 1) % 360.0
            self.parent.statusBar().showMessage('rotation %f' % self.yRotDeg)
            self.updateGL()
