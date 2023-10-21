// .s when naming our file is to show that it is a script
//when using a script we import script
//to run a script type:function run()
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployFundMe is Script {
    /*this*/function run() external returns (FundMe) {

    // this is before the vm.startbroadcast beacsue it wont send it as a real transaction but it would simoulate it in a simulated enviroment
        HelperConfig helperconfig = new HelperConfig();
        address ethUsdPriceFeed = helperconfig.activeNetworkConfig();


         //After startbroadcast it sends as a real transaction 
        vm.startBroadcast();
         /*this*/ FundMe fundme = new FundMe(ethUsdPriceFeed );
        vm.stopBroadcast();
        /*this*/return fundme;
    }

}