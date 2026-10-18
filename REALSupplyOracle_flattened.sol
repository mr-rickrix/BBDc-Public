// SPDX-License-Identifier: MIT

// Real Estate Alliance League, Illinois, USA
// REAL Supply Oracle

// Reports REAL total, circulating, burned, and non-circulating supply.
// Tracks registered vesting locks, DAO reserves, and undistributed
// staking rewards reserves. User-staked REAL remains circulating.
// Separately reports configured liquidity pool and staking metrics.

// This oracle reads accounting data; it does not hold or move tokens.
// Configuration and implementation upgrades are controlled by its owner.

// REAL Token: 0x325Aa344761c19F7ab6dc45A95f01d6907A30DCA
// https://thisisreal.io   /    support@thisisreal.io

// Developed by Building Blocks Developers Co. (https://BBDc.io)
// for Real Estate Alliance League Inc.
// File: @openzeppelin/contracts-upgradeable@5.1.0/proxy/utils/Initializable.sol


// OpenZeppelin Contracts (last updated v5.0.0) (proxy/utils/Initializable.sol)

pragma solidity ^0.8.20;

/**
 * @dev This is a base contract to aid in writing upgradeable contracts, or any kind of contract that will be deployed
 * behind a proxy. Since proxied contracts do not make use of a constructor, it's common to move constructor logic to an
 * external initializer function, usually called `initialize`. It then becomes necessary to protect this initializer
 * function so it can only be called once. The {initializer} modifier provided by this contract will have this effect.
 *
 * The initialization functions use a version number. Once a version number is used, it is consumed and cannot be
 * reused. This mechanism prevents re-execution of each "step" but allows the creation of new initialization steps in
 * case an upgrade adds a module that needs to be initialized.
 *
 * For example:
 *
 * [.hljs-theme-light.nopadding]
 * ```solidity
 * contract MyToken is ERC20Upgradeable {
 *     function initialize() initializer public {
 *         __ERC20_init("MyToken", "MTK");
 *     }
 * }
 *
 * contract MyTokenV2 is MyToken, ERC20PermitUpgradeable {
 *     function initializeV2() reinitializer(2) public {
 *         __ERC20Permit_init("MyToken");
 *     }
 * }
 * ```
 *
 * TIP: To avoid leaving the proxy in an uninitialized state, the initializer function should be called as early as
 * possible by providing the encoded function call as the `_data` argument to {ERC1967Proxy-constructor}.
 *
 * CAUTION: When used with inheritance, manual care must be taken to not invoke a parent initializer twice, or to ensure
 * that all initializers are idempotent. This is not verified automatically as constructors are by Solidity.
 *
 * [CAUTION]
 * ====
 * Avoid leaving a contract uninitialized.
 *
 * An uninitialized contract can be taken over by an attacker. This applies to both a proxy and its implementation
 * contract, which may impact the proxy. To prevent the implementation contract from being used, you should invoke
 * the {_disableInitializers} function in the constructor to automatically lock it when it is deployed:
 *
 * [.hljs-theme-light.nopadding]
 * ```
 * /// @custom:oz-upgrades-unsafe-allow constructor
 * constructor() {
 *     _disableInitializers();
 * }
 * ```
 * ====
 */
abstract contract Initializable {
    /**
     * @dev Storage of the initializable contract.
     *
     * It's implemented on a custom ERC-7201 namespace to reduce the risk of storage collisions
     * when using with upgradeable contracts.
     *
     * @custom:storage-location erc7201:openzeppelin.storage.Initializable
     */
    struct InitializableStorage {
        /**
         * @dev Indicates that the contract has been initialized.
         */
        uint64 _initialized;
        /**
         * @dev Indicates that the contract is in the process of being initialized.
         */
        bool _initializing;
    }

    // keccak256(abi.encode(uint256(keccak256("openzeppelin.storage.Initializable")) - 1)) & ~bytes32(uint256(0xff))
    bytes32 private constant INITIALIZABLE_STORAGE = 0xf0c57e16840df040f15088dc2f81fe391c3923bec73e23a9662efc9c229c6a00;

    /**
     * @dev The contract is already initialized.
     */
    error InvalidInitialization();

    /**
     * @dev The contract is not initializing.
     */
    error NotInitializing();

    /**
     * @dev Triggered when the contract has been initialized or reinitialized.
     */
    event Initialized(uint64 version);

    /**
     * @dev A modifier that defines a protected initializer function that can be invoked at most once. In its scope,
     * `onlyInitializing` functions can be used to initialize parent contracts.
     *
     * Similar to `reinitializer(1)`, except that in the context of a constructor an `initializer` may be invoked any
     * number of times. This behavior in the constructor can be useful during testing and is not expected to be used in
     * production.
     *
     * Emits an {Initialized} event.
     */
    modifier initializer() {
        // solhint-disable-next-line var-name-mixedcase
        InitializableStorage storage $ = _getInitializableStorage();

        // Cache values to avoid duplicated sloads
        bool isTopLevelCall = !$._initializing;
        uint64 initialized = $._initialized;

        // Allowed calls:
        // - initialSetup: the contract is not in the initializing state and no previous version was
        //                 initialized
        // - construction: the contract is initialized at version 1 (no reininitialization) and the
        //                 current contract is just being deployed
        bool initialSetup = initialized == 0 && isTopLevelCall;
        bool construction = initialized == 1 && address(this).code.length == 0;

        if (!initialSetup && !construction) {
            revert InvalidInitialization();
        }
        $._initialized = 1;
        if (isTopLevelCall) {
            $._initializing = true;
        }
        _;
        if (isTopLevelCall) {
            $._initializing = false;
            emit Initialized(1);
        }
    }

    /**
     * @dev A modifier that defines a protected reinitializer function that can be invoked at most once, and only if the
     * contract hasn't been initialized to a greater version before. In its scope, `onlyInitializing` functions can be
     * used to initialize parent contracts.
     *
     * A reinitializer may be used after the original initialization step. This is essential to configure modules that
     * are added through upgrades and that require initialization.
     *
     * When `version` is 1, this modifier is similar to `initializer`, except that functions marked with `reinitializer`
     * cannot be nested. If one is invoked in the context of another, execution will revert.
     *
     * Note that versions can jump in increments greater than 1; this implies that if multiple reinitializers coexist in
     * a contract, executing them in the right order is up to the developer or operator.
     *
     * WARNING: Setting the version to 2**64 - 1 will prevent any future reinitialization.
     *
     * Emits an {Initialized} event.
     */
    modifier reinitializer(uint64 version) {
        // solhint-disable-next-line var-name-mixedcase
        InitializableStorage storage $ = _getInitializableStorage();

        if ($._initializing || $._initialized >= version) {
            revert InvalidInitialization();
        }
        $._initialized = version;
        $._initializing = true;
        _;
        $._initializing = false;
        emit Initialized(version);
    }

    /**
     * @dev Modifier to protect an initialization function so that it can only be invoked by functions with the
     * {initializer} and {reinitializer} modifiers, directly or indirectly.
     */
    modifier onlyInitializing() {
        _checkInitializing();
        _;
    }

    /**
     * @dev Reverts if the contract is not in an initializing state. See {onlyInitializing}.
     */
    function _checkInitializing() internal view virtual {
        if (!_isInitializing()) {
            revert NotInitializing();
        }
    }

    /**
     * @dev Locks the contract, preventing any future reinitialization. This cannot be part of an initializer call.
     * Calling this in the constructor of a contract will prevent that contract from being initialized or reinitialized
     * to any version. It is recommended to use this to lock implementation contracts that are designed to be called
     * through proxies.
     *
     * Emits an {Initialized} event the first time it is successfully executed.
     */
    function _disableInitializers() internal virtual {
        // solhint-disable-next-line var-name-mixedcase
        InitializableStorage storage $ = _getInitializableStorage();

        if ($._initializing) {
            revert InvalidInitialization();
        }
        if ($._initialized != type(uint64).max) {
            $._initialized = type(uint64).max;
            emit Initialized(type(uint64).max);
        }
    }

    /**
     * @dev Returns the highest version that has been initialized. See {reinitializer}.
     */
    function _getInitializedVersion() internal view returns (uint64) {
        return _getInitializableStorage()._initialized;
    }

    /**
     * @dev Returns `true` if the contract is currently initializing. See {onlyInitializing}.
     */
    function _isInitializing() internal view returns (bool) {
        return _getInitializableStorage()._initializing;
    }

    /**
     * @dev Returns a pointer to the storage namespace.
     */
    // solhint-disable-next-line var-name-mixedcase
    function _getInitializableStorage() private pure returns (InitializableStorage storage $) {
        assembly {
            $.slot := INITIALIZABLE_STORAGE
        }
    }
}

