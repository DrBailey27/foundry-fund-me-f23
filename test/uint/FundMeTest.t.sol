//always write a test

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
/*this*/import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
 
contract FundMeTest is Test {
    FundMe fundme;
    //this is the fake address
    address USER = makeAddr("user");
    uint256 constant SEND_VALUE = 0.1 ether;//10000000000000000
    //we wrote the balance we want here
    uint256 constant STARTING_BALANCE = 10 ether;
    uint256 constant GAS_PRICE = 1;

    //uint256 number = 1;
    function setUp() external {
        // we are calling the FundMetest which then deploys FundMe,msg.Sender is whoever that is calling the FundMe
       // number = 2;
       //a new fundme contract was made here
      /*this*fundme = new FundMe( 0x694AA1769357215DE4FAC081bf1f309aDC325306);
    //   if you try to run it without a fork chain it would fail,the above only works for sepolia
    //   so we create a mock contract y creating a new file inside your script folder called HelperConfig.s.sol
    // 
       /*this*/  DeployFundMe deployfundme = new DeployFundMe();
        //a new deployfundme contract was made here
        /*this*/ fundme = deployfundme.run();
        // "run" in the above line is going to return a fundme contract
        // The cheat code "deal allows you set the balance of an address to a new balance(fake eth)
        vm.deal(USER, STARTING_BALANCE);


    }
    


    function testMinimumDollarIsFive() public {
        assertEq(fundme.MINIMUM_USD(), 5e18);
        //if you write a wrong number above,it would give an error message
        
       // console.log(number);
        //console.log("Hi Baygirl!");
        //assertEq(number, 2);
    }
     
     function testOwnerIsMsgSender() public{
        assertEq(fundme.getOwner(), msg.sender);
        //console.log(fundme.i_owner());
        //console.log(msg.sender);
        //assertEq(fundme.i_owner(), msg.sender);
        //then run forge test --vv,to see if the two addresses are the same
        //we have two different addresses because in our set up function the "FundMeTest" is  the contract that deployed our "fundme" address and will be the owner
        // the second asddress is :mg.Sender is whoever that is calling the "FundMeTest"
        // us is calling "FundMeTest" which then deployes "fundme",hence we are msg.sender
        //so the owner of the contract is "FundMeTest",we just called it ,its the "FundMeTest" that deployed it ,so its the owner of the contract
        //youre meant to check if msg.sender is the owner :
        //function testOwnerIsMsgSender() public{
       // console.log(fundme.i_owner());
        //console.log(msg.sender);
        //assertEq(fundme.i_owner(), msg.sender);
        //instead check if "FundMeTest" is the owner:assertEq(fundme.i_owner(), address(this));
     }
    // Unittest(we are testing getVersion)
     function testpriceFeedversionIsAccurate() public{
       uint256 version = fundme.getVersion();
       assertEq(version, 4);
     }

     // we tested if the fund fails if there isnt enough ETH
     function testFundFailsWithoutEnoughETH() public {
      vm.expectRevert();//this says that the next line should revert
      fundme.fund();//put your values inside the () bracket,the bracket is empty now so its automatically 0
      //and you need at least $5 so the "vm.expectRevert();" will revert it cause there isnt enough ETH
     }

     function testFundUpdatesFundedDataStructure() public{
      // we create a fake new address to send all of our transactions,create a fake user at the top
      vm.prank(USER);//this says that the next text which in this case is fundme.fund, will be sent by the USER
      fundme.fund{value: SEND_VALUE}();
      //PRANK sets msg.sender to the specified address for the next call,it works only in foundry and our test 
      uint256 amountFunded = fundme.getAddressToAmountFunded(USER);
      assertEq(amountFunded, SEND_VALUE);
     }

     function testAddsFunderToArrayOfFunders() public{
      vm.prank(USER);
      fundme.fund{value: SEND_VALUE}();
      
      address funder = fundme.getFunder(0);//the index is 0
      assertEq(funder, USER);//assertEq here is saying check if the funder is equal to the USER

     }
     //any test code we write after this modifier we can add the funded in front of the public visibility and save ourselves some code
     // instead of writting it multiple times in our code(everything under function testOnlyOwnerCanWithdraw() including the commented ones),when we want to fund our test contract we can just do this 
     modifier funded(){
      vm.prank(USER);
      fundme.fund{value: SEND_VALUE}();
      _;
     }

     //we want to test to make sure that its only the ownwer that withdrawl 
     function testOnlyOwnerCanWithdraw() public funded{
      //first of you fund it
      vm.prank(USER);
      //fundme.fund{value: SEND_VALUE}();
     
     //in this line we are saying that that it should revert if it isnt the owner,we revert the next line that isnt a vm cheat code
      vm.expectRevert();
      //vm.prank(USER);
      // we'll try to make the user withdraw but the user isnt the owner
      fundme.withdraw();

     }

     //we are testing to see if the withdraw button is working
     function testWithdrawWithASingleFunder() public funded{
      //when you are working with a test think of it mentally with this pattern
      //Arrange
        //first of arrange the test or set up the test
        //to test that the withdraw function is going to work ,check the balance before you call withdwraw so you can compare it to what our balance is after
        uint256 startingOwnerBalance = fundme.getOwner().balance;
        uint256 startingFundMeBalance = address(fundme).balance;

      //Act
       //do he action you want to test
       //only the owner can call withdraw
       //we have to calculate the gas left in this function brfore and after, to know the actual gas it is going to spend
       //to do this we type the line below,"gasleft();" is a built in solidity function that tells you how much gas is left in your transaction call
       //uint256 gasStart = gasleft();
       //vm.txGasPrice(GAS_PRICE);
       vm.prank(fundme.getOwner());
       fundme.withdraw();

      // uint256 gasEnd = gasleft();
      // uint256 gasUsed = (gasStart - gasEnd) * tx.gasprice;
       //gas price is a built in solidity function that tells you the current gas price
       //console.log(gasUsed);

      //Assert
       //assert the test
       uint256 endingOwnerBalance = fundme.getOwner().balance;
       uint256 endingFundMeBalance = address(fundme).balance;
       assertEq(endingFundMeBalance, 0);
       //startingFundMeBalance + startingOwnerBalance should equal the endingOwnerBalance
       assertEq(
        startingFundMeBalance + startingOwnerBalance , endingOwnerBalance
        );

     }

     //A test wih multiple senders
     function testWithdrawFromMultipleFunders() public funded{
      //Arrange
      uint160 numberOfFunders = 10;
      uint160 startingFundersIndex = 1;
      for(uint160 i = startingFundersIndex; i < numberOfFunders; i++){
        //vm.prank new address
        //vm.deal new addres
        //hoax is a cheat that allows you to set up a prank from an address that has some ether
        //it does both prank and deal combined
        //we can do address(0) to formulate some address or address(1),or address(2) and so on,but they most have a uint160
        //to use numbers to generate addresses,its better uuse address(1)
        //we created a blank address of i (address(i)) which starts at 1
        hoax(address(i), SEND_VALUE);
        fundme.fund{value: SEND_VALUE}();
        //fund the fundme

      }

      uint256 startingOwnerBlance = fundme.getOwner().balance;
      uint256 startingFundMeBalance = address(fundme).balance;
    
    //Act
  
      vm.startPrank(fundme.getOwner());
      fundme.withdraw();
      vm.stopPrank();
      //the start and stop broadcast is saying that anything in between is going to be sent from the address(fundme.getOwner())
     
     //Assert
     assert(address(fundme).balance ==0);
     //the address is the fundme
     assert(startingFundMeBalance + startingOwnerBlance == fundme.getOwner().balance);

     }
   

     //A test wih multiple senders
     function testWithdrawFromMultipleFundersCheaper() public funded{
      //Arrange
      uint160 numberOfFunders = 10;
      uint160 startingFundersIndex = 1;
      for(uint160 i = startingFundersIndex; i < numberOfFunders; i++){
        //vm.prank new address
        //vm.deal new addres
        //hoax is a cheat that allows you to set up a prank from an address that has some ether
        //it does both prank and deal combined
        //we can do address(0) to formulate some address or address(1),or address(2) and so on,but they most have a uint160
        //to use numbers to generate addresses,its better uuse address(1)
        //we created a blank address of i (address(i)) which starts at 1
        hoax(address(i), SEND_VALUE);
        fundme.fund{value: SEND_VALUE}();
        //fund the fundme

      }

      uint256 startingOwnerBlance = fundme.getOwner().balance;
      uint256 startingFundMeBalance = address(fundme).balance;
    
    //Act
  
      vm.startPrank(fundme.getOwner());
      fundme.CheaperWithdraw();
      vm.stopPrank();
      //the start and stop broadcast is saying that anything in between is going to be sent from the address(fundme.getOwner())
     
     //Assert
     assert(address(fundme).balance ==0);
     //the address is the fundme
     assert(startingFundMeBalance + startingOwnerBlance == fundme.getOwner().balance);

     }


}






//set up runs first then testdemo
//the "test" function gives us access to this "assertEq" function
//Types of tests
// What can we do to work with addresses outside our system?
// 1. Unit-tests a single function
//   -Testing a specific part of our code
// 2. Integration-testing multiple different contracts working together
//   -Testing how our code works with other parts of our code
// 3. Forked-testing our code in a simulated real enviroment
//  -Testing our code on a simulated real enviroment
// 4. Staging-deploying our code to a testnet or mainnet,and run all our tests in a real enviroment to make sure it actually works
//  -Testing our code in a real enviroment that is not prod



// forge test testpriceFeedversionIsAccurate -vvv --fork-url $SEPOLIA_RPC_URL
// forge test --mt testpriceFeedversionIsAccurate -vvv --fork-url $SEPOLIA_RPC_URL
// forge test -m testPriceFeedVersionIsAccurate -vvv --fork-url $SEPOLIA_RPC_URL
// forge test testPriceFeedVersionIsAccurate -vvv --fork-url $SEPOLIA_RPC_URL
// forge test -f <test-file-name> --test testpriceFeedVersionIsAccurate -vvv --fork-url $SEPOLIA_RPC_URL
//if we deploy our contract without hard coded addresses we would make our code more modular and deploy chains more easy no matter what chain you are working on eg sepolia
// in your FundMe.sol ,PriceConverter.sol, DeployFundMe.s.sol contract look for where i commented "this",so that the priceFeed would depend on the chain link you are on,deploy it with the address you want to use
// if you dont want to go throught that stress of changing somethings in each contract,just call out to the deploy function in your "DeployFundMe" contract
//first of:
// in our FundMetest.t.sol type :import {DeployFundMe} from "../script/DeployFundMe.s.sol";
// --mt is how we run a single test
//forge coverage: this is used to test on the terminal how much of your code was executed
//we changed i_owner to get_Owner
 //we can do address(0) to formulate some address or address(1),or address(2) and so on,but they most have a uint160
        //to use numbers to generate addresses
 //chisel
 // forge snapshot --mt testWithdraFromMultipleFunders:this will create a file called .gas-snapshot,it will tell you how much gas that transaction took
 //the gas price on a local chain defaults to 0
 //to simulate the transaction with actual gas price we must tell our test to pretend to use real gas price using this cheat code below
 //txGasPrice; this sets the gas price for the rest of the transaction
 //the aasert function is used to check if a==b(if a is equal to b)
 //constant and immutable function doest take space in the storage
 //variables are not added to storage but in their own memory
 //forge inspect FundMe storageLayout;run this on your terminal to check what functions are stored in storage 
 //read and write from memory not storage,it costa less gas
 //




















