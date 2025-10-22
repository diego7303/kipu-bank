
# 🏦 KipuBank

Ethereum smart contract for managing deposits and withdrawals with limits, developed for educational purposes.

---

## 📜 Description

KipuBank allows users to:

- Deposit ETH within a global limit (`bankCap`).
- Withdraw a portion of their balance up to a maximum per transaction (`maxWithdrawalPerTx`).
- Keep track of all transactions (deposits and withdrawals).
- Emit events reflecting each important operation.

> ⚠️ This contract is **not audited** and **should not be used in production**.

---

## 🚀 Features

- Global deposit limit control (`bankCap`).
- Individual withdrawal limits.
- Strict validations using custom errors.
- Safe ETH transfers using `.call`.
- Compatible with Remix IDE and testnets like Sepolia or Goerli.

---

## 🧱 Public Variables

| Variable              | Type       | Description                                                   |
|-----------------------|------------|---------------------------------------------------------------|
| `bankCap`             | `uint256`  | Maximum total ETH the contract can hold.                     |
| `maxWithdrawalPerTx`  | `uint256`  | Maximum amount that can be withdrawn in a single transaction.|
| `numberOfDeposits`    | `uint256`  | Total number of deposits made.                                |
| `numberOfWithdrawals` | `uint256`  | Total number of withdrawals made.                             |
| `balance`             | `mapping`  | Individual balance of each user.                              |

---

## 🧾 Main Functions

### `constructor(uint256 _bankCap)`
Initializes the contract with a maximum ETH limit (`bankCap`).

---

### `deposit() external payable`
Allows users to deposit ETH.

- Validates that the deposit is greater than 0.
- Ensures the deposit does not exceed the `bankCap`.
- Updates the user's vault balance and increments the deposit counter.
- Emits the `Deposit` event.

---

### `claim(uint256 _amount) external`
Allows users to withdraw a portion of their balance.

- Uses the `withdrawalWithinLimit` modifier to validate the amount.
- Checks that:
  - The amount is greater than 0.
  - The user has sufficient balance.
- Transfers ETH using `.call`.
- Emits the `Withdrawal` event.

---

### `getBankBalance() external view`
Returns the total ETH held in the contract.

---

## 📢 Events

| Event       | Parameters                        | Description                       |
|-------------|-----------------------------------|-----------------------------------|
| `Deposit`   | `address user`, `uint256 amount`  | Emitted when ETH is deposited.    |
| `Withdrawal`| `address user`, `uint256 amount`  | Emitted when ETH is withdrawn.    |

---

## ❌ Custom Errors

| Error                          | When it occurs                                                 |
|--------------------------------|---------------------------------------------------------------|
| `AmountMustBeGreaterThanZero()` | If deposit or withdrawal amount is zero.                     |
| `AmountExceedsBankCap()`        | If the deposit exceeds the total `bankCap`.                  |
| `InsufficientBalance()`         | If the user tries to withdraw more than their balance.       |
| `WithdrawalAmountExceedsLimit()`| If the withdrawal exceeds the per-transaction limit.         |
| `TransactionFailed()`           | If the ETH transfer using `.call` fails.                     |

---

## 🔐 Modifier

### `withdrawalWithinLimit(uint256 _amount)`
Prevents a withdrawal from exceeding the maximum per-transaction limit (`maxWithdrawalPerTx`).

---

## 🧪 How to Test in Remix

1. Open [https://remix.ethereum.org](https://remix.ethereum.org)
2. Copy and paste the contract code into a new file named `KipuBank.sol`.
3. Select the "Deploy & Run Transactions" tab.
4. Choose the environment:
   - `Injected Provider` to connect MetaMask for Sepolia testnet.
   - `Remix VM` for local testing.
5. Enter the `bankCap` value (in wei) in the deployment field.
6. Interact with the `deposit` and `claim` functions.

---

## 📝 License

MIT License

---

## 👨‍💻 Author

**Diego Acosta**  
This contract was created as an educational exercise.  
It is **not optimized or audited** for production use.

---

## 🤖 Disclaimer

This `README.md` was generated with AI assistance for educational and documentation purposes.  
Content may require manual review before use in real or production environments.