// File: @openzeppelin/contracts/interfaces/draft-IERC1822.sol


// OpenZeppelin Contracts (last updated v5.1.0) (interfaces/draft-IERC1822.sol)

pragma solidity ^0.8.20;

/**
 * @dev ERC-1822: Universal Upgradeable Proxy Standard (UUPS) documents a method for upgradeability through a simplified
 * proxy whose upgrades are fully controlled by the current implementation.
 */
interface IERC1822Proxiable {
    /**
     * @dev Returns the storage slot that the proxiable contract assumes is being used to store the implementation
     * address.
     *
     * IMPORTANT: A proxy pointing at a proxiable contract should not be considered proxiable itself, because this risks
     * bricking a proxy that upgrades to it, by delegating to itself until out of gas. Thus it is critical that this
     * function revert if invoked through a proxy.
     */
    function proxiableUUID() external view returns (bytes32);
}

// File: @openzeppelin/contracts/proxy/beacon/IBeacon.sol


// OpenZeppelin Contracts (last updated v5.0.0) (proxy/beacon/IBeacon.sol)

pragma solidity ^0.8.20;

/**
 * @dev This is the interface that {BeaconProxy} expects of its beacon.
 */
interface IBeacon {
    /**
     * @dev Must return an address that can be used as a delegate call target.
     *
     * {UpgradeableBeacon} will check that this address is a contract.
     */
    function implementation() external view returns (address);
}

// File: @openzeppelin/contracts/interfaces/IERC1967.sol


// OpenZeppelin Contracts (last updated v5.0.0) (interfaces/IERC1967.sol)

pragma solidity ^0.8.20;

/**
 * @dev ERC-1967: Proxy Storage Slots. This interface contains the events defined in the ERC.
 */
interface IERC1967 {
    /**
     * @dev Emitted when the implementation is upgraded.
     */
    event Upgraded(address indexed implementation);

    /**
     * @dev Emitted when the admin account has changed.
     */
    event AdminChanged(address previousAdmin, address newAdmin);

    /**
     * @dev Emitted when the beacon is changed.
     */
    event BeaconUpgraded(address indexed beacon);
}

// File: @openzeppelin/contracts/utils/Errors.sol


// OpenZeppelin Contracts (last updated v5.1.0) (utils/Errors.sol)

pragma solidity ^0.8.20;

/**
 * @dev Collection of common custom errors used in multiple contracts
 *
 * IMPORTANT: Backwards compatibility is not guaranteed in future versions of the library.
 * It is recommended to avoid relying on the error API for critical functionality.
 *
 * _Available since v5.1._
 */
library Errors {
    /**
     * @dev The ETH balance of the account is not enough to perform the operation.
     */
    error InsufficientBalance(uint256 balance, uint256 needed);

    /**
     * @dev A call to an address target failed. The target may have reverted.
     */
    error FailedCall();

    /**
     * @dev The deployment failed.
     */
    error FailedDeployment();

    /**
     * @dev A necessary precompile is missing.
     */
    error MissingPrecompile(address);
}

// File: @openzeppelin/contracts/utils/Address.sol


// OpenZeppelin Contracts (last updated v5.1.0) (utils/Address.sol)

pragma solidity ^0.8.20;


/**
 * @dev Collection of functions related to the address type
 */
