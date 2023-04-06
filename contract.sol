pragma solidity >=0.4.22 <0.9.0;

contract BELLa {
    mapping(string => mapping(string => uint256)) private model;
    mapping(string => uint256) private wordCount;
    string[] private words;
    uint256 private numWords;

    function create_model(string memory text) public pure returns (string[] memory) {
        uint256 length = bytes(text).length;
        uint256 wordCount = 1;

        // Count the number of words in the string
        for (uint256 i = 0; i < length; i++) {
            if (bytes(text)[i] == ' ') {
                wordCount++;
            }
        }
      
        string[] memory words = new string[](wordCount);
        uint256 wordIndex = 0;
        string memory currentWord = '';
        
        // Iterate over the string, adding each word to the array
        for (uint256 i = 0; i < length; i++) {
            if (bytes(text)[i] != ' ') {
                currentWord = string(abi.encodePacked(currentWord, bytes(text)[i]));
            } else {
                words[wordIndex] = currentWord;
                wordIndex++;
                currentWord = '';
            }
        }
        
        // Add the final word to the array
        words[wordIndex] = currentWord;
        
        return words;
    }

    function tokenize_text(string memory text) public pure returns (string[] memory) {
        uint256 length = bytes(text).length;
        uint256 wordCount = 1;

        // Count the number of words in the string
        for (uint256 i = 0; i < length; i++) {
            if (bytes(text)[i] == ' ') {
                wordCount++;
            }
        }
      
        string[] memory words = new string[](wordCount);
        uint256 wordIndex = 0;
        string memory currentWord = '';
        
        // Iterate over the string, adding each word to the array
        for (uint256 i = 0; i < length; i++) {
            if (bytes(text)[i] != ' ') {
                currentWord = string(abi.encodePacked(currentWord, bytes(text)[i]));
            } else {
                words[wordIndex] = currentWord;
                wordIndex++;
                currentWord = '';
            }
        }
        
        // Add the final word to the array
        words[wordIndex] = currentWord;
        
        return words;
    }

    function add_text(string memory text) public {
        string[] memory tokens = tokenize_text(text);
        for (uint256 i = 0; i < tokens.length - 1; i++) {
            string memory currentWord = tokens[i];
            string memory nextWord = tokens[i + 1];
            model[currentWord][nextWord]++;
            wordCount[currentWord]++;
            if (wordCount[currentWord] == 1) {
                words.push(currentWord);
                numWords++;
            }
        }
        string memory lastWord = tokens[tokens.length - 1];
        wordCount[lastWord]++;
        if (wordCount[lastWord] == 1) {
            words.push(lastWord);
            numWords++;
        }
    }
    
    function generate_text(string memory prompt, uint256 length) public view returns (string memory) {
        string[] memory promptTokens = tokenize_text(prompt);
        string[] memory tokens = new string[](length);
        tokens[0] = promptTokens[0];
        for (uint256 i = 1; i < promptTokens.length && i < length; i++) {
            tokens[i] = promptTokens[i];
        }
        for (uint256 i = promptTokens.length; i < length; i++) {
            string memory currentWord = tokens[i - 1];
            uint256 nextWordCount = wordCount[currentWord];
            if (nextWordCount == 0) {
                break;
            }
            uint256 rand = uint256(keccak256(abi.encodePacked(block.timestamp, i))) % nextWordCount;
            uint256 index = 0;
            for (uint256 j = 0; j < numWords; j++) {
                string memory word = words[j];
                uint256 count = model[currentWord][word];
                index += count;
                if (index > rand) {
                    tokens[i] = word;
                    break;
                }
            }
        }
        return join(tokens, " ");
    }


    function join(string[] memory arr, string memory delimiter) private pure returns (string memory) {
        string memory result = '';
        uint256 length = arr.length;
        for (uint256 i = 0; i < length; i++) {
            if (bytes(arr[i]).length == 0) {
                continue;
            }
            result = string(abi.encodePacked(result, arr[i]));
            if (i < length - 1) {
                result = string(abi.encodePacked(result, delimiter));
            }
        }
        return result;
    }
}
