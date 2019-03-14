from graphics import *
import AudioCapture

def initWindow() :
    windowWidth = 500
    windowHeight = 500
    win = GraphWin('Face', windowWidth, windowHeight) # give title and dimensions
    #deltaX = windowWidth/AudioCapture.chunkSize
    #print('deltaX: '+str(deltaX))
    Rectangle(Point(10,10),Point(20,20)).draw(win)
    win.getMouse()

def DrawLine(data) :
    for x in range(len(data)-1) :
        #p1 = Point()
        #p2 = Point()
        #Line.draw(point(data[x])
        print('hello')
    