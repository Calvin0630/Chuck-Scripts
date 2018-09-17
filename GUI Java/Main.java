import java.io.IOException;
import java.lang.Runtime;
import java.util.*;
			

public class Main {
  public static void main(String[] args) throws IOException, InterruptedException {
        // Prints "Hello, World" to the terminal window.
        MyFrame frame = new MyFrame();
        ChannelPanel chan = new ChannelPanel();
        frame.getContentPane().add(chan);
        frame.pack();
        String command = "cmd /c mkdir C:\\Users\\Calvin\\Desktop\\OwOTEST";
        Process p = Runtime.getRuntime().exec(command);
        
        
    }
}
