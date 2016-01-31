/**
 * Created by Nick Mosher on 1/31/16.
 * Test class to verify program functionality.
 */
public class Test {

    private static String[] names = {
            "Al",
            "Bob",
            "Cal",
            "Dan",
            "Fred",
            "Greg",
            "Greg"
    };

    /**
     * Perform unit tests to ensure the server still provides desired results.
     * @param args Command line arguments
     */
    public static void main(String[] args) {

        Model model = Model.getModel();

        //Add some players to the model.
        for(String name : names) {
            model.addPlayer(Model.Player.makePlayer(name));
        }

        //Print a list of all of the players and ensure none failed to print.
        String allPlayers = model.getPlayerNames();
        Console.log_info("List players: " + allPlayers);
        for(String name : names) {
            if(!allPlayers.contains(name)) {
                Console.log_warning("Model is missing " + name + ".");
            }
        }

        //Assign each player a target.
        model.generateTargets();
        Console.log_info("Assigned targets.");
    }
}
