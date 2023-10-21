// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

// we are going to deploy mocks when we are on a local anvil chain
// we are going to keep track of contract addresses across different chains
// eg  Sepolia ETH/USD pricefeed has a different address
// Mainet ETH/USD pricefeed has a different address

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/Mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {
// this says if we are on a local anvil chain ,we deploy mocks
//  otherwise let us grab the existing addresses from the live network

// create a new public variable,then set the activeNetworkConfig to whichever configs that is the active network that we are one eg "getSepoliaEthConfig" for  sepolia or "getAnvilEthConfig" for anvil
// then we will have our DeployFundMe contracrt point to whatever "activeNetworkConfig" is 
   NetworkConfig public activeNetworkConfig;

   //turn the magic numbers down (8, 2000e8)into a constant variable
   //Decimals are in uint8
   uint8 public constant DECIMALS = 8;
   int256 public constant INITIAL_PRICE = 2000E8;


//turn the Config into its own type,we create types withe "struct" keyword
   struct NetworkConfig{
    address pricefeed; //which is going to be the ETH/USD pricefeed address
   }

// this says that if the block chainid is 11155111(sepolia chainid) then the activeNetworkConfig should refer to the getSepoliaEthConfig
// if it is not sepolia then the activeNetworkConfig should refer to the getAnvilConfig
   constructor() {
    if(block.chainid ==11155111){
        activeNetworkConfig = getSepoliaEthConfig();
    } else if(block.chainid ==1){
        activeNetworkConfig = getMainnetEthConfig();
    }else {
        activeNetworkConfig = getorCreateAnvilEthConfig();
    }
   }

//   this is used to grab an existing address from a live network
   function getMainnetEthConfig() public pure returns (NetworkConfig memory) {
    // all we need in sepolia is the pricefeed address
     NetworkConfig memory ethConfig = NetworkConfig({
        pricefeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
        });
         return ethConfig;
    
   }
    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
         NetworkConfig memory sepoliaconfig = NetworkConfig({
        pricefeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
         return sepoliaconfig;

    }

    function getorCreateAnvilEthConfig() public returns (NetworkConfig memory) {
        if (activeNetworkConfig.pricefeed != address(0))
        return activeNetworkConfig;
       
    // we changed getAnvilEthConfig() to getorCreateAnvilEthConfig()
        //if the address isnt 0 then it means you have set it
        //the code above says that if the activeNetworkConfig.pricefeed is not equal to the default address (address(0),then  return activeNetworkConfig; and dont run the rest of the code under
        // if we dont put the two lines that are above below the getAnvilConfig and deploy it,it would create a new pricefeed
        //address(0)is the default address or value
        // all we need in sepolia is the pricefeed address
        //First we have to deploy the mocks
        //return the mock address
        //a mock contract is like a fake or dummy contract that we own and we can control,its still a real contract
        vm.startBroadcast();
        //we are going to deploy our own pricefeed 
        //first we need to create a pricefeed contract, in our test file we will create a new folder called mocks where we will put all our contracts where we need to do testing
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(
            DECIMALS,
            INITIAL_PRICE
            );
        vm.stopBroadcast();

        NetworkConfig memory anvilConfig = NetworkConfig({
            pricefeed: address(mockPriceFeed)
            });
            return anvilConfig;
        
    }
  
}



  //we ususally dont deploy on ethereum mainnet instead we use polygon zkEVM,Arbitrium
  //now you can run your contract on any nework you want 
        
   