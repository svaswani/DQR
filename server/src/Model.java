import java.util.*;

/**
 * Created by Nick Mosher on 1/30/16.
 * The DQR Model stores data regarding current players and the game status.
 */
public final class Model {

    /**
     * Use a singleton for the model.
     */
    private static Model MODEL;

    /**
     * Use a set for players to avoid duplicates.
     */
    private Map<String, Player> mPlayers;

    private Model() {
        mPlayers = new HashMap<>();
    }

    /**
     * Retrieve singleton instance.
     * @return The instance of the Model.
     */
    public static Model getModel() {
        if(MODEL == null) {
            MODEL = new Model();
        }
        return MODEL;
    }

    /**
     * Data for a player element in the model.
     */
    public static final class Player {

        private String mName;
        private Player mTarget;
        private int mScore;
        private boolean mAlive;

        /**
         * Private constructor to allow to reject construction.
         * @param name The name of the player.
         * @param initialScore The starting score of the player.
         */
        private Player(String name, int initialScore) {
            mName = name;
            mScore = initialScore;
            mAlive = true;
        }

        /**
         * Initialize a new player with 0 score.
         * @param name The name of the player.
         */
        public static Player makePlayer(String name) {
            return makePlayer(name, 0);
        }

        /**
         * Initialize a player with a given score.
         * @param name The name of the player.
         * @param initialScore The starting score of the player.
         */
        private static Player makePlayer(String name, int initialScore) {

            //Null safety check the name of the player.
            if(name == null || name.equals("")) {
                Console.log_error("Player name cannot be null or blank.");
                return null;
            }

            //Null safety check the initial score.
            if(initialScore < 0) {
                Console.log_error("Initial score cannot be less than 0.");
                return null;
            }

            return new Player(name, initialScore);
        }

        /**
         * Sets this player's name.
         * @param name The name to set.
         */
        public void setName(String name) {

            if(name == null || name.equals("")) {
                Console.log_warning("Cannot set player's name; given name is null.");
                return;
            }

            mName = name;
        }

        /**
         * Returns the name of this player.
         * @return The name of this player.
         */
        public String getName() {

            return mName;
        }

        /**
         * Sets the player's score.
         * @param score The player's new score.
         */
        public void setScore(int score) {

            mScore = score;
        }

        /**
         * Returns the player's score.
         * @return The player's score.
         */
        public int getScore() {

            return mScore;
        }

        /**
         * Sets a reference to this player's target player.
         * @param target The target for this player.
         * @return True if successful, false otherwise.
         */
        public boolean setTarget(Player target) {

            if(target == null) {
                Console.log_warning("Player to set target is null.");
                return false;
            }

            mTarget = target;
            Console.debug("Player " + mName + " assigned target " + mTarget.mName + ".");
            return true;
        }

        /**
         * Returns this player's targeted player.
         * @return The target of this player.
         */
        public Player getTarget() {

            return mTarget;
        }

        /**
         * Tests whether the given object is equal to this Player.
         * @param obj The object to compare.
         * @return True if the object is a player with the same name. False otherwise.
         */
        @Override
        public boolean equals(Object obj) {

            //If the object isn't even a player, it can't be equal.
            if(!(obj instanceof Player)) {
                return false;
            }
            Player in = (Player) obj;

            //Players are considered equal if their names match.
            return mName.equals(in.mName);
        }
    }

    /**
     * Adds a new player to the model. Fails if the player already exists in the model.
     * @param playerName The name of the player to add.
     * @return True if the player was successfully added, false otherwise.
     */
    public synchronized boolean addPlayer(String playerName) {

        Player player = Player.makePlayer(playerName);

        //If the model already contains this player, refuse it.
        if(mPlayers.containsValue(player)) {
            Console.log_warning("Cannot add player \"" + player.mName + "\"; already exists.");
            return false;
        }

        mPlayers.put(player.mName, player);
        return true;
    }

    /**
     * Adds the given score to the named player. Fails if the player does not exist.
     * @param name The name of the player to change score.
     * @param score The score to add.
     * @return True if the score was successfully changed, false otherwise.
     */
    public synchronized boolean addScore(String name, int score) {

        //If the player does not exist, log warning and return failure.
        if(!mPlayers.containsKey(name)) {
            Console.log_warning("Player " + name + " does not exist.");
            return false;
        }

        //If the score argument is less than or equal to 0, log warning and return failure.
        if(score <= 0) {
            Console.log_warning("Score to change cannot be 0 or less.");
            return false;
        }

        mPlayers.get(name).mScore += score;
        return true;
    }

    /**
     * Subtracts the given score to the named player. Fails if the player does not exist.
     * @param name The name of the player to change score.
     * @param score The score to subtract.
     * @return True if the score was successfully changed, false otherwise.
     */
    public synchronized boolean subtractScore(String name, int score) {

        //If the player does not exist, log warning and return failure.
        if(!mPlayers.containsKey(name)) {
            Console.log_warning("Player " + name + " does not exist.");
            return false;
        }

        //If the score argument is less than or equal to 0, log warning and return failure.
        if(score <= 0) {
            Console.log_warning("Score to change cannot be 0 or less.");
            return false;
        }

        mPlayers.get(name).mScore -= score;
        return true;
    }

