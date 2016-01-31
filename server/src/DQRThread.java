import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.Socket;

/**
 * Created by Nick Mosher on 1/30/16.
 */
public class DQRThread extends Thread {

    private Socket mClient;
    private InputStream mInputStream;
    private OutputStream mOutputStream;

    public DQRThread(Socket client) {

        if(client == null) {
            throw new IllegalArgumentException("Client socket is null!");
        }

        mClient = client;
        try {
            mInputStream = mClient.getInputStream();
            mOutputStream = mClient.getOutputStream();
        } catch(IOException e) {
            e.printStackTrace();
            System.err.println("A DQR Thread encountered an error.");
            interrupt();
        }
    }

    @Override
    public void run() {
        super.run();

        while(mClient.isConnected()) {

        }
    }
}
