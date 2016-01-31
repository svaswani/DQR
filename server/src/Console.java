import java.util.Scanner;

/**
 * Created by Nick Mosher on 1/31/16.
 * Console tools allow interfacing with the command line gracefully.
 */
public class Console {

    /**
     * Switch to enable or disable console output messages. This allows for
     * prompts to be given without interruption.
     */
    private static boolean outputEnabled = true;

    /**
     * Switch to enable or disable debug messages.
     */
    private static boolean debugEnabled = true;

    /**
     * If true, error messages will still display regardless of whether the
     * output is enabled.
     */
    private static boolean errorOverrideEnabled = true;

    /**
     * Scanner to parse user input.
     */
    private static Scanner mScanner = new Scanner(System.in);

    /**
     * Prompts given messages to the console and accepts responses to each.
     * @param prompts A variable argument parameter of prompts.
     * @return A String array of responses to the prompts.
     */
    public static String[] prompt(String... prompts) {

        //Create an array to store the responses in.
        String[] responses = new String[prompts.length];

        //Print each prompt and record responses.
        for(int i = 0; i < responses.length; i++) {
            System.out.println(prompts[i]);
            responses[i] = mScanner.next();
        }
        return responses;
    }

    /**
     * Prints a debug log to the console.
     * @param debug Debug message to display.
     */
    public static void debug(String debug) {
        if(outputEnabled && debugEnabled) {
            System.out.println("[DEBUG] " + debug);
        }
    }

    /**
     * Prints an info log to the console.
     * @param info Info to display.
     */
    public static void log_info(String info) {
        if(outputEnabled) {
            System.out.println("[INFO] " + info);
        }
    }

    /**
     * Prints a warning log to the console.
     * @param warning Warning to display.
     */
    public static void log_warning(String warning) {
        if(outputEnabled) {
            System.out.println("[WARNING] " + warning);
        }
    }

    /**
     * Prints an error log to the console.
     * @param error Error to display.
     */
    public static void log_error(String error) {
        if(outputEnabled || errorOverrideEnabled) {
            System.err.println("[ERROR] " + error);
        }
    }
}