library Address {
    /**
     * @dev There's no code at `target` (it is not a contract).
     */
    error AddressEmptyCode(address target);

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://consensys.net/diligence/blog/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.8.20/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        if (address(this).balance < amount) {
            revert Errors.InsufficientBalance(address(this).balance, amount);
        }

        (bool success, ) = recipient.call{value: amount}("");
        if (!success) {
            revert Errors.FailedCall();
        }
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain `call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason or custom error, it is bubbled
     * up by this function (like regular Solidity function calls). However, if
     * the call reverted with no returned reason, this function reverts with a
     * {Errors.FailedCall} error.
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     */
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        if (address(this).balance < value) {
            revert Errors.InsufficientBalance(address(this).balance, value);
        }
        (bool success, bytes memory returndata) = target.call{value: value}(data);
        return verifyCallResultFromTarget(target, success, returndata);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a static call.
     */
    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        (bool success, bytes memory returndata) = target.staticcall(data);
        return verifyCallResultFromTarget(target, success, returndata);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a delegate call.
     */
    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        (bool success, bytes memory returndata) = target.delegatecall(data);
        return verifyCallResultFromTarget(target, success, returndata);
    }

    /**
     * @dev Tool to verify that a low level call to smart-contract was successful, and reverts if the target
     * was not a contract or bubbling up the revert reason (falling back to {Errors.FailedCall}) in case
     * of an unsuccessful call.
     */
    function verifyCallResultFromTarget(
        address target,
        bool success,
        bytes memory returndata
    ) internal view returns (bytes memory) {
        if (!success) {
            _revert(returndata);
        } else {
            // only check if target is a contract if the call was successful and the return data is empty
            // otherwise we already know that it was a contract
            if (returndata.length == 0 && target.code.length == 0) {
                revert AddressEmptyCode(target);
            }
            return returndata;
        }
    }

    /**
     * @dev Tool to verify that a low level call was successful, and reverts if it wasn't, either by bubbling the
     * revert reason or with a default {Errors.FailedCall} error.
     */
    function verifyCallResult(bool success, bytes memory returndata) internal pure returns (bytes memory) {
        if (!success) {
            _revert(returndata);
        } else {
            return returndata;
        }
    }

    /**
     * @dev Reverts with returndata if present. Otherwise reverts with {Errors.FailedCall}.
     */
    function _revert(bytes memory returndata) private pure {
        // Look for revert reason and bubble it up if present
        if (returndata.length > 0) {
            // The easiest way to bubble the revert reason is using memory via assembly
            assembly ("memory-safe") {
                let returndata_size := mload(returndata)
                revert(add(32, returndata), returndata_size)
            }
        } else {
            revert Errors.FailedCall();
        }
    }
}

// File: @openzeppelin/contracts/utils/StorageSlot.sol


// OpenZeppelin Contracts (last updated v5.1.0) (utils/StorageSlot.sol)
// This file was procedurally generated from scripts/generate/templates/StorageSlot.js.

pragma solidity ^0.8.20;

/**
 * @dev Library for reading and writing primitive types to specific storage slots.
 *
 * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
 * This library helps with reading and writing to such slots without the need for inline assembly.
 *
 * The functions in this library return Slot structs that contain a `value` member that can be used to read or write.
 *
 * Example usage to set ERC-1967 implementation slot:
 * ```solidity
 * contract ERC1967 {
 *     // Define the slot. Alternatively, use the SlotDerivation library to derive the slot.
 *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
 *
 *     function _getImplementation() internal view returns (address) {
 *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
 *     }
 *
 *     function _setImplementation(address newImplementation) internal {
 *         require(newImplementation.code.length > 0);
 *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
 *     }
 * }
 * ```
 *
 * TIP: Consider using this library along with {SlotDerivation}.
 */
library StorageSlot {
    struct AddressSlot {
        address value;
    }

    struct BooleanSlot {
        bool value;
    }

    struct Bytes32Slot {
        bytes32 value;
    }

    struct Uint256Slot {
        uint256 value;
    }

    struct Int256Slot {
        int256 value;
    }

    struct StringSlot {
        string value;
    }

    struct BytesSlot {
        bytes value;
    }

    /**
     * @dev Returns an `AddressSlot` with member `value` located at `slot`.
     */
    function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
        assembly ("memory-safe") {
            r.slot := slot
        }
    }

    /**
     * @dev Returns a `BooleanSlot` with member `value` located at `slot`.
     */
    function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
        assembly ("memory-safe") {
            r.slot := slot
        }
    }

    /**
     * @dev Returns a `Bytes32Slot` with member `value` located at `slot`.
     */
    function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
        assembly ("memory-safe") {
            r.slot := slot
        }
    }

    /**
     * @dev Returns a `Uint256Slot` with member `value` located at `slot`.
     */
    function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
        assembly ("memory-safe") {
            r.slot := slot
        }
    }

    /**
     * @dev Returns a `Int256Slot` with member `value` located at `slot`.
     */
    function getInt256Slot(bytes32 slot) internal pure returns (Int256Slot storage r) {
        assembly ("memory-safe") {
            r.slot := slot
        }
    }

    /**
     * @dev Returns a `StringSlot` with member `value` located at `slot`.
     */
    function getStringSlot(bytes32 slot) internal pure returns (StringSlot storage r) {
        assembly ("memory-safe") {
            r.slot := slot
        }
    }

    /**
     * @dev Returns an `StringSlot` representation of the string storage pointer `store`.
     */
    function getStringSlot(string storage store) internal pure returns (StringSlot storage r) {
        assembly ("memory-safe") {
            r.slot := store.slot
        }
    }

    /**
     * @dev Returns a `BytesSlot` with member `value` located at `slot`.
     */
    function getBytesSlot(bytes32 slot) internal pure returns (BytesSlot storage r) {
        assembly ("memory-safe") {
            r.slot := slot
        }
    }

    /**
     * @dev Returns an `BytesSlot` representation of the bytes storage pointer `store`.
     */
    function getBytesSlot(bytes storage store) internal pure returns (BytesSlot storage r) {
        assembly ("memory-safe") {
            r.slot := store.slot
        }
    }
}

// File: @openzeppelin/contracts/proxy/ERC1967/ERC1967Utils.sol


// OpenZeppelin Contracts (last updated v5.1.0) (proxy/ERC1967/ERC1967Utils.sol)

pragma solidity ^0.8.21;





/**
 * @dev This library provides getters and event emitting update functions for
 * https://eips.ethereum.org/EIPS/eip-1967[ERC-1967] slots.
 */
library ERC1967Utils {
    /**
     * @dev Storage slot with the address of the current implementation.
     * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1.
     */
    // solhint-disable-next-line private-vars-leading-underscore
    bytes32 internal constant IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;

    /**
     * @dev The `implementation` of the proxy is invalid.
     */
    error ERC1967InvalidImplementation(address implementation);

    /**
     * @dev The `admin` of the proxy is invalid.
     */
    error ERC1967InvalidAdmin(address admin);

    /**
     * @dev The `beacon` of the proxy is invalid.
     */
    error ERC1967InvalidBeacon(address beacon);

    /**
     * @dev An upgrade function sees `msg.value > 0` that may be lost.
     */
    error ERC1967NonPayable();

    /**
     * @dev Returns the current implementation address.
     */
    function getImplementation() internal view returns (address) {
        return StorageSlot.getAddressSlot(IMPLEMENTATION_SLOT).value;
    }

    /**
     * @dev Stores a new address in the ERC-1967 implementation slot.
     */
    function _setImplementation(address newImplementation) private {
        if (newImplementation.code.length == 0) {
            revert ERC1967InvalidImplementation(newImplementation);
        }
        StorageSlot.getAddressSlot(IMPLEMENTATION_SLOT).value = newImplementation;
    }

    /**
     * @dev Performs implementation upgrade with additional setup call if data is nonempty.
     * This function is payable only if the setup call is performed, otherwise `msg.value` is rejected
     * to avoid stuck value in the contract.
     *
     * Emits an {IERC1967-Upgraded} event.
     */
    function upgradeToAndCall(address newImplementation, bytes memory data) internal {
        _setImplementation(newImplementation);
        emit IERC1967.Upgraded(newImplementation);

        if (data.length > 0) {
            Address.functionDelegateCall(newImplementation, data);
        } else {
            _checkNonPayable();
        }
    }

    /**
     * @dev Storage slot with the admin of the contract.
     * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1.
     */
    // solhint-disable-next-line private-vars-leading-underscore
    bytes32 internal constant ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;

    /**
     * @dev Returns the current admin.
     *
     * TIP: To get this value clients can read directly from the storage slot shown below (specified by ERC-1967) using
     * the https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
     * `0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103`
     */
    function getAdmin() internal view returns (address) {
        return StorageSlot.getAddressSlot(ADMIN_SLOT).value;
    }

    /**
     * @dev Stores a new address in the ERC-1967 admin slot.
     */
    function _setAdmin(address newAdmin) private {
        if (newAdmin == address(0)) {
            revert ERC1967InvalidAdmin(address(0));
        }
        StorageSlot.getAddressSlot(ADMIN_SLOT).value = newAdmin;
    }

    /**
     * @dev Changes the admin of the proxy.
     *
     * Emits an {IERC1967-AdminChanged} event.
     */
    function changeAdmin(address newAdmin) internal {
        emit IERC1967.AdminChanged(getAdmin(), newAdmin);
        _setAdmin(newAdmin);
    }

    /**
     * @dev The storage slot of the UpgradeableBeacon contract which defines the implementation for this proxy.
     * This is the keccak-256 hash of "eip1967.proxy.beacon" subtracted by 1.
     */
    // solhint-disable-next-line private-vars-leading-underscore
    bytes32 internal constant BEACON_SLOT = 0xa3f0ad74e5423aebfd80d3ef4346578335a9a72aeaee59ff6cb3582b35133d50;

    /**
     * @dev Returns the current beacon.
     */
    function getBeacon() internal view returns (address) {
        return StorageSlot.getAddressSlot(BEACON_SLOT).value;
    }

    /**
     * @dev Stores a new beacon in the ERC-1967 beacon slot.
     */
    function _setBeacon(address newBeacon) private {
        if (newBeacon.code.length == 0) {
            revert ERC1967InvalidBeacon(newBeacon);
        }

        StorageSlot.getAddressSlot(BEACON_SLOT).value = newBeacon;

        address beaconImplementation = IBeacon(newBeacon).implementation();
        if (beaconImplementation.code.length == 0) {
            revert ERC1967InvalidImplementation(beaconImplementation);
        }
    }

    /**
     * @dev Change the beacon and trigger a setup call if data is nonempty.
     * This function is payable only if the setup call is performed, otherwise `msg.value` is rejected
     * to avoid stuck value in the contract.
     *
     * Emits an {IERC1967-BeaconUpgraded} event.
     *
     * CAUTION: Invoking this function has no effect on an instance of {BeaconProxy} since v5, since
     * it uses an immutable beacon without looking at the value of the ERC-1967 beacon slot for
     * efficiency.
     */
    function upgradeBeaconToAndCall(address newBeacon, bytes memory data) internal {
        _setBeacon(newBeacon);
        emit IERC1967.BeaconUpgraded(newBeacon);

        if (data.length > 0) {
            Address.functionDelegateCall(IBeacon(newBeacon).implementation(), data);
        } else {
            _checkNonPayable();
        }
    }

    /**
     * @dev Reverts if `msg.value` is not zero. It can be used to avoid `msg.value` stuck in the contract
     * if an upgrade doesn't perform an initialization call.
     */
    function _checkNonPayable() private {
        if (msg.value > 0) {
            revert ERC1967NonPayable();
        }
    }
}

// File: @openzeppelin/contracts-upgradeable@5.1.0/proxy/utils/UUPSUpgradeable.sol


// OpenZeppelin Contracts (last updated v5.1.0) (proxy/utils/UUPSUpgradeable.sol)

pragma solidity ^0.8.20;




/**
 * @dev An upgradeability mechanism designed for UUPS proxies. The functions included here can perform an upgrade of an
 * {ERC1967Proxy}, when this contract is set as the implementation behind such a proxy.
 *
 * A security mechanism ensures that an upgrade does not turn off upgradeability accidentally, although this risk is
 * reinstated if the upgrade retains upgradeability but removes the security mechanism, e.g. by replacing
 * `UUPSUpgradeable` with a custom implementation of upgrades.
 *
 * The {_authorizeUpgrade} function must be overridden to include access restriction to the upgrade mechanism.
 */
abstract contract UUPSUpgradeable is Initializable, IERC1822Proxiable {
    /// @custom:oz-upgrades-unsafe-allow state-variable-immutable
    address private immutable __self = address(this);

    /**
     * @dev The version of the upgrade interface of the contract. If this getter is missing, both `upgradeTo(address)`
     * and `upgradeToAndCall(address,bytes)` are present, and `upgradeTo` must be used if no function should be called,
     * while `upgradeToAndCall` will invoke the `receive` function if the second argument is the empty byte string.
     * If the getter returns `"5.0.0"`, only `upgradeToAndCall(address,bytes)` is present, and the second argument must
     * be the empty byte string if no function should be called, making it impossible to invoke the `receive` function
     * during an upgrade.
     */
    string public constant UPGRADE_INTERFACE_VERSION = "5.0.0";

    /**
     * @dev The call is from an unauthorized context.
     */
    error UUPSUnauthorizedCallContext();

    /**
     * @dev The storage `slot` is unsupported as a UUID.
     */
    error UUPSUnsupportedProxiableUUID(bytes32 slot);

    /**
     * @dev Check that the execution is being performed through a delegatecall call and that the execution context is
     * a proxy contract with an implementation (as defined in ERC-1967) pointing to self. This should only be the case
     * for UUPS and transparent proxies that are using the current contract as their implementation. Execution of a
     * function through ERC-1167 minimal proxies (clones) would not normally pass this test, but is not guaranteed to
     * fail.
     */
    modifier onlyProxy() {
        _checkProxy();
        _;
    }

    /**
     * @dev Check that the execution is not being performed through a delegate call. This allows a function to be
     * callable on the implementing contract but not through proxies.
     */
    modifier notDelegated() {
        _checkNotDelegated();
        _;
    }

    function __UUPSUpgradeable_init() internal onlyInitializing {
    }

    function __UUPSUpgradeable_init_unchained() internal onlyInitializing {
    }
    /**
     * @dev Implementation of the ERC-1822 {proxiableUUID} function. This returns the storage slot used by the
     * implementation. It is used to validate the implementation's compatibility when performing an upgrade.
     *
     * IMPORTANT: A proxy pointing at a proxiable contract should not be considered proxiable itself, because this risks
     * bricking a proxy that upgrades to it, by delegating to itself until out of gas. Thus it is critical that this
     * function revert if invoked through a proxy. This is guaranteed by the `notDelegated` modifier.
     */
    function proxiableUUID() external view virtual notDelegated returns (bytes32) {
        return ERC1967Utils.IMPLEMENTATION_SLOT;
    }

    /**
     * @dev Upgrade the implementation of the proxy to `newImplementation`, and subsequently execute the function call
     * encoded in `data`.
     *
     * Calls {_authorizeUpgrade}.
     *
     * Emits an {Upgraded} event.
     *
     * @custom:oz-upgrades-unsafe-allow-reachable delegatecall
     */
    function upgradeToAndCall(address newImplementation, bytes memory data) public payable virtual onlyProxy {
        _authorizeUpgrade(newImplementation);
        _upgradeToAndCallUUPS(newImplementation, data);
    }

    /**
     * @dev Reverts if the execution is not performed via delegatecall or the execution
     * context is not of a proxy with an ERC-1967 compliant implementation pointing to self.
     * See {_onlyProxy}.
     */
    function _checkProxy() internal view virtual {
        if (
            address(this) == __self || // Must be called through delegatecall
            ERC1967Utils.getImplementation() != __self // Must be called through an active proxy
        ) {
            revert UUPSUnauthorizedCallContext();
        }
    }

    /**
     * @dev Reverts if the execution is performed via delegatecall.
     * See {notDelegated}.
     */
    function _checkNotDelegated() internal view virtual {
        if (address(this) != __self) {
            // Must not be called through delegatecall
            revert UUPSUnauthorizedCallContext();
        }
    }

    /**
     * @dev Function that should revert when `msg.sender` is not authorized to upgrade the contract. Called by
     * {upgradeToAndCall}.
     *
     * Normally, this function will use an xref:access.adoc[access control] modifier such as {Ownable-onlyOwner}.
     *
     * ```solidity
     * function _authorizeUpgrade(address) internal onlyOwner {}
     * ```
     */
    function _authorizeUpgrade(address newImplementation) internal virtual;

    /**
     * @dev Performs an implementation upgrade with a security check for UUPS proxies, and additional setup call.
     *
     * As a security check, {proxiableUUID} is invoked in the new implementation, and the return value
     * is expected to be the implementation slot in ERC-1967.
     *
     * Emits an {IERC1967-Upgraded} event.
     */
    function _upgradeToAndCallUUPS(address newImplementation, bytes memory data) private {
        try IERC1822Proxiable(newImplementation).proxiableUUID() returns (bytes32 slot) {
            if (slot != ERC1967Utils.IMPLEMENTATION_SLOT) {
                revert UUPSUnsupportedProxiableUUID(slot);
            }
            ERC1967Utils.upgradeToAndCall(newImplementation, data);
        } catch {
            // The implementation is not UUPS
            revert ERC1967Utils.ERC1967InvalidImplementation(newImplementation);
        }
    }
}

// File: @openzeppelin/contracts-upgradeable@5.1.0/utils/ContextUpgradeable.sol


// OpenZeppelin Contracts (last updated v5.0.1) (utils/Context.sol)

pragma solidity ^0.8.20;


/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract ContextUpgradeable is Initializable {
    function __Context_init() internal onlyInitializing {
    }

    function __Context_init_unchained() internal onlyInitializing {
    }
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }

    function _contextSuffixLength() internal view virtual returns (uint256) {
        return 0;
    }
}

// File: @openzeppelin/contracts-upgradeable@5.1.0/access/OwnableUpgradeable.sol


// OpenZeppelin Contracts (last updated v5.0.0) (access/Ownable.sol)

pragma solidity ^0.8.20;



/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * The initial owner is set to the address provided by the deployer. This can
 * later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract OwnableUpgradeable is Initializable, ContextUpgradeable {
    /// @custom:storage-location erc7201:openzeppelin.storage.Ownable
    struct OwnableStorage {
        address _owner;
    }

    // keccak256(abi.encode(uint256(keccak256("openzeppelin.storage.Ownable")) - 1)) & ~bytes32(uint256(0xff))
    bytes32 private constant OwnableStorageLocation = 0x9016d09d72d40fdae2fd8ceac6b6234c7706214fd39c1cd1e609a0528c199300;

    function _getOwnableStorage() private pure returns (OwnableStorage storage $) {
        assembly {
            $.slot := OwnableStorageLocation
        }
    }

    /**
     * @dev The caller account is not authorized to perform an operation.
     */
    error OwnableUnauthorizedAccount(address account);

    /**
     * @dev The owner is not a valid owner account. (eg. `address(0)`)
     */
    error OwnableInvalidOwner(address owner);

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the address provided by the deployer as the initial owner.
     */
    function __Ownable_init(address initialOwner) internal onlyInitializing {
        __Ownable_init_unchained(initialOwner);
    }

    function __Ownable_init_unchained(address initialOwner) internal onlyInitializing {
        if (initialOwner == address(0)) {
            revert OwnableInvalidOwner(address(0));
        }
        _transferOwnership(initialOwner);
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        OwnableStorage storage $ = _getOwnableStorage();
        return $._owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        if (owner() != _msgSender()) {
            revert OwnableUnauthorizedAccount(_msgSender());
        }
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby disabling any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        if (newOwner == address(0)) {
            revert OwnableInvalidOwner(address(0));
        }
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        OwnableStorage storage $ = _getOwnableStorage();
        address oldOwner = $._owner;
        $._owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

// File: @openzeppelin/contracts-upgradeable@5.1.0/access/Ownable2StepUpgradeable.sol


// OpenZeppelin Contracts (last updated v5.1.0) (access/Ownable2Step.sol)

pragma solidity ^0.8.20;



/**
 * @dev Contract module which provides access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * This extension of the {Ownable} contract includes a two-step mechanism to transfer
 * ownership, where the new owner must call {acceptOwnership} in order to replace the
 * old one. This can help prevent common mistakes, such as transfers of ownership to
 * incorrect accounts, or to contracts that are unable to interact with the
 * permission system.
 *
 * The initial owner is specified at deployment time in the constructor for `Ownable`. This
 * can later be changed with {transferOwnership} and {acceptOwnership}.
 *
 * This module is used through inheritance. It will make available all functions
 * from parent (Ownable).
 */
abstract contract Ownable2StepUpgradeable is Initializable, OwnableUpgradeable {
    /// @custom:storage-location erc7201:openzeppelin.storage.Ownable2Step
    struct Ownable2StepStorage {
        address _pendingOwner;
    }

    // keccak256(abi.encode(uint256(keccak256("openzeppelin.storage.Ownable2Step")) - 1)) & ~bytes32(uint256(0xff))
    bytes32 private constant Ownable2StepStorageLocation = 0x237e158222e3e6968b72b9db0d8043aacf074ad9f650f0d1606b4d82ee432c00;

    function _getOwnable2StepStorage() private pure returns (Ownable2StepStorage storage $) {
        assembly {
            $.slot := Ownable2StepStorageLocation
        }
    }

    event OwnershipTransferStarted(address indexed previousOwner, address indexed newOwner);

    function __Ownable2Step_init() internal onlyInitializing {
    }

    function __Ownable2Step_init_unchained() internal onlyInitializing {
    }
    /**
     * @dev Returns the address of the pending owner.
     */
    function pendingOwner() public view virtual returns (address) {
        Ownable2StepStorage storage $ = _getOwnable2StepStorage();
        return $._pendingOwner;
    }

    /**
     * @dev Starts the ownership transfer of the contract to a new account. Replaces the pending transfer if there is one.
     * Can only be called by the current owner.
     *
     * Setting `newOwner` to the zero address is allowed; this can be used to cancel an initiated ownership transfer.
     */
    function transferOwnership(address newOwner) public virtual override onlyOwner {
        Ownable2StepStorage storage $ = _getOwnable2StepStorage();
        $._pendingOwner = newOwner;
        emit OwnershipTransferStarted(owner(), newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`) and deletes any pending owner.
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual override {
        Ownable2StepStorage storage $ = _getOwnable2StepStorage();
        delete $._pendingOwner;
        super._transferOwnership(newOwner);
    }

    /**
     * @dev The new owner accepts the ownership transfer.
     */
    function acceptOwnership() public virtual {
        address sender = _msgSender();
        if (pendingOwner() != sender) {
            revert OwnableUnauthorizedAccount(sender);
        }
        _transferOwnership(sender);
    }
}

