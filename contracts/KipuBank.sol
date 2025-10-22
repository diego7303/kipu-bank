// SPDX-License-Identifier: MIT
pragma solidity >0.8.20;

/**
 * @title KipuBank Contract
 * @notice This contract is for educational purposes only.
 * @author Diego Acosta | https://github.com/diego7303
 * @dev This contract includes a global deposit limit (bankCap) and per-transaction withdrawal limits (maxWithdrawalPerTx).
 *      It is intended for learning purposes only and should not be used in production. Custom errors are used,
 *      following the checks-effects-interactions pattern, and private functions are used to encapsulate logic.
 * @custom:security Do not use in production.
 */

contract KipuBank {

 	/*///////////////////////
					Variables
	///////////////////////*/   

    //@notice Immutable variable that sets a global deposit limit (bankCap), defined at deployment.
    uint256 public immutable bankCap;

    //@notice Users can withdraw funds from their vault, but only up to a fixed threshold per transaction.
    uint256 public immutable maxWithdrawalPerTx = 100000000000000000 wei; // 0.10 ETH in wei    

    //@notice Keeps track of the total number of deposits.
    uint256 public numberOfDeposits; 

    //@notice Keeps track of the total number of withdrawals.
    uint256 public numberOfWithdrawals;

    //@notice Mapping that stores the deposited balance for each user.
    mapping (address => uint256) public balance;

    /*///////////////////////
					    Events
	////////////////////////*/

    //@notice Emitted when a deposit is made.
    //@param user Address of the depositor.
    //@param amount Amount deposited in wei.
    event Deposit(address indexed user, uint256 amount);

    //@notice Emitted when a withdrawal is made.
    //@param user Address of the user withdrawing funds.
    //@param amount Amount withdrawn in wei.
    event Withdrawal(address indexed user, uint256 amount);


    /*///////////////////////
						Errors
	///////////////////////*/


    //@notice Thrown when a user tries to withdraw more than the allowed limit per transaction.
    error WithdrawalAmountExceedsLimit();

    //@notice Thrown when a user tries to withdraw more than their vault balance.
    error InsufficientBalance();

    //@notice Thrown when a deposit exceeds the global BankCap limit
    error AmountExceedsBankCap();

    //@notice Thrown when the sent amount is zero, both for deposits and withdrawals.
    error AmountMustBeGreaterThanZero();

    //@notice Thrown when a transaction fails to send funds.
    error TransactionFailed();


    /*///////////////////////
					Modifiers
	////////////////////////*/

    //@notice Ensures that the withdrawal amount does not exceed the per-transaction maximum.
    //@param _amount The amount requested by the user.
    modifier withdrawalWithinLimit(uint256 _amount) {
        if (_amount > maxWithdrawalPerTx) {
            revert WithdrawalAmountExceedsLimit();
        }
        _;
    }

    /*///////////////////////
					Functions
	///////////////////////*/

    /**
     * @notice Initializes the contract with a specified bankCap limit.
     * @param _bankCap The maximum total balance allowed in the contract.
     */
    constructor(uint256 _bankCap){
        bankCap = _bankCap;
    }
    
    /**
     * @notice Allows a user to deposit native tokens (ETH) into their personal vault.
     * @dev Reverts if the deposit amount is zero or if the total contract balance exceeds the bankCap limit.
     *      Updates the user's vault balance and increments the deposit counter.
     *      Emits a {Deposit} event upon successful deposit.
     * @custom:security Consider using reentrancy guards in production environments.
     */
    function deposit() external payable{
        
        if (msg.value == 0) 
            revert AmountMustBeGreaterThanZero();

        if (address(this).balance > bankCap)
            revert AmountExceedsBankCap();

        balance[msg.sender] += msg.value;

        _updateDepositCount(); 

        emit Deposit(msg.sender, msg.value);
        
    }

    /**
     * @notice Allows users to withdraw ETH from their vault.
     * @dev Enforces withdrawal limits and balance checks.
     * Emits a {Withdrawal} event upon success.
     * @param _amount The amount to withdraw in wei.
     */
    function claim(uint256 _amount) external withdrawalWithinLimit(_amount){
        
        if (_amount == 0) 
        revert AmountMustBeGreaterThanZero();

        uint256 userBalance = balance[msg.sender];
        if (_amount > userBalance) revert InsufficientBalance();
        
        balance[msg.sender] = userBalance - _amount;

        (bool sent, ) = payable(msg.sender).call{value: _amount}("");
        if (!sent)
        revert TransactionFailed();

        _updateWithdrawalCount();

        emit Withdrawal(msg.sender, _amount);
    }

    /**
     * @notice Returns the total ETH balance stored in the contract.
     * @return The current contract balance in wei.
     */
    function getBankBalance() external view returns (uint256) {
        return address(this).balance;
    }

    /**
     * @notice Increments the deposit counter.
     * @dev Used internally to track the number of deposits.
     */
    function _updateDepositCount() private {
        ++numberOfDeposits;
    }

    /**
     * @notice Increments the withdrawal counter.
     * @dev Used internally to track the number of withdrawals.
     */
    function _updateWithdrawalCount() private {
        ++numberOfWithdrawals;
    }
}
