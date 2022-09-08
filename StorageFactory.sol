// SPDX-License_identifier: UNILCENSED

pragma solidity ^0.6.0;

//Imports the simple storage contract
import "./SimpleStorage.sol";

//Initializes the contract
//Storagefactory inherits all the functions from the SimpleStorage contract
contract StorageFactory is SimpleStorage{
    
    //Creates a public simple storage array
    SimpleStorage[] public simpleStorageArray;

    //Function which creates new SimpleStorage contracts and add them to the array
    function createSimpleStorageContract() public {
        SimpleStorage simpleStorage = new SimpleStorage();
        simpleStorageArray.push(simpleStorage);
    }

    //Calls the store function in the SimpleStorage contract
    //You choose which which contract with the indexnumber for the SimpleStorageArray
    function sfStore(uint256 _simpleStorageIndex, uint256 _simpleStorageNumber) public {
        SimpleStorage(address(simpleStorageArray[_simpleStorageIndex])).store(_simpleStorageNumber);
    }

    //Calls the retrieve function in the SimpleStorage contract
    //Retrieves the number through the address saved in the SimpleStorage array
    function sfGet(uint256 _simpleStorageIndex) public view returns (uint256) {
        return SimpleStorage(address(simpleStorageArray[_simpleStorageIndex])).retrieve();
    }
}
