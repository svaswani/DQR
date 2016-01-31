import java.io.IOException;
import java.net.ServerSocket;
import java.net.Socket;

/**
 * Created by Nick Mosher on 1/30/16.
 * The Death-by-QR Server listens for connections from clients and
 * initiates threads to handle interactions with them for the
 * duration of the game.
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
                Console.log_info("Waiting for clients to connect...");
                incomingClient = serverSocket.accept();
                String displayName = (!incomingClient.getInetAddress().getHostName().equals("")) ?
                        incomingClient.getInetAddress().getHostName() :
                        incomingClient.getInetAddress().getHostAddress();
                Console.log_info("Client " + displayName + " connected! Starting DQR Thread...");
                new DQRThread(incomingClient, displayName).start();
            }

        } catch(IOException e) {
            Console.log_error("FATAL: DQR Server encountered an IO error");
        }
    }
}
