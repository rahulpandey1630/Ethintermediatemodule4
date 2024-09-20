# Ethintermediatemodule4
# DegenToken

DegenToken is a decentralized ERC20 token with additional functionality for feature purchases and token burning. This smart contract leverages OpenZeppelin's libraries for secure and standardized implementations of ERC20, Ownable, and ERC20Burnable.

### Key Features

1. **Minting**:
   - Only the owner of the contract can mint new tokens.
   - The `mint` function allows the owner to create new tokens and assign them to a specified address.

2. **Burning**:
   - Any token holder can burn their tokens.
   - The `ERC20Burnable` extension from OpenZeppelin is utilized to enable this functionality.

3. **Feature Management**:
   - The contract allows the owner to define and manage purchasable features.
   - Features are represented as a struct containing a name and price.
   - A mapping is used to store available features with their unique IDs.

4. **Feature Redeem**:
   - Users can redeem features using their DegenTokens.
   - The `redeemFeature` function checks if the feature exists, if the user has already purchased it, and if the user has sufficient balance.
   - Upon successful purchase, tokens are transferred from the user to the contract, and the feature is marked as purchased for the user.
   - An event `FeatureRedeemed` is emitted upon successful purchase.

5. **Ownership**:
   - The contract uses OpenZeppelin's `Ownable` contract to restrict certain functions to the contract owner.
   - Functions like minting and adding new features can only be executed by the owner.

### Events

- **FeaturePurchased**:
  - Emitted when a user successfully purchases a feature.
  - Logs the user's address, the feature ID, and the feature name.

### Functions

- **constructor**: Initializes the token with the name "Degen" and the symbol "DGN".
- **mint**: Allows the contract owner to mint new tokens to a specified address.
- **addFeature**: Allows the contract owner to add a new feature with a specified ID, name, and price.
- **redeemFeature**: Allows users to purchase a feature using their tokens.
- **hasPurchasedFeature**: Checks if a user has purchased a specific feature.

### Mappings

- **features**:
  - Maps a unique feature ID to the `Entity` struct that represents the feature's details (name and price).
- **userFeatures**:
  - Nested mapping to track which features a user has purchased.
  - Maps a user's address to another mapping that associates feature IDs with a boolean indicating purchase status.
- **featureNames**:
  - For check uniqueness of feature's name.


### Security Considerations

- The contract ensures that only the owner can perform critical actions such as minting tokens and adding new features.
- Checks are in place to ensure that features exist and that users have sufficient balance before purchasing.
- The contract uses OpenZeppelin's libraries to leverage well-tested implementations and reduce the risk of vulnerabilities.

### Usage

- **Minting Tokens**: The owner can mint new tokens to any address.
- **Adding Features**: The owner can add new features with specific IDs, names, and prices.
- **Redeem Features**: Users can purchase features using their token balance.
- **Checking Purchases**: Anyone can check if a user has purchased a specific feature.

## Prerequisites

- Solidity ^0.8.9
- OpenZeppelin Contracts

### Dependencies

- The contract relies on the following OpenZeppelin libraries:
  - `@openzeppelin/contracts/token/ERC20/ERC20.sol`
  - `@openzeppelin/contracts/access/Ownable.sol`
  - `@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol`

### Conclusion

The `DegenToken` contract provides a robust foundation for a decentralized token with advanced functionalities. By incorporating secure and standardized components from OpenZeppelin, it ensures reliability and security while offering versatile features for token minting, burning, and feature purchases.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.