    /**
     * Returns the score of the named player. Fails if the player does not exist.
     * @param name The name of the player to get score.
     * @return The score of the player if present, -1 if the player does not exist.
     */
    public synchronized int getScore(String name) {

        //If the player does not exist, log an error and return -1.
        if(!mPlayers.containsKey(name)) {
            Console.log_error("Player " + name + " does not exist.");
            return -1;
        }

        return mPlayers.get(name).mScore;
    }

    /**
     * Returns the target of the given player.
     * @param name The name of the player to find the target of.
     * @return The name of the given player's target.
     */
    public synchronized String getTarget(String name) {

        //If the player doesn't exist, log and return.
        if(!mPlayers.containsKey(name)) {
            Console.log_error("Player " + name + " does not exist.");
            return null;
        }

        return mPlayers.get(name).getTarget().getName();
    }

    /**
     * Sets the target of the attacking player to the given target player.
     * @param attacker The attacking player.
     * @param target The player for the attacker to target.
     * @return True if successful, false otherwise.
     */
    private synchronized boolean setTarget(String attacker, String target) {

        //Null safety check the attacker.
        if(attacker == null || attacker.equals("")) {
            Console.log_warning("Attacker is null or blank.");
            return false;
        }

        //Null safety check the target.
        if(target == null || target.equals("")) {
            Console.log_warning("Target is null or blank.");
            return false;
        }

        return mPlayers.get(attacker).setTarget(mPlayers.get(target));
    }

    /**
     * Returns a string array of player names.
     * @return A string array of player names.
     */
    public synchronized String[] getPlayerNames() {

        String[] players = new String[mPlayers.size()];

        //Use an iterator to fetch values from the map's entry set.
        Iterator<Map.Entry<String, Player>> iterator = mPlayers.entrySet().iterator();
        for(int i = 0; i < players.length; i++) {
            players[i] = iterator.next().getValue().getName();
        }

        return players;
    }

    /**
     * Returns a comma-separated string of all players.
     * @return A list of all the players in the game.
     */
    public synchronized String getFormattedPlayerNames() {

        String players = "";

        //Use an iterator to fetch entries, but a for loop to count to size()-1
        Iterator<Map.Entry<String, Player>> iterator = mPlayers.entrySet().iterator();
        for(int i = 0; i < mPlayers.size()-1; i++) {
            players += (iterator.next().getValue().getName() + ",");
        }
        //This ensures we don't land on a comma.
        players += iterator.next().getValue().getName();

        return players;
    }

    /**
     * Performs game logic for a scan event.
     * @param playerScanning The player that completed a scan.
     * @param playerScanned The player that got scanned.
     */
    public synchronized void notifyScanned(String playerScanning, String playerScanned) {

        //Null safety check the scanning player.
        if(playerScanning == null || playerScanning.equals("")) {
            Console.log_warning("Scanning player is null or blank.");
            return;
        }

        //Null safety check the scanned player.
        if(playerScanned == null || playerScanned.equals("")) {
            Console.log_warning("Scanned player is null or blank.");
            return;
        }

        //Identify the target of the scanning player.
        String scannerTarget = getTarget(playerScanning);
        if(scannerTarget == null || scannerTarget.equals("")) {
            Console.log_warning("Scanning player's target is null or blank.");
            return;
        }

        //Check if the player that was scanned is the scanner's target.
        if(scannerTarget.equals(playerScanned)) {

            //Identify the old target of the victim (scanned) player.
            String victimTarget = getTarget(playerScanned);
            if(victimTarget == null || victimTarget.equals("")) {
                Console.log_warning("Victim's target is null or blank.");
                return;
            }

            //TODO assign the attacker bonus points for killing their target.

            //Log game update.
            Console.log_info("Player \"" + playerScanning + "\" has killed target \"" + playerScanned +
                    "\" and is now targeting \"" + victimTarget + "\".");

            //Assign the scanner (attacker) to the scanned player's old target.
            setTarget(playerScanning, victimTarget);

        } else {

            //If the player scanned was not the scanner's target, the scanned player gains points.
        }
    }

    /**
     * Generates a random assignment of targets for each player.
     */
    public synchronized void generateTargets() {

        //If there are too few players, log and quit.
        if(mPlayers.size() < 3) {
            Console.log_warning("There must be more than 2 players to generate a matchup.");
            return;
        }

        Console.log_info("Begin assigning targets.");

        //Create a list of the players and shuffle them to assign targets.
        List<Player> shuffleList = new ArrayList<>();
        for(Map.Entry<String, Player> e : mPlayers.entrySet()) {
            shuffleList.add(e.getValue());
        }
        Collections.shuffle(shuffleList);

        //Set each player's target to the next player.
        Player next, prev;
        for(int i = 1; i < shuffleList.size(); i++) {
            (prev = shuffleList.get(i-1)).setTarget(next = shuffleList.get(i));
            Console.debug("Player " + prev.mName + " targeting " + next.mName + ".");
        }
        //Set the last player's target to the first player.
        (prev = shuffleList.get(shuffleList.size()-1)).setTarget(next = shuffleList.get(0));
        Console.debug("Player " + prev.mName + " targeting " + next.mName + ".");

        Console.log_info("Players shuffled and assigned targets.");
    }
}
