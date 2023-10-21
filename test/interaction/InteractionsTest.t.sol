//always write a test

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
/*this*/import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundFundMe, WithdrawFundMe} from "../../script/Interactions.s.sol";

 
contract InteractionsTest is Test {
    FundMe fundme;
    //this is the fake address
    address USER = makeAddr("user");
    uint256 constant SEND_VALUE = 0.1 ether;//10000000000000000
    //we wrote the balance we want here
    uint256 constant STARTING_BALANCE = 10 ether;
    uint256 constant GAS_PRICE = 1;

    function setUp() external {
        DeployFundMe deploy = new DeployFundMe();
        fundme = deploy.run();
        // "run" in the above line is going to return a fundme contract
        // The cheat code "deal allows you set the balance of an address to a new balance(fake eth)
        vm.deal(USER, STARTING_BALANCE);
    }

   /* function testUserCanFundInteractions() public {
        FundFundMe fundFundMe = new FundFundMe();
        vm.prank(USER);
        vm.deal(USER, 1e18);
        fundFundMe.fundFundMe(address(fundme));

        WithdrawFundMe withdrawFundMe = new WithdrawFundMe();
        withdrawFundMe.withdrawFundMe(address(fundme));

        assert(address(fundme).balance == 0);

       
    }*/

      function testUserCanFundInteractions() public {
        FundFundMe fundFundMe = new FundFundMe();
        fundFundMe.fundFundMe(address(fundme));

        WithdrawFundMe withdrawFundMe = new WithdrawFundMe();
        withdrawFundMe.withdrawFundMe(address(fundme));

        assert(address(fundme).balance == 0);
        
    }

    
    
    
}