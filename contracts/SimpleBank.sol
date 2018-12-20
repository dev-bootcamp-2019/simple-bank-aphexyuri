pragma solidity ^0.5.0;
contract SimpleBank {

    //
    // State variables
    //
    
    // private mapping of user's account balances
    mapping (address => uint) private balances;
    
    // mapping of users' enrollment status 
    mapping (address => bool) public enrolled;

    // owner of the contract
    address public owner;
    
    //
    // Events - publicize actions to external listeners
    //
    
    // event for enrolment notifications
    event LogEnrolled(address accountAddress);

    // event for deposit notifications
    event LogDepositMade(address accountAddress, uint amount);

    // event for withdrawl notifications
    event LogWithdrawal(address accountAddress, uint withdrawAmount, uint newBalance);


    //
    // Functions
    //

    constructor() public {
        owner = msg.sender;
    }

    /// @notice Get balance
    /// @return The balance of the user
    function balance() public view returns (uint) {
        return balances[msg.sender];
    }

    /// @notice Enroll a customer with the bank
    /// @return The users enrolled status
    function enroll() public returns (bool){
        // mark user as enrolled
        enrolled[msg.sender] = true;

        // emit event
        emit LogEnrolled(msg.sender);

        // return entrolment status
        return enrolled[msg.sender];
    }

    /// @notice Deposit ether into bank
    /// @return The balance of the user after the deposit is made
    function deposit() public payable returns (uint) {
        // increment user's balance with amount sent with transaction
        balances[msg.sender] += msg.value;

        //emit event
        emit LogDepositMade(msg.sender, msg.value);

        // return user's new balance
        return balances[msg.sender];
    }

    /// @notice Withdraw ether from bank
    /// @dev This does not return any excess ether sent to it
    /// @param withdrawAmount amount you want to withdraw
    /// @return The balance remaining for the user
    function withdraw(uint withdrawAmount) public returns (uint) {
        // ensure user has sufficient balance for the withdrawl
        require(balances[msg.sender] >= withdrawAmount);

        // transfer funds back to user
        msg.sender.transfer(withdrawAmount);

        // decrement user's balance with withdrawl amount
        balances[msg.sender] -= withdrawAmount;
        
        // emit event
        emit LogWithdrawal(msg.sender, withdrawAmount, balances[msg.sender]);

        // return user's new balance
        return balances[msg.sender];
    }

    // Fallback function - Called if other functions don't match call or
    // sent ether without data
    // Typically, called when invalid data is sent
    // Added so ether sent to this contract is reverted if the contract fails
    // otherwise, the sender's money is transferred to contract
    function() external {
        revert();
    }
}
