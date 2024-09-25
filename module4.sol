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

    mapping(uint256 => Feature) public features;
    mapping(string => bool) private featureNames;
    mapping(address => mapping(uint256 => bool)) private userRedeemedFeatures;
    event FeatureRedeemed(address indexed user, uint256 featureId, string featureName);

    event FeatureUpdated(uint256 indexed featureId, string oldName, string newName, uint256 oldPrice, uint256 newPrice);

    constructor() ERC20("Degen", "DGN") Ownable(msg.sender) {
        _addFeature(1, "jetfly", 99);
        _addFeature(2, "jetrun", 299);
        _addFeature(3, "Jetswim", 499); // New Feature added
    }

    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }

    function _addFeature(uint256 featureId, string memory name, uint256 price) internal {
        require(bytes(features[featureId].name).length == 0, "Feature ID already exists");
        require(!featureNames[name], "Feature name already exists");

        features[featureId] = Feature(name, price);
        featureNames[name] = true;
    }

    function addFeature(uint256 featureId, string memory name, uint256 price) external onlyOwner {
        _addFeature(featureId, name, price);
    }

    function updateFeature(uint256 featureId, string memory newName, uint256 newPrice) external onlyOwner {
        Feature memory feature = features[featureId];
        require(bytes(feature.name).length != 0, "Feature does not exist");

        string memory oldName = feature.name;
        uint256 oldPrice = feature.price;

        require(!featureNames[newName], "New feature name already exists");

        features[featureId] = Feature(newName, newPrice);
        featureNames[newName] = true;
        featureNames[oldName] = false;

        emit FeatureUpdated(featureId, oldName, newName, oldPrice, newPrice);
    }

    function redeemFeature(uint256 featureId) external {
        Feature memory feature = features[featureId];
        require(bytes(feature.name).length != 0, "Feature does not exist");
        require(!userRedeemedFeatures[msg.sender][featureId], "Feature already redeemed");
        require(balanceOf(msg.sender) >= feature.price, "Insufficient balance to redeem");
        _burn(msg.sender, feature.price);
        userRedeemedFeatures[msg.sender][featureId] = true;

        emit FeatureRedeemed(msg.sender, featureId, feature.name);
    }
    function hasRedeemedFeature(address user, uint256 featureId) external view returns (bool) {
        return userRedeemedFeatures[user][featureId];
    }
    function getFeatureDetails(uint256 featureId) external view returns (string memory name, uint256 price) {
        Feature memory feature = features[featureId];
        require(bytes(feature.name).length != 0, "Feature does not exist");
        return (feature.name, feature.price);
    }
    function removeFeature(uint256 featureId) external onlyOwner {
        require(bytes(features[featureId].name).length != 0, "Feature does not exist");

        string memory featureName = features[featureId].name;
        delete featureNames[featureName];
        delete features[featureId];
    }
    function burn(uint256 amount) public override {
        _burn(msg.sender, amount);
    }
}
