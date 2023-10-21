//fund
//withdraw

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../src/FundMe.sol";


//we are funding the FundMe contract
contract FundFundMe is Script{
    uint256 constant SEND_VALUE = 0.01 ether;

    function fundFundMe(address mostRecentlyDeployed) public{
        vm.startBroadcast();
        FundMe(payable(mostRecentlyDeployed)).fund{value: SEND_VALUE}();
        console.log("Funded FundMe with ", SEND_VALUE);
        vm.stopBroadcast();
    }
    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment(
        "FundMe", 
        block.chainid
        );  
        //vm.startBroadcast();
        //we will have our run call our fundFundMe function
        fundFundMe(mostRecentlyDeployed);
        //  vm.stopBroadcast();

    }  

}
contract WithdrawFundMe is Script{
        function withdrawFundMe(address mostRecentlyDeployed) public{
            vm.startBroadcast();
            FundMe(payable(mostRecentlyDeployed)).withdraw();
            vm.stopBroadcast();
       
        
    }
    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment(
        "FundMe", 
        block.chainid
        );  
       //vm.startBroadcast();
        //we will have our run call our fundFundMe function
        withdrawFundMe(mostRecentlyDeployed);
       // vm.stopBroadcast();

    } 
    
    
}