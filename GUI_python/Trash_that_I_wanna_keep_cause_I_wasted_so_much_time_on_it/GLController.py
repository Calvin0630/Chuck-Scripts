'''
GLController replaces sampleController
GLPerspectiveView replaces targetview


glutCreateWindow → creation of a QGLWidget instance
glutDisplayFunc & a display handler → reimplement QGLWidget::paintGL in a derived class
glutReshapeFunc & a resize handler → reimplement QGLWidget::resizeGL in a derived class
user input functions → reimplement the event methods of QWidget
'''
import re
import sys
import math
import time
import GLPrespectiveView
from OpenGL.GL import *
from OpenGL.GLUT import *
from OpenGL.GLU import *

import MyQGL

DELEGATE_PATTERN=re.compile('^on[A-Z]')
VELOCITY=0.1


def to_radian(degree):
    return degree/180.0*math.pi


class Scene(object):
    def __init__(self):
        self.xrot=0
        self.yrot=0

    def onUpdate(self, ms):
        print('updating scene')
        self.yrot+=ms * VELOCITY
        while self.yrot>360.0:
            self.yrot-=360.0
        self.xrot+=ms * VELOCITY * 0.5
        while self.xrot>360.0:
            self.xrot-=360.0

    def draw(self):
        glRotate(math.sin(to_radian(self.yrot))*180, 0, 1, 0)
        glRotate(math.sin(to_radian(self.xrot))*180, 1, 0, 0)
        glScalef(20,20,20)
        Mesh.draw()
        glRotatef(1,0,1,0)


class GLController(object):
    def __init__(self, view=None, scene=None):
        self.view=GLPrespectiveView.TargetView()
        self.scene= Scene()
        self.isInitialized=False
        self.initilaize()
        self.delegate(view)
        self.delegate(scene)

    def addWidget(self, widget) :
        self.widget = widget

    def delegate(self, to):
        for name in dir(to):  
            if DELEGATE_PATTERN.match(name):
                method = getattr(to, name)  
                setattr(self, name, method)

    def onUpdate(self, ms):
        self.scene.onUpdate(ms)

    def onResize(self,width,height) :
        pass

    def onInitialize(*args):
        pass

    def initilaize(self):
        self.view.onResize()
        glEnable(GL_DEPTH_TEST)
        glClearColor(1.0, 0.5, 0.0, 0.0)
        
        # 初期化時の呼び出し
        self.onInitialize()

    def draw(self):
        if not self.isInitialized:
            self.initilaize()
            self.isInitialized=True
        # OpenGLバッファのクリア
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)
        # 投影行列のクリア
        glLoadIdentity()
        glMatrixMode(GL_PROJECTION)
        self.view.updateProjection()
        # 描画
        #wait for 1 60th of a second
        #time.sleep(1/60)
        self.scene.draw()
        Mesh.draw()
        glFlush()
        #glutSwapBuffers()
        print('update: '+str(time.time()))
    #event function


    def onLeftDown(self,x,y):
        print('left down at: '+str(x)+' '+str(y))
        self.view.printCameraVars()
        self.widget.repaint()
        pass

    def onMiddleDown(self,x,y):
        pass

    def onRightDown(self,x,y):
        pass

    def onLeftUp(self,x,y):
        pass

    def onMiddleUp(self,x,y):
        pass

    def onRightUp(self,x,y):
        pass

    def onMotion(self,x,y):
        pass

    def onWheel(self,delta):
        self.view.onWheel(delta)
        pass

class Mesh:
    verts = [1]
    def draw() : 
               # Draw Cube (multiple quads)
        glBegin(GL_QUADS)
 
        glColor3f(0.0,1.0,0.0)
        glVertex3f( 1.0, 1.0,-1.0)
        glVertex3f(-1.0, 1.0,-1.0)
        glVertex3f(-1.0, 1.0, 1.0)
        glVertex3f( 1.0, 1.0, 1.0) 
 
        glColor3f(1.0,0.0,0.0)
        glVertex3f( 1.0,-1.0, 1.0)
        glVertex3f(-1.0,-1.0, 1.0)
        glVertex3f(-1.0,-1.0,-1.0)
        glVertex3f( 1.0,-1.0,-1.0) 
 
        glColor3f(0.0,1.0,0.0)
        glVertex3f( 1.0, 1.0, 1.0)
        glVertex3f(-1.0, 1.0, 1.0)
        glVertex3f(-1.0,-1.0, 1.0)
        glVertex3f( 1.0,-1.0, 1.0)
 
        glColor3f(1.0,1.0,0.0)
        glVertex3f( 1.0,-1.0,-1.0)
        glVertex3f(-1.0,-1.0,-1.0)
        glVertex3f(-1.0, 1.0,-1.0)
        glVertex3f( 1.0, 1.0,-1.0)
 
        glColor3f(0.0,0.0,1.0)
        glVertex3f(-1.0, 1.0, 1.0) 
        glVertex3f(-1.0, 1.0,-1.0)
        glVertex3f(-1.0,-1.0,-1.0) 
        glVertex3f(-1.0,-1.0, 1.0) 
 
        glColor3f(1.0,0.0,1.0)
        glVertex3f( 1.0, 1.0,-1.0) 
        glVertex3f( 1.0, 1.0, 1.0)
        glVertex3f( 1.0,-1.0, 1.0)
        glVertex3f( 1.0,-1.0,-1.0)

        glEnd()