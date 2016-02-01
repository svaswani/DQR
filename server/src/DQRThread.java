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
    private String mPlayerName;
    private InputStream mInputStream;
    private OutputStream mOutputStream;
    private BufferedReader mBufferedReader;

    public DQRThread(Socket client, String name) {

        if(client == null) {
            throw new IllegalArgumentException("Client socket is null!");
        }

        if(name == null) {
            Console.log_warning("Client name is null!");
            name = "";
        }

        mClient = client;
        mClientName = name;
        try {
            mInputStream = mClient.getInputStream();
            mOutputStream = mClient.getOutputStream();
            mBufferedReader = new BufferedReader(new InputStreamReader(mInputStream));

            mOutputStream.write("Hello iOS from server.".getBytes());
        } catch(IOException e) {
            Console.log_error("A DQR Thread encountered an error.");
            interrupt();
        }

        //Register a listener to be called back when any player is killed.
        Model.getModel().registerOnPlayerKilledListener(new Model.OnPlayerKilledListener() {
            @Override
            public void notifyPlayerKilled(String name) {

            }
        });

        Console.log_info("Successfully initialized DQR Thread.");
    }

    @Override
    public void run() {
        super.run();

        Console.log_info("DQR Thread successfully started.");

        while(mClient.isConnected()) {

            Console.debug("DQR Client " + mClientName + " is still connected.");

            try {
                String line;
                while(mInputStream.available() > 0) {
                    line = mBufferedReader.readLine();
                    Console.log_info("From \"" + mClientName + "\", read: " + line);
                    parseCommand(line);
                }

            } catch(IOException e) {
                Console.log_error("Problem reading from input stream of " + mClientName + ".");
            }
        }
        Console.log_info("Disconnected from " + mClientName);
    }

    /* ~ Define expected commands from the client. ~ */
    public static final String COMMAND_ADD_PLAYER = "a";
    public static final String COMMAND_GET_SCORE = "s";
    public static final String COMMAND_GET_TARGET = "t";
    public static final String COMMAND_LIST_PLAYERS = "l";
    public static final String COMMAND_SCAN = "n";
    public static final String COMMAND_PLAYER_KILLED = "k";

    /**
     * Parses a command received from the input stream of the client and
     * executes the necessary functions.
     * @param input The command received from a client.
     */
    public void parseCommand(String input) {

        //If the input is null or blank, warn and skip.
        if(input == null || input.equals("")) {
            Console.log_warning("Received blank line.");
            return;
        }

        //All valid commands contain a :, so check it.
        if(!input.contains(":")) {
            Console.log_warning("Command does not contain ':' delimiter.");
        }

        //The command should always be non-null, the argument may or may not be.
        String command = input.split(":")[0];
        String argument = (input.split(":").length > 1) ? input.split(":")[1] : null;

        if(command.length() != 1) {
            Console.log_warning("Command string \"" + command + "\" is improperly formatted.");
            return;
        }

        //Variable used if a message needs to be sent back to the client.
        String message;

        switch(command) {
            case COMMAND_ADD_PLAYER:

                Console.log_info("Received \"Add Player\" command from client \"" + mClientName + "\".");

                //Check that the argument is not null.
                if(argument == null || argument.equals("")) {
                    Console.log_warning("Argument for \"Add Player\" command cannot be null.");
                    return;
                }

                //Add a new player to the model.
                if(Model.getModel().addPlayer(argument) && (mPlayerName == null || mPlayerName.equals(""))) {
                    mPlayerName = argument;
                    Console.log_info("Successfully added player \"" + mPlayerName + "\" from client \"" + mClientName + "\".");

                } else if(mPlayerName != null && !mPlayerName.equals("")) {
                    Console.log_warning("Client " + mClientName + " is already linked to player " + mPlayerName);
                }
                break;

            case COMMAND_GET_SCORE:

                Console.log_info("Received \"Get Score\" command from client \"" + mClientName + "\".");

                //Check that the argument is not null.
                if(argument == null || argument.equals("")) {
                    Console.log_warning("Argument for \"Get Score\" command cannot be null.");
                    return;
                }

                //Retrieve the score from the model.
                int score = Model.getModel().getScore(argument);
                if(score == -1) {
                    Console.log_warning("Player " + argument + " does not exist or has an invalid score.");
                    return;
                }

                //Prepare message to send to the client.
                message = "s:" + score;

                //Send the score to the client.
                try {
                    mOutputStream.write(message.getBytes());
                } catch(IOException e) {
                    Console.log_error("Failed to write data to " + mClientName + "'s output stream.");
                    return;
                }
                break;

            case COMMAND_GET_TARGET:

                Console.log_info("Received \"Get Target\" command from client \"" + mClientName + "\".");

                //Check that the argument is not null.
                if(argument == null || argument.equals("")) {
                    Console.log_warning("Argument for \"Get Target\" command cannot be null.");
                    return;
                }

                sendTargetOf(argument);

            case COMMAND_LIST_PLAYERS:

                sendPlayerList();
                break;

            case COMMAND_SCAN:

                Console.log_info("Received \"Player Attacked\" command from client \"" + mClientName + "\"");

                //Check that the argument is not null.
                if(argument == null || argument.equals("")) {
                    Console.log_warning("Argument for \"Scan\" command cannot be null.");
                    return;
                }

                //Check that the argument is delimited by a comma with two names.
                String[] names = argument.split(",");
                if(names.length != 2) {
                    Console.log_warning("Argument for \"Scan\" command is improperly formatted.");
                    return;
                }

                //Notify the model of the scan event.
                Model.getModel().notifyScanned(names[0], names[1]);

                break;
            default:
                Console.log_warning("Command \"" + command + "\" received from client \"" + mClientName + "\" unrecognized.");
        }
    }

    /**
     * Sends a formatted string list of all players.
     */
    public void sendPlayerList() {
        try {
            String message = COMMAND_LIST_PLAYERS + ":" + Model.getModel().getFormattedPlayerNames();
            mOutputStream.write(message.getBytes());
        } catch(IOException e) {
            Console.log_warning("Failed to send player list to client.");
        }
    }

    /**
     * Sends the target of the named player to the client.
     * @param name The name of the player.
     */
    public void sendTargetOf(String name) {
        try {
            String message = COMMAND_GET_TARGET + ":" + Model.getModel().getTarget(name);
            mOutputStream.write(message.getBytes());
        } catch(IOException e) {
            Console.log_warning("Failed to send player \"" + name + "\"'s target to client.");
        }
    }

    /**
     * Sends the score of the named player to the client.
     * @param name The name of the player.
     */
    public void sendScoreOf(String name) {
        try {
            String message = COMMAND_GET_SCORE + ":" + Model.getModel().getScore(name);
            mOutputStream.write(message.getBytes());
        } catch(IOException e) {
            Console.log_warning("Failed to send player \"" + name + "\"'s score to client.");
        }
    }

    /**
     * Notify the client whenever a player is killed.
     * @param name The name of the killed player.
     */
    public void sendPlayerKilledNotification(String name) {
        try {
            String message = COMMAND_PLAYER_KILLED + ":" + name;
            mOutputStream.write(message.getBytes());
        } catch(IOException e) {
            Console.log_warning("Failed to send kill notification of \"" + name + "\" to client.");
        }
    }
}
