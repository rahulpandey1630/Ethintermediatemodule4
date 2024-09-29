// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract DegenToken is ERC20, Ownable, ERC20Burnable {
    // Struct to define features
    struct Feature {
        string name;
        uint256 price;
    }

    // Mapping to store available features with their details
    mapping(uint256 => Feature) public features;
    // Mapping to ensure uniqueness of feature names
    mapping(string => bool) private featureNames;
    // Mapping to track redeemed features by users
    mapping(address => mapping(uint256 => bool)) private userRedeemedFeatures;
    // Array to keep track of feature IDs
    uint256[] private featureIds;

    // Event emitted when a feature is redeemed
    event FeatureRedeemed(address indexed user, uint256 featureId, string featureName);

    // Event emitted when a feature is updated
    event FeatureUpdated(uint256 indexed featureId, string oldName, string newName, uint256 oldPrice, uint256 newPrice);

    // Constructor initializing the token and predefined features
    constructor() ERC20("Degen", "DGN") Ownable(msg.sender) {
        _addFeature(1, "jetfly", 99);
        _addFeature(2, "jetrun", 299);
        _addFeature(3, "Jetswim", 499); 
    }

    // Function to mint tokens, restricted to the contract owner
    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }

    // Internal function to add a new feature to the contract
    function _addFeature(uint256 featureId, string memory name, uint256 price) internal {
        require(bytes(features[featureId].name).length == 0, "Feature ID already exists");
        require(!featureNames[name], "Feature name already exists");

        features[featureId] = Feature(name, price);
        featureNames[name] = true;
        featureIds.push(featureId);  // Track feature ID
    }

    // Public function to add features; only the owner can call this
    function addFeature(uint256 featureId, string memory name, uint256 price) external onlyOwner {
        _addFeature(featureId, name, price);
    }

    // Public function to update an existing feature
    function updateFeature(uint256 featureId, string memory newName, uint256 newPrice) external onlyOwner {
        Feature memory feature = features[featureId];
        require(bytes(feature.name).length != 0, "Feature does not exist");

        string memory oldName = feature.name;
        uint256 oldPrice = feature.price;

        require(!featureNames[newName], "New feature name already exists");

        // Update feature details
        features[featureId] = Feature(newName, newPrice);
        featureNames[newName] = true;
        featureNames[oldName] = false;

        emit FeatureUpdated(featureId, oldName, newName, oldPrice, newPrice);
    }

    // Function to redeem a feature; burns tokens equivalent to the feature's price
    function redeemFeature(uint256 featureId) external {
        Feature memory feature = features[featureId];
        require(bytes(feature.name).length != 0, "Feature does not exist");
        require(!userRedeemedFeatures[msg.sender][featureId], "Feature already redeemed");
        require(balanceOf(msg.sender) >= feature.price, "Insufficient balance to redeem");
        _burn(msg.sender, feature.price);
        userRedeemedFeatures[msg.sender][featureId] = true;

        emit FeatureRedeemed(msg.sender, featureId, feature.name);
    }

    // Public function to check if a feature has been redeemed by a user
    function hasRedeemedFeature(address user, uint256 featureId) external view returns (bool) {
        return userRedeemedFeatures[user][featureId];
    }

    // Function to get feature details
    function getFeatureDetails(uint256 featureId) external view returns (string memory name, uint256 price) {
        Feature memory feature = features[featureId];
        require(bytes(feature.name).length != 0, "Feature does not exist");
        return (feature.name, feature.price);
    }

    // Function to remove a feature, restricted to the owner
    function removeFeature(uint256 featureId) external onlyOwner {
        require(bytes(features[featureId].name).length != 0, "Feature does not exist");

        string memory featureName = features[featureId].name;
        delete featureNames[featureName];
        delete features[featureId];

        // Remove the feature ID from the featureIds array
        for (uint256 i = 0; i < featureIds.length; i++) {
            if (featureIds[i] == featureId) {
                featureIds[i] = featureIds[featureIds.length - 1];
                featureIds.pop();
                break;
            }
        }
    }

    // New function to return available features for purchase
    function getAvailableFeatures() external view returns (Feature[] memory) {
        Feature[] memory availableFeatures = new Feature[](featureIds.length);
        for (uint256 i = 0; i < featureIds.length; i++) {
            availableFeatures[i] = features[featureIds[i]];
        }
        return availableFeatures;
    }

    // Overriding the burn function to ensure correct sender address
    function burn(uint256 amount) public override {
        _burn(msg.sender, amount);
    }

    // New function to get the balance of a specific address
    function getBalance(address account) external view returns (uint256) {
        return balanceOf(account);
    }
}
