import java.io.IOException;
import java.net.ServerSocket;
import java.net.Socket;

/**
 * Created by Nick Mosher on 1/30/16.
 */
public class Server {

    /**
     * Reference to the listening server socket.
     */
    private static ServerSocket serverSocket;

    public static void main(String[] args) {

        try {
            //Listen on port 4000
            serverSocket = new ServerSocket(4000);

            //Continuously accept new incoming client requests and spin up new DQRThreads to handle them.
            Socket incomingClient;
            while(true) {
                incomingClient = serverSocket.accept();
                new DQRThread(incomingClient).start();
            }

        } catch(IOException e) {
            e.printStackTrace();
            System.err.println("DQR Server encountered an IO Error");
        }
    }
}
