import javax.swing.*;
import javax.swing.event.ChangeEvent;
import javax.swing.event.ChangeListener;

import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.WindowEvent;
import java.awt.event.WindowListener;

//each channel will have its own panel
public class ChannelPanel extends JPanel implements ActionListener,
WindowListener,
ChangeListener{

    public ChannelPanel() {
        super();
        setSize(100,100);
        setLayout(new GridBagLayout());
        //gain 0-100 is the gain for the channel
        JSlider gain = new JSlider(JSlider.VERTICAL,0,100,0);
        
        gain.addChangeListener(this);
        gain.setMajorTickSpacing(10);
        gain.setMinorTickSpacing(25);
        gain.setPaintTicks(true);
        gain.setPaintLabels(true);
        add(gain);
        setVisible(true);
    }

	@Override
	public void stateChanged(ChangeEvent e) {
		JSlider source = (JSlider)e.getSource();
		if (!source.getValueIsAdjusting()) {
			System.out.println(source.getValue());
			
		}
		
	}

	@Override
	public void windowOpened(WindowEvent e) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void windowClosing(WindowEvent e) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void windowClosed(WindowEvent e) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void windowIconified(WindowEvent e) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void windowDeiconified(WindowEvent e) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void windowActivated(WindowEvent e) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void windowDeactivated(WindowEvent e) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void actionPerformed(ActionEvent e) {
		// TODO Auto-generated method stub
		
	}
}
