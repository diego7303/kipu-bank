
# 🏦 KipuBank

Contrato inteligente de Ethereum para la gestión de depósitos y retiros con límites, desarrollado con fines educativos.

---

## 📜 Descripción

KipuBank permite a los usuarios:

- Depositar ETH dentro de un límite global (`bankCap`).
- Retirar parte de su saldo hasta un monto máximo por transacción (`maxWithdrawalPerTx`).
- Llevar un registro de todas las transacciones (depósitos y retiros).
- Emitir eventos que reflejan cada operación importante.

> ⚠️ Este contrato **no está auditado** y **no debe usarse en producción**.

---

## 🚀 Características

- Control de límite máximo de fondos (`bankCap`).
- Límite por retiro individual.
- Validaciones estrictas con errores personalizados.
- Uso de `call` para transferencias seguras de ETH.
- Compatible con Remix IDE y redes de prueba como Sepolia o Goerli.

---

## 🧱 Variables públicas

| Variable              | Tipo       | Descripción                                                   |
|-----------------------|------------|---------------------------------------------------------------|
| `bankCap`             | `uint256`  | Límite máximo total de ETH que puede mantener el contrato.   |
| `maxWithdrawalPerTx`  | `uint256`  | Monto máximo que se puede retirar en una sola transacción.   |
| `numberOfDeposits`    | `uint256`  | Cantidad total de depósitos realizados.                      |
| `numberOfWithdrawals` | `uint256`  | Cantidad total de retiros realizados.                        |
| `balance`             | `mapping`  | Saldo individual de cada usuario.                            |

---

## 🧾 Funciones principales

### `constructor(uint256 _bankCap)`
Inicializa el contrato con un límite máximo de ETH (`bankCap`).

---

### `deposit() external payable`
Permite a los usuarios depositar ETH.

- Valida que el depósito sea mayor a 0.
- Verifica que no se exceda el `bankCap`.
- Registra el saldo del usuario y emite el evento `Deposit`.

---

### `claim(uint256 _amount) external`
Permite a los usuarios retirar parte de su saldo.

- Usa el modifier `withdrawalWithinLimit` para validar el monto.
- Verifica que:
  - El monto sea mayor que 0.
  - No exceda el saldo disponible del usuario.
- Realiza la transferencia mediante `.call`.
- Emite el evento `Withdrawal`.

---

## 📢 Eventos

| Evento      | Parámetros                        | Descripción                       |
|-------------|-----------------------------------|-----------------------------------|
| `Deposit`   | `address user`, `uint256 amount`  | Emitido al depositar ETH.        |
| `Withdrawal`| `address user`, `uint256 amount`  | Emitido al retirar ETH.          |

---

## ❌ Errores personalizados

| Error                          | Cuándo ocurre                                                     |
|--------------------------------|-------------------------------------------------------------------|
| `AmountMustBeGreaterThanZero()` | Si el monto de depósito o retiro es igual a 0.                   |
| `AmountExceedsBankCap()`        | Si el contrato superaría el `bankCap` con el nuevo depósito.     |
| `InsufficientBalance()`         | Si el usuario intenta retirar más de lo que tiene.               |
| `WithdrawalAmountExceedsLimit()`| Si el retiro excede el límite máximo por transacción.           |
| `TransactionFailed()`           | Si la transferencia de ETH mediante `.call` falla.               |

---

## 🔐 Modifier

### `withdrawalWithinLimit(uint256 _amount)`
Evita que un retiro supere el límite máximo por transacción (`maxWithdrawalPerTx`).

---

## 🧪 Cómo probarlo en Remix

1. Abrí [https://remix.ethereum.org](https://remix.ethereum.org)
2. Copiá y pegá el código del contrato en un nuevo archivo `KipuBank.sol`
3. Seleccioná la pestaña "Deploy & Run Transactions"
4. Elegí el entorno: `Injected Provider` para testnet o `Remix VM` para pruebas locales.
5. Ingresá el valor de `bankCap` (en wei) en el campo de despliegue.
6. Interactuá con las funciones `deposit` y `claim`.

---

## 📝 Licencia

MIT License

---

## 👨‍💻 Autor

**Diego Acosta**  
Este contrato fue creado como ejercicio educativo.  
No está optimizado ni auditado para producción.

## 🤖 Disclaimer

Este `README.md` fue generado con la asistencia de inteligencia artificial (IA) para fines educativos y de documentación.  
El contenido puede requerir revisión y validación manual para su uso en entornos reales o producción.
