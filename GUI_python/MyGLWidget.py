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
        self.initCube()
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
        #print('drawing')
        GL.glClear(GL.GL_COLOR_BUFFER_BIT | GL.GL_DEPTH_BUFFER_BIT)
        now = time.time() - self.startTime
        GL.glLoadIdentity()
        GL.glTranslate(0.0, 0.0, -5.0)
        GL.glScale(2.0, 2.0, 2.0)
        GL.glRotate(1000*math.sin(now/10), 0, 1, 0)
        GL.glRotate(1000*math.cos(now/10), 1, 0, 0)
        GL.glRotate(100*math.tan(now/10), 0, 0, 1)
        GL.glTranslate(-0.5, -0.5, -0.5)

        GL.glEnableClientState(GL.GL_VERTEX_ARRAY)
        GL.glEnableClientState(GL.GL_COLOR_ARRAY)
        GL.glVertexPointerf(self.cubeVtxArray)
        GL.glColorPointerf(self.cubeClrArray)
        GL.glDrawElementsui(GL.GL_QUADS, self.cubeIdxArray)

        GL.glLoadIdentity()
        GL.glBegin(GL.GL_LINES)
        GL.glColor3f(0,1,0)

        #draw the grid
        for x in range(50) :
            #print(str((x/2)-12.5))
            #horizontal
            GL.glVertex3f(25,-1,((x/2)-12.5))
            GL.glVertex3f(-25,-1,((x/2)-12.5))
            #forward
            GL.glVertex3f(((x/2)-12.5),-1,12.5)
            GL.glVertex3f(((x/2)-12.5),-1,-12.5)

        GL.glEnd()
        self.drawData()
        GL.glFlush()
        #time.sleep(1)
        #self.paintGL()

    def initCube(self) :
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
    def drawData(self):
        GL.glLoadIdentity()
        GL.glColor3f(1,0,0)
        GL.glBegin(GL.GL_QUADS)
        GL.glVertex3f(10,-1,10)
        GL.glVertex3f(10,-1,-10)
        GL.glVertex3f(-10,-1,-10)
        GL.glVertex3f(-10,-1,10)
        GL.glEnd()
    def spin(self):
        self.yRotDeg = (self.yRotDeg  + 1) % 360.0
        self.parent.statusBar().showMessage('rotation %f' % self.yRotDeg)
        self.updateGL()
