// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EnergyTrading {
    struct User {
        address userAddress;
        uint256 energyProduced;
        uint256 energyConsumed;
        uint256 energyBalance;
    }

    mapping(address => User) public users;
    mapping(address => bool) public registeredUsers;

    event UserRegistered(address user);
    event EnergyProduced(address indexed user, uint256 amount);
    event EnergyConsumed(address indexed user, uint256 amount);
    event EnergyTraded(address indexed from, address indexed to, uint256 amount);

    modifier onlyRegistered() {
        require(registeredUsers[msg.sender], "User not registered");
        _;
    }

    function registerUser() public {
        require(!registeredUsers[msg.sender], "User already registered");
        users[msg.sender] = User(msg.sender, 0, 0, 0);
        registeredUsers[msg.sender] = true;
        emit UserRegistered(msg.sender);
    }

    function logEnergyProduced(uint256 amount) public onlyRegistered {
        users[msg.sender].energyProduced += amount;
        users[msg.sender].energyBalance += amount;
        emit EnergyProduced(msg.sender, amount);
    }

    function logEnergyConsumed(uint256 amount) public onlyRegistered {
        require(users[msg.sender].energyBalance >= amount, "Insufficient energy balance");
        users[msg.sender].energyConsumed += amount;
        users[msg.sender].energyBalance -= amount;
        emit EnergyConsumed(msg.sender, amount);
    }

    function tradeEnergy(address to, uint256 amount) public onlyRegistered {
        require(users[msg.sender].energyBalance >= amount, "Insufficient energy balance");
        require(registeredUsers[to], "Recipient not registered");

        users[msg.sender].energyBalance -= amount;
        users[to].energyBalance += amount;

        emit EnergyTraded(msg.sender, to, amount);
    }

    function getUserDetails(address user) public view returns (uint256, uint256, uint256) {
        User memory u = users[user];
        return (u.energyProduced, u.energyConsumed, u.energyBalance);
    }
}
