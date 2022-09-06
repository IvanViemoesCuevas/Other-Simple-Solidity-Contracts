//SPDX-License-Identifier: MIT

//sets the solidity version
pragma solidity >=0.6.6 <0.9.0;

//imports chainlink v3 aggregator interface, to have a reliable decentralized exchange rate
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

//imports the openzeppelin safeMath library
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract FundMe {
    //Needs to be used in anything less then 0.8.0
    using SafeMath for uint256;

    //Creates a mapping which keeps track of the amount funded from the address'
    mapping(address => uint256) public addressToAmountFunded;

    //Creates an empty array of type address, to keep track of the wallets who funded
    address[] public funders;

    //creates the Owner variable
    address public owner;

    //executes when contract is deployed, and puts the deployers address as the owner
    constructor() public {
        owner = msg.sender;
    }

    //makes the fund function which is payable
    function fund() public payable {

        //sets a minimum of 50$ to be funded
        uint256 minimumUSD = 50 * 10**9;

        //requires the minimumUSD is fulfilled, otherwise break with error
        require(getConversionRate(msg.value) >= minimumUSD, "Not Enough Money");

        //pushes the amount funded into the mapping, with the "title" as the address who funded
        addressToAmountFunded[msg.sender] += msg.value;

        //pushes the funders address into the array
        funders.push(msg.sender);
    }

    //Function to get the AggregatorV3Interface version
    function getVersion() public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        return priceFeed.version();
    }

    //function to get the ETH/USD conversion price
    function getPrice() public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);

        //returns 5 variables, but we're only interested in the "answer" variable, since it contains the conversion rate
        (,int256 answer,,,) = priceFeed.latestRoundData();

        //returns the answer, but forces it to be a uint256
        return uint256(answer);
    }

    //Funcion that converts input ETH into USD
    function getConversionRate(uint256 ethAmount) public view returns (uint256) {
        //calls the getPrice funtion, to get the conversion rate
        uint256 ethPrice = getPrice();

        //multiplies the conversion rate with the input ETH, and divides it by 1.000.000.000 to make the output in gwei
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 100000000;

        //returns the ETH amount converted to USD
        return ethAmountInUsd;
    }

    //Creates a modifier that's normally used in function. Here it's to require that only the Owner can call a specific funtion
    modifier onlyOwner {
        //requires the TX executer to be the Owner of the contract
        require(owner == msg.sender);
        //makes the function execute the code in the specified function after it tested the require statement
        _;
        //^^ this can also be before the require to execute code before require statement
        //(would be dumb here since we only want to owner calling the , and therefore need to check it first)
    }

    //Creates a withdraw function, using the modifier so only the owner can call this function succesfully
    function withdraw() payable onlyOwner public {
        //Makes the message sender a payable address, and transfers the balance of this contract to the owner
        payable(msg.sender).transfer(address(this).balance);

        //Creates a for loop that continues as long as the number is smaller than the funders array length.
        //adds 1 per loop, to the funderIndex
        for (uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++){

            //saves the address from the array in an address variable for itself, so it can be called by the mapping
            address funder = funders[funderIndex];

            //saves the amount funded from the address' as 0
            addressToAmountFunded[funder] = 0;
        }

        //makes a new empty array of address, and deletes the old one
        funders = new address[](0);
    }
}