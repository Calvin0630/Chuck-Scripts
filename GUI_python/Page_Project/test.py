import wx
import glglue.sample
import glglue.wxglcanvas
class Frame(wx.Frame):
    def __init__(self, parent, **kwargs):
        super(Frame, self).__init__(parent, **kwargs)
        # setup opengl widget
        self.controller=glglue.sample.SampleController()
        self.glwidget=glglue.wxglcanvas.Widget(self, self.controller)
        # packing
        sizer=wx.BoxSizer(wx.HORIZONTAL)
        self.SetSizer(sizer)
        sizer.Add(self.glwidget, 1, wx.EXPAND)

app = wx.App(False)
frame=Frame(None, title='glglue')
frame.Show()
app.MainLoop()