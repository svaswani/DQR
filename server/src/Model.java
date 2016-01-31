import java.util.HashSet;
import java.util.Set;

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
    private Set<Player> mPlayers;

    private Model() {
        mPlayers = new HashSet<>();
    }

    /**
     * Retrieve singleton instance.
     * @return The instance of the Model.
     */
    private Model getModel() {
        if(MODEL == null) {
            MODEL = new Model();
        }
        return MODEL;
    }

    /**
     * Data for a player element in the model.
     */
    public static final class Player {

        public String mName;
        public int mScore;

        /**
         * Initialize a new player with 0 score.
         * @param name The name of the player.
         */
        public Player(String name) {
            this(name, 0);
        }

        /**
         * Initialize a player with a given score.
         * @param name The name of the player.
         * @param initialScore The starting score of the player.
         */
        public Player(String name, int initialScore) {

            //Null safety check the name of the player.
            if(name == null || name.equals("")) {
                throw new IllegalArgumentException("Player name cannot be null or blank.");
            }

            //Null safety check the initial score.
            if(initialScore < 0) {
                throw new IllegalArgumentException("Initial score cannot be less than 0.");
            }

            mName = name;
            mScore = initialScore;
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
     * @param player The player to add.
     * @return True if the player was successfully added, false otherwise.
     */
    public boolean addPlayer(Player player) {

        //If the model already contains this player, refuse it.
        if(mPlayers.contains(player)) {
            System.err.println("Cannot add player \"" + player.mName + "\"; already exists!");
            return false;
        }

        mPlayers.add(player);
        return true;
    }
}
