/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package pl.psnc.indigo.cli.parser;

import org.apache.commons.cli.CommandLine;
import pl.psnc.indigo.cli.commands.AbstractCommand;
import pl.psnc.indigo.cli.commands.GetTask;

/**
 * @author michalo
 */
public final class GetTaskParser {
    /**
     * Parses CommandLine arguments and creates
     * Command for getting status of task.
     *
     * @param cmd Command Line arguments - parsed
     * @return returns Command that will call FG API and get task status
     */
    public static AbstractCommand parse(final CommandLine cmd) {
        final String token = cmd.getOptionValue("token", "");
        final String url = cmd.getOptionValue("url", "");

        if (token.isEmpty()) {
            throw new IllegalArgumentException(
                    "You have to pass user's token to list applications." +
                    " Use -token argument to pass user's token");
        }
        if (url.isEmpty()) {
            throw new IllegalArgumentException(
                    "You have to pass FutureGateway API URL if " +
                    "you want to list applications." +
                    " Use -url argument to pass FG API URL.");
        }

        return new GetTask(cmd.getOptionValue("getTask"), url, token);
    }

    /**
     * We want to make sure there are no GetTaskParser objects that were
     * created without parameters.
     */
    private GetTaskParser() {
        super();
    }
}
