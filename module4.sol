// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract DegenToken is ERC20, Ownable, ERC20Burnable 
{

    constructor() ERC20("Degen", "DGN") Ownable(msg.sender) 
    {
        // Initialize with a list of features
        addFeature(1, "Rocket", 250);
        addFeature(2, "HoverBoard", 180);
        addFeature(3, "MachineGun", 220);
    }

    function mint(address to, uint256 amount) public onlyOwner 
    {
        _mint(to, amount);
    }

    struct Entity 
    {
        string name;
        uint256 price;
    }

    // Mapping to store available features
    mapping(uint256 => Entity) public features;

    // Mapping to store feature names to ensure uniqueness
    mapping(string => bool) public featureNames;

    // Mapping to keep track of which features a user has redeemed
    mapping(address => mapping(uint256 => bool)) public userFeatures;

    // Event to log feature redemptions
    event FeatureRedeemed(address indexed user, uint256 featureId, string featureName);

    // Add a new feature
    function addFeature(uint256 featureId, string memory name, uint256 price) public onlyOwner 
    {
        require(bytes(features[featureId].name).length == 0, "Feature ID already exists");
        require(!featureNames[name], "Feature name already exists");

        features[featureId] = Entity(name, price);
        featureNames[name] = true;
    }

    // Redeem a feature
    function redeemFeature(uint256 featureId) public 
    {
        Entity memory feature = features[featureId];
        require(bytes(feature.name).length != 0, "Feature does not exist");
        require(!userFeatures[msg.sender][featureId], "Feature already redeemed");
        require(balanceOf(msg.sender) >= feature.price, "Insufficient balance");

        // Burn tokens from the user
        burn(feature.price);

        // Mark the feature as redeemed by the user
        userFeatures[msg.sender][featureId] = true;

        // Emit the event
        emit FeatureRedeemed(msg.sender, featureId, feature.name);
    }

    // Explicitly added the burn function
    function burn(uint256 amount) public override {
        _burn(_msgSender(), amount);
    }

    // Check if a user has redeemed a feature
    function hasRedeemedFeature(address user, uint256 featureId) public view returns (bool) 
    {
        return userFeatures[user][featureId];
    }
}

