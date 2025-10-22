// SPDX-License-Identifier: MIT
pragma solidity >0.8.20;

/**
	*@title Contrato KipuBank
	*@notice Este es un contrato con fines educativos.
	*@author Diego Acosta
	*@custom:security No usar en producción.
*/

contract KipuBank {

 	/*///////////////////////
					Variables
	///////////////////////*/   

    //@notice variable immutable impone un limite global de depositos (bankCap), definido durante el despliegue
    uint256 public immutable bankCap;

    //@notice pueden retirar balance de su boveda, pero solo hasta un umbral fijo por transaccion
    uint256 public immutable maxWithdrawalPerTx = 100000000000000000 wei; // 0.10 ETH en wei    

    //@notice registro del numero de depositos
    uint256 public numberOfDeposits; 

    //@notice registro del numero de retiros
    uint256 public numberOfWithdrawals;

    //@notice mapping para almacenar el balance ingresado por el usuario
    mapping (address => uint256) public balance;

    /*///////////////////////
					    Events
	////////////////////////*/

    ///@notice evento emitido cuando se realiza un deposito
    event Deposit(address indexed user, uint256 amount);

    ///@notice evento emitido cuando se realiza un retiro
    event Withdrawal(address indexed user, uint256 amount);


    /*///////////////////////
						Errors
	///////////////////////*/


    ///@notice se emite cuando se intenta retirar mas de la cantidad maxima permitida por transaccion
    error WithdrawalAmountExceedsLimit();

    ///@notice se emite cuando se intenta retirar mas de lo que se tiene en la boveda
    error InsufficientBalance();

    ///@notice se emite cuando el monto ingresado supera el BankCap
    error AmountExceedsBankCap();

    ///@notice se emite al intentar enviar un valor == 0 tanto en deposit como withdraw
    error AmountMustBeGreaterThanZero();

    ///@notice se emite cuando una transaccion falla
    error TransactionFailed();


    /*///////////////////////
					Modifiers
	////////////////////////*/

    /// @notice Valida que el monto no exceda el máximo permitido por transacción.
    /// @param _amount El monto solicitado por el usuario.
    modifier withdrawalWithinLimit(uint256 _amount) {
        if (_amount > maxWithdrawalPerTx) {
            revert WithdrawalAmountExceedsLimit();
        }
        _;
    }

    /*///////////////////////
					Functions
	///////////////////////*/


    constructor(uint256 _bankCap){
        bankCap = _bankCap;
    }
    
    function deposit() external payable{
        
        if (msg.value == 0) 
            revert AmountMustBeGreaterThanZero();//evita depositos vacios

        if (address(this).balance > bankCap)
            revert AmountExceedsBankCap();//evita que se exceda el bankCap

        balance[msg.sender] += msg.value;//guarda el saldo depositado

        ++numberOfDeposits; //incrementa la variable cada vez que se hace un depósito

        emit Deposit(msg.sender, msg.value);
        
    }

    function claim(uint256 _amount) external withdrawalWithinLimit(_amount){
        if (_amount == 0) 
        revert AmountMustBeGreaterThanZero();

        if (_amount > maxWithdrawalPerTx) revert WithdrawalAmountExceedsLimit();

        if (_amount > balance[msg.sender]) revert InsufficientBalance();
        
        balance[msg.sender] -= _amount;

        (bool sent, ) = payable(msg.sender).call{value: _amount}("");
        if (!sent)
            revert TransactionFailed();

        ++numberOfWithdrawals;

        emit Withdrawal(msg.sender, _amount);
    }

    function getBankBalance() external view returns (uint256) {
        return address(this).balance;
    }
}
