# BELLa — On-Chain Markov Text Generator (Solidity)

BELLa is an experimental smart contract that builds a minimal Markov-chain language model directly on the Ethereum Virtual Machine. It demonstrates how text tokenization, transitional probability tracking, and pseudo-random next-word generation can be implemented using Solidity alone—without reliance on off-chain computation or external data sources.

The contract maintains a mapping of word-to-word transitions, counts token frequencies, and supports simple text generation seeded from a user-provided prompt. Although not intended as a production-ready natural-language model, BELLa illustrates how deterministic state updates and probabilistic selection can be encoded within the constraints of the blockchain.

---

## Features

### Tokenization
- Splits an input string into space-delimited tokens.
- Implemented manually using `bytes(text)` to avoid external dependencies.
- Used by both the training and generation functions.

### Model Construction
- Each call to `add_text` updates:
  - `model[current][next]` — transition frequency between two consecutive words.
  - `wordCount[word]` — tracking unique words and update frequencies.
  - `words[]` — an array of unique tokens used for sampling.
  
### Text Generation
- Accepts a prompt and a target output length.
- Seeds generation with the prompt’s tokens when possible.
- Selects subsequent words using weighted random sampling based on observed transitions.
- Pseudo-randomness uses `keccak256` with `block.timestamp` and index as entropy.

### Utility
- `join()` concatenates string arrays into a single space-separated output.
- `create_model()` is a pure helper function identical to `tokenize_text`, kept for testing and extension.

---

## Usage

### Deploying
Deploy the contract using your preferred framework (Hardhat, Foundry, Truffle, Remix).

### Training the Model
```solidity
BELLa bella = new BELLa();
bella.add_text("the quick brown fox jumps over the lazy dog");
bella.add_text("the quick student builds solidity projects");
