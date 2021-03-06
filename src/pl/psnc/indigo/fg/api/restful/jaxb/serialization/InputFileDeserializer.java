package pl.psnc.indigo.fg.api.restful.jaxb.serialization;

import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.databind.DeserializationContext;
import com.fasterxml.jackson.databind.JsonDeserializer;
import com.fasterxml.jackson.databind.JsonNode;
import pl.psnc.indigo.fg.api.restful.jaxb.InputFile;

import java.io.IOException;

/**
 * Deserializes information about input files from JSON objects.
 */
public final class InputFileDeserializer extends JsonDeserializer<InputFile> {
    @Override
    public InputFile deserialize(final JsonParser jsonParser,
                                 final DeserializationContext
                                         deserializationContext)
            throws IOException {
        JsonNode node = jsonParser.readValueAsTree();
        String name = node.asText();

        InputFile inputFile = new InputFile();
        inputFile.setName(name);
        return inputFile;
    }
}