// File: @openzeppelin/contracts@5.1.0/token/ERC20/IERC20.sol


// OpenZeppelin Contracts (last updated v5.1.0) (token/ERC20/IERC20.sol)

pragma solidity ^0.8.20;

/**
 * @dev Interface of the ERC-20 standard as defined in the ERC.
 */
interface IERC20 {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev Returns the value of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the value of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves a `value` amount of tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 value) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets a `value` amount of tokens as the allowance of `spender` over the
     * caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 value) external returns (bool);

    /**
     * @dev Moves a `value` amount of tokens from `from` to `to` using the
     * allowance mechanism. `value` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from, address to, uint256 value) external returns (bool);
}

// File: REALSupplyOracle.sol



// Real Estate Alliance League, Illinois, USA
// REAL Supply Oracle

// Reports REAL total, circulating, burned, and non-circulating supply.
// Tracks registered vesting locks, DAO reserves, and undistributed
// staking rewards reserves. User-staked REAL remains circulating.
// Separately reports configured liquidity pool and staking metrics.
//
// This oracle reads accounting data; it does not hold or move tokens.
// Configuration and implementation upgrades are controlled by its owner.

// REAL Token: 0x325Aa344761c19F7ab6dc45A95f01d6907A30DCA
// https://thisisreal.io   /    support@thisisreal.io

// Developed by Building Blocks Developers Co. (https://BBDc.io)
// for Real Estate Alliance League Inc.

pragma solidity ^0.8.28;





interface IVestingFactorySupply {
    function realToken() external view returns (address);
    function totalLocked() external view returns (uint256);
    function getTotalDeployedContracts() external view returns (uint256);
}

/// @dev Trusted accounting adapter: report ONLY undistributed REAL rewards.
/// Exclude DAO reserves, registered vesting locks and user-owned staking balances.
interface IRewardsReserveSupply {
    function realToken() external view returns (address);
    function getUndistributedRewards() external view returns (uint256);
}
/// @dev Informational metrics only; stake NEVER reduces circulating supply.
interface IStakingSupplyMetrics {
    function realToken() external view returns (address);
    function getStakingMetrics() external view returns (uint256 staked, uint256 stakers, uint256 validators);
}

interface IRealV2Pair is IERC20 {
    function token0() external view returns (address);
    function token1() external view returns (address);
}

/// @notice Read-only supply accounting for REAL. This oracle never holds tokens.
/// @dev Deploy a NEW ERC1967Proxy, atomically initializing it with the intended owner.
///      Upgrade-compatible with REALSupplyOracle from commit fe9e8b7; not with older SupplyOracle variants.
contract REALSupplyOracle is Initializable, UUPSUpgradeable, Ownable2StepUpgradeable {
    uint256 public constant MAX_SUPPLY = 100_000_000 ether;
    uint256 public constant MAX_VESTING_FACTORIES = 32;

    IERC20 public realToken;
    uint256 public issuedSupplyBaseline;
    IVestingFactorySupply public vestingFactory; // First factory, retained as a compatibility getter.
    IVestingFactorySupply[] private _additionalFactories;
    mapping(address => bool) public isVestingFactory;
    address public daoWallet;
    address public lpBurnAddress;
    IRealV2Pair public ethLpPair;
    IRealV2Pair public usdcLpPair;
    address public ethQuoteToken;
    address public usdcQuoteToken;
    address[] public voteExcludedWallets;
    mapping(address => bool) public isVoteExcluded;

    address public rewardsReserveWallet;
    IRewardsReserveSupply public rewardsReserveSource;
    IStakingSupplyMetrics public stakingMetricsSource;
    // Appended state: preserve every field used by the deployed REALSupplyOracle.
    bool private _lpBurnAddressConfigured;

    event LpBurnAddressConfigurationChanged(bool configured);

    error OverlappingReserve();
    error InvalidAccountingSource();
    event RewardsReserveUpdated(address wallet, address source);
    event StakingMetricsSourceUpdated(address source);

    error InvalidAddress();
    error InvalidIssuedSupply();
    error SupplyIncreasedAfterBaseline();
    error InvalidSupplyAccounting(uint256 totalSupply, uint256 nonCirculating);
    error InvalidFactory();
    error FactoryAlreadyRegistered();
    error FactoryLimitReached();
    error FactoryAlreadySet();
    error InvalidPair();
    error RenounceDisabled();

    event VestingFactoryAdded(address indexed factory);
    event DaoWalletUpdated(address indexed oldWallet, address indexed newWallet);
    event LpBurnAddressUpdated(address indexed oldAddress, address indexed newAddress);
    event EthLpPairUpdated(address indexed pair, address indexed quoteToken);
    event UsdcLpPairUpdated(address indexed pair, address indexed quoteToken);
    event VoteExcludedWalletAdded(address indexed wallet);
    event VoteExcludedWalletRemoved(address indexed wallet);

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    /// @param initialOwner Address that controls oracle settings and UUPS upgrades (prefer a Safe).
    /// @param tokenAddress REAL token on this chain.
    /// @param totalIssuedEver Cumulative REAL minted before this deployment, including burned REAL.
    ///        Mainnet: 100 million REAL; on Sepolia supply may be different. This assumes no later mint.
    /// @param firstFactory Zero until a verified REAL VestingFactory has been deployed.
    /// @param initialDaoWallet Zero until the DAO vault exists; Safe wallets are circulating.
    /// @param initialLpBurnAddress Zero until the intended LP burn address is confirmed.
    /// @param initialVoteExcludedWallets Wallets excluded from voting, but still circulating.
    /// @param initialRewardsReserveWallet Safe holding undistributed rewards, or zero.
    /// @param initialRewardsReserveSource Trusted aggregate reserve adapter, or zero; mutually exclusive with wallet.
    function initialize(
        address initialOwner,
        address tokenAddress,
        uint256 totalIssuedEver,
        address firstFactory,
        address initialDaoWallet,
        address initialLpBurnAddress,
        address[] calldata initialVoteExcludedWallets,
        address initialRewardsReserveWallet,
        address initialRewardsReserveSource
    ) external initializer {
        if (initialOwner == address(0) || tokenAddress.code.length == 0) revert InvalidAddress();
        __Ownable_init(initialOwner);
        __Ownable2Step_init();
        __UUPSUpgradeable_init();

        realToken = IERC20(tokenAddress);
        uint256 liveSupply = realToken.totalSupply();
        if (totalIssuedEver < liveSupply || totalIssuedEver > MAX_SUPPLY) revert InvalidIssuedSupply();
        issuedSupplyBaseline = totalIssuedEver;
        daoWallet = initialDaoWallet;
        lpBurnAddress = initialLpBurnAddress;
        _lpBurnAddressConfigured = initialLpBurnAddress != address(0);
        _setRewardsReserve(initialRewardsReserveWallet, initialRewardsReserveSource);
        if (firstFactory != address(0)) _addFactory(firstFactory);
        for (uint256 i; i < initialVoteExcludedWallets.length; ++i) {
            address wallet = initialVoteExcludedWallets[i];
            if (wallet != address(0) && !isVoteExcluded[wallet]) {
                isVoteExcluded[wallet] = true;
                voteExcludedWallets.push(wallet);
                emit VoteExcludedWalletAdded(wallet);
            }
        }
    }

    // ERC-20 destruction reduces totalSupply already; this getter is for separate reporting.
    // It does not count transfers to an inaccessible address. It assumes no mint after baseline.
    function getBurnedSupply() external view returns (uint256) {
        uint256 liveSupply = realToken.totalSupply();
        if (liveSupply > issuedSupplyBaseline) revert SupplyIncreasedAfterBaseline();
        return issuedSupplyBaseline - liveSupply;
    }

    function getMaxSupply() external pure returns (uint256) { return MAX_SUPPLY; }
    function getTotalSupply() external view returns (uint256) { return realToken.totalSupply(); }

    function getCirculatingSupply() external view returns (uint256) {
        uint256 total = realToken.totalSupply();
        uint256 nonCirculating = _vestingLockedBalance() + _daoWalletBalance() + getRewardsReserveBalance();
        if (nonCirculating > total) revert InvalidSupplyAccounting(total, nonCirculating);
        return total - nonCirculating;
    }

    function getVestingLockedBalance() external view returns (uint256) { return _vestingLockedBalance(); }
    function getDaoWalletBalance() external view returns (uint256) { return _daoWalletBalance(); }
    function getNonCirculatingBalance() external view returns (uint256) {
        return _vestingLockedBalance() + _daoWalletBalance() + getRewardsReserveBalance();
    }

    function getVestingContractCount() external view returns (uint256 count) {
        if (address(vestingFactory) != address(0)) count += vestingFactory.getTotalDeployedContracts();
        for (uint256 i; i < _additionalFactories.length; ++i) {
            count += _additionalFactories[i].getTotalDeployedContracts();
        }
    }

    function getVestingFactories() external view returns (address[] memory factories) {
        uint256 first = address(vestingFactory) == address(0) ? 0 : 1;
        factories = new address[](first + _additionalFactories.length);
        if (first == 1) factories[0] = address(vestingFactory);
        for (uint256 i; i < _additionalFactories.length; ++i) {
            factories[first + i] = address(_additionalFactories[i]);
        }
    }

    /// @dev Kept for existing integrations. It may only set an initially unset factory.
    function setVestingFactory(address factory) external onlyOwner {
        if (address(vestingFactory) != address(0)) revert FactoryAlreadySet();
        _addFactory(factory);
    }

    function addVestingFactory(address factory) external onlyOwner { _addFactory(factory); }

    function setDaoWallet(address wallet) external onlyOwner {
        if (wallet != address(0) && (wallet == rewardsReserveWallet || wallet == address(rewardsReserveSource) || isVestingFactory[wallet])) revert OverlappingReserve();
        if (_isTrackedVestingWallet(wallet)) revert OverlappingReserve();
        address old = daoWallet;
        daoWallet = wallet;
        emit DaoWalletUpdated(old, wallet);
    }

    /// @notice Choose a direct reserve wallet OR one trusted aggregate accounting source.
    /// Both zero disables reserve tracking. Switching does not move tokens.
    function setRewardsReserve(address wallet, address source) external onlyOwner {
        _setRewardsReserve(wallet, source);
    }

    function _setRewardsReserve(address wallet, address source) internal {
        if (wallet != address(0) && source != address(0)) revert OverlappingReserve();
        address reserve = wallet != address(0) ? wallet : source;
        if (reserve != address(0) && (reserve == daoWallet || reserve == address(realToken) || reserve == address(this) || isVestingFactory[reserve])) revert OverlappingReserve();
        if (_isTrackedVestingWallet(reserve)) revert OverlappingReserve();
        if (source != address(0)) {
            if (source.code.length == 0) revert InvalidAccountingSource();
            if (IRewardsReserveSupply(source).realToken() != address(realToken)) revert InvalidAccountingSource();
            IRewardsReserveSupply(source).getUndistributedRewards();
        }
        rewardsReserveWallet = wallet;
        rewardsReserveSource = IRewardsReserveSupply(source);
        emit RewardsReserveUpdated(wallet, source);
    }

    function getRewardsReserveBalance() public view returns (uint256) {
        if (address(rewardsReserveSource) != address(0)) return rewardsReserveSource.getUndistributedRewards();
        return rewardsReserveWallet == address(0) ? 0 : realToken.balanceOf(rewardsReserveWallet);
    }

    function setStakingMetricsSource(address source) external onlyOwner {
        if (source != address(0)) {
            if (source == address(this) || source.code.length == 0 || IStakingSupplyMetrics(source).realToken() != address(realToken)) revert InvalidAccountingSource();
            IStakingSupplyMetrics(source).getStakingMetrics();
        }
        stakingMetricsSource = IStakingSupplyMetrics(source);
        emit StakingMetricsSourceUpdated(source);
    }

    function getStakingMetrics() external view returns (bool configured, uint256 staked, uint256 stakers, uint256 validators) {
        if (address(stakingMetricsSource) == address(0)) return (false, 0, 0, 0);
        (staked, stakers, validators) = stakingMetricsSource.getStakingMetrics();
        return (true, staked, stakers, validators);
    }

    function setLpBurnAddress(address burnAddress) external onlyOwner {
        address old = lpBurnAddress;
        lpBurnAddress = burnAddress;
        _lpBurnAddressConfigured = true;
        emit LpBurnAddressUpdated(old, burnAddress);
        emit LpBurnAddressConfigurationChanged(true);
    }

    /// @notice Legacy nonzero burn addresses remain configured after upgrade.
    function isLpBurnAddressConfigured() public view returns (bool) {
        return _lpBurnAddressConfigured || lpBurnAddress != address(0);
    }

    function clearLpBurnAddress() external onlyOwner {
        address old = lpBurnAddress;
        lpBurnAddress = address(0);
        _lpBurnAddressConfigured = false;
        emit LpBurnAddressUpdated(old, address(0));
        emit LpBurnAddressConfigurationChanged(false);
    }

    /// @dev For Uniswap V2-style ERC-20 LP tokens. The pair must contain REAL and the stated quote token.
    ///      Address zero clears a pair before it exists. Neither pool changes REAL circulating supply.
    function setEthLpPair(address pair, address quoteToken) external onlyOwner {
        _checkPair(pair, quoteToken, address(usdcLpPair));
        ethLpPair = IRealV2Pair(pair);
        ethQuoteToken = quoteToken;
        emit EthLpPairUpdated(pair, quoteToken);
    }

    function setUsdcLpPair(address pair, address quoteToken) external onlyOwner {
        _checkPair(pair, quoteToken, address(ethLpPair));
        usdcLpPair = IRealV2Pair(pair);
        usdcQuoteToken = quoteToken;
        emit UsdcLpPairUpdated(pair, quoteToken);
    }

    function getEthLpBurned() external view returns (uint256) { return _lpBurned(ethLpPair); }
    function getUsdcLpBurned() external view returns (uint256) { return _lpBurned(usdcLpPair); }
    function getEthLpTotalSupply() external view returns (uint256) { return _lpTotal(ethLpPair); }
    function getUsdcLpTotalSupply() external view returns (uint256) { return _lpTotal(usdcLpPair); }

    // Voting exclusions do not remove Safe/corporate holdings from circulating supply.
    function getVotingPower(uint256 balance) external pure returns (uint256) { return balance / (1_000 ether); }
    function isVotingExcluded(address wallet) external view returns (bool) {
        if (wallet == address(0)) return false;
        return isVoteExcluded[wallet] || wallet == daoWallet;
    }
    function getVoteExcludedWallets() external view returns (address[] memory) { return voteExcludedWallets; }
    function getVoteExcludedWalletCount() external view returns (uint256) { return voteExcludedWallets.length; }

    function addVoteExcludedWallet(address wallet) external onlyOwner {
        if (wallet == address(0) || isVoteExcluded[wallet]) revert InvalidAddress();
        isVoteExcluded[wallet] = true;
        voteExcludedWallets.push(wallet);
        emit VoteExcludedWalletAdded(wallet);
    }

    function removeVoteExcludedWallet(address wallet) external onlyOwner {
        if (!isVoteExcluded[wallet]) revert InvalidAddress();
        isVoteExcluded[wallet] = false;
        for (uint256 i; i < voteExcludedWallets.length; ++i) {
            if (voteExcludedWallets[i] == wallet) {
                voteExcludedWallets[i] = voteExcludedWallets[voteExcludedWallets.length - 1];
                voteExcludedWallets.pop();
                break;
            }
        }
        emit VoteExcludedWalletRemoved(wallet);
    }

    /// @dev Compatibility for consumers of the earlier Sepolia oracle's deployer() getter.
    function deployer() external view returns (address) { return owner(); }

    /// @dev Losing admin control would prevent correcting future DAO/factory addresses.
    function renounceOwnership() public pure override { revert RenounceDisabled(); }

    function _authorizeUpgrade(address) internal override onlyOwner {}

    function _addFactory(address factory) internal {
        if (factory.code.length == 0) revert InvalidFactory();
        if (factory == daoWallet || factory == rewardsReserveWallet || factory == address(rewardsReserveSource)) revert OverlappingReserve();
        if (_factoryTracksWallet(factory, daoWallet) || _factoryTracksWallet(factory, rewardsReserveWallet) || _factoryTracksWallet(factory, address(rewardsReserveSource))) revert OverlappingReserve();
        if (isVestingFactory[factory]) revert FactoryAlreadyRegistered();
        if (getFactoryCount() >= MAX_VESTING_FACTORIES) revert FactoryLimitReached();
        IVestingFactorySupply candidate = IVestingFactorySupply(factory);
        if (candidate.realToken() != address(realToken)) revert InvalidFactory();
        // Validate the required interface before a factory can affect public supply reads.
        candidate.totalLocked();
        candidate.getTotalDeployedContracts();
        if (address(vestingFactory) == address(0)) vestingFactory = candidate;
        else _additionalFactories.push(candidate);
        isVestingFactory[factory] = true;
        emit VestingFactoryAdded(factory);
    }

    function getFactoryCount() public view returns (uint256) {
        return (address(vestingFactory) == address(0) ? 0 : 1) + _additionalFactories.length;
    }

    function _vestingLockedBalance() internal view returns (uint256 total) {
        if (address(vestingFactory) != address(0)) total += vestingFactory.totalLocked();
        for (uint256 i; i < _additionalFactories.length; ++i) {
            total += _additionalFactories[i].totalLocked();
        }
    }

    function _daoWalletBalance() internal view returns (uint256) {
        return daoWallet == address(0) ? 0 : realToken.balanceOf(daoWallet);
    }

    /// @dev REAL factories expose this registry. Legacy adapters without it remain
    /// trusted to keep wallet balances and aggregate vesting locks disjoint.
    function _factoryTracksWallet(address factory, address wallet) internal view returns (bool) {
        if (wallet == address(0)) return false;
        (bool ok, bytes memory result) = factory.staticcall(abi.encodeWithSignature("isDeployedVesting(address)", wallet));
        return ok && result.length == 32 && abi.decode(result, (uint256)) == 1;
    }

    function _isTrackedVestingWallet(address wallet) internal view returns (bool) {
        if (_factoryTracksWallet(address(vestingFactory), wallet)) return true;
        for (uint256 i; i < _additionalFactories.length; ++i) {
            if (_factoryTracksWallet(address(_additionalFactories[i]), wallet)) return true;
        }
        return false;
    }

    function _checkPair(address pair, address quote, address otherPair) internal view {
        if (pair == address(0)) {
            if (quote != address(0)) revert InvalidPair();
            return;
        }
        if (pair.code.length == 0 || quote == address(0) || quote == address(realToken) || pair == otherPair) {
            revert InvalidPair();
        }
        address a = IRealV2Pair(pair).token0();
        address b = IRealV2Pair(pair).token1();
        if (!((a == address(realToken) && b == quote) || (b == address(realToken) && a == quote))) {
            revert InvalidPair();
        }
        IRealV2Pair(pair).totalSupply();
    }

    function _lpBurned(IRealV2Pair pair) internal view returns (uint256) {
        if (address(pair) == address(0) || !isLpBurnAddressConfigured()) return 0;
        return pair.balanceOf(lpBurnAddress);
    }

    function _lpTotal(IRealV2Pair pair) internal view returns (uint256) {
        return address(pair) == address(0) ? 0 : pair.totalSupply();
    }
}
