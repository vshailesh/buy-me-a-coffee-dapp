// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract BuyMeACoffee {

    //Event to emit when a Memo is created.
    event NewMemo(
        address senderAddress,
        string name,
        string message,
        uint256 timestamp
    );

    //Event to emit when the withdrwal (owner) address is changed
    event WithdrawalAddressChanged (
        address oldWithdrawalAdress,
        address newWithdrawalAddress
    );

    // Memo struct
    struct Memo {
        address senderAddress;
        string name;
        string message;
        uint256 timestamp;
    }
    
    //address of the contract deployer. Marked payable so that
    // we can withdraw to this address later.
    address owner;
    address payable withdrawalAddress;

    // List of all memos received from coffee purchase.
    Memo[] memos;

    constructor () {
        // Store the address of the deployer as a payable address.
        // When we withdraw funds, we'll withdraw here.
        owner = msg.sender;
        withdrawalAddress = payable(owner);
    }

    /**
    * @param _newWithdrawalAddress is the new address for owner/withdrawal account.
     */
    function setWithdrawalAddress(address _newWithdrawalAddress) private {
        owner = payable(_newWithdrawalAddress);
    }

    /**
    * @dev fetches all stored memos
    */
    function getMemos () public view returns (Memo[] memory){
        return memos;
    }

    /**
    * @dev buy a coffee for the owner (sends an ETH tip and leaves a memo)
    * @param _name name of the coffee purchaser
    * @param _message from the from the purchaser 
    */
    function buyCoffee(string memory _name, string memory _message) public payable{
        require(msg.value > 0, "can't buy coffee for free!");
        
        memos.push(Memo(
            msg.sender,
            _name,
            _message,
            block.timestamp
        ));

        //Emit a New Memo event with details about the memo
        emit NewMemo(
            msg.sender,
            _name,
            _message,
            block.timestamp
        );

    }  


    
    function withdrawTips() public{
        // (bool sent, bytes memory data) = owner.call{value: msg.value}("");
        require(withdrawalAddress.send(address(this).balance));
    }

    function updateWithdrawalAddress(address newWithdrawalWalletAddress, address changeRequestingWalletAddress) public {
        require(owner == changeRequestingWalletAddress, "Only current Owner can request Address Change");
        setWithdrawalAddress(newWithdrawalWalletAddress);
        emit WithdrawalAddressChanged(changeRequestingWalletAddress, newWithdrawalWalletAddress);
    }
}
