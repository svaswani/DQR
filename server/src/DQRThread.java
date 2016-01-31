import java.io.*;
import java.net.Socket;

/**
 * Created by Nick Mosher on 1/30/16.
 * DQR Threads are assigned a client socket and handle the exchange of
 * game data throughout the duration of the game.
 */
public class DQRThread extends Thread {

    private Socket mClient;
    private String mClientName;
    private InputStream mInputStream;
    private OutputStream mOutputStream;
    private BufferedReader mBufferedReader;

    public DQRThread(Socket client, String name) {

        if(client == null) {
            throw new IllegalArgumentException("Client socket is null!");
        }

        if(name == null) {
            System.out.println("Client name is null!");
            name = "";
        }

        mClient = client;
        mClientName = name;
        try {
            mInputStream = mClient.getInputStream();
            mOutputStream = mClient.getOutputStream();
            mBufferedReader = new BufferedReader(new InputStreamReader(mInputStream));
        } catch(IOException e) {
            e.printStackTrace();
            System.err.println("A DQR Thread encountered an error.");
            interrupt();
        }

        System.out.println("Successfully initialized DQR Thread.");
    }

    @Override
    public void run() {
        super.run();

        while(mClient.isConnected()) {

            try {
                String line;
                while(mInputStream.available() > 0) {
                    line = mBufferedReader.readLine();
                    System.out.println("Read line: " + line);
                }
            } catch(IOException e) {
                e.printStackTrace();
            }
        }

        System.out.println("DQR Thread stopped.");
    }
}
