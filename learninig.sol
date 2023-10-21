// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;


contract FundMe {
    address public owner;
    uint256 public goal;
    uint256 public balance;

    event Contribution(address indexed contributor, uint256 amount);

    constructor(uint256 _goal) {
        owner = msg.sender;
        goal = _goal;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function.");
        _;
    }

    function contribute() public payable {
        require(msg.value > 0, "Contribution must be greater than 0");
        balance += msg.value;
        emit Contribution(msg.sender, msg.value);
    }

    function withdrawFunds() public onlyOwner {
        require(address(this).balance >= goal, "Goal not reached; cannot withdraw funds.");
        payable(owner).transfer(address(this).balance);
        balance = 0;
    }
}
