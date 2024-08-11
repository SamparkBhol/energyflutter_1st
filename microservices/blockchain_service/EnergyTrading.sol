// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EnergyTrading {
    struct Trade {
        address payable seller;
        address payable buyer;
        uint256 amount; // in kWh
        uint256 price;  // in Wei per kWh
        bool completed;
    }

    mapping(uint256 => Trade) public trades;
    uint256 public tradeCount;

    event TradeCreated(uint256 tradeId, address indexed seller, uint256 amount, uint256 price);
    event TradeCompleted(uint256 tradeId, address indexed buyer);

    function createTrade(uint256 amount, uint256 price) public {
        tradeCount++;
        trades[tradeCount] = Trade({
            seller: payable(msg.sender),
            buyer: payable(address(0)),
            amount: amount,
            price: price,
            completed: false
        });

        emit TradeCreated(tradeCount, msg.sender, amount, price);
    }

    function completeTrade(uint256 tradeId) public payable {
        Trade storage trade = trades[tradeId];
        require(!trade.completed, "Trade already completed");
        require(msg.value == trade.amount * trade.price, "Incorrect value sent");

        trade.buyer = payable(msg.sender);
        trade.seller.transfer(msg.value);
        trade.completed = true;

        emit TradeCompleted(tradeId, msg.sender);
    }

    function getTrade(uint256 tradeId) public view returns (Trade memory) {
        return trades[tradeId];
    }
}
