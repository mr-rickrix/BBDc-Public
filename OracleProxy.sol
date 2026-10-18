// SPDX-License-Identifier: MIT

// Real Estate Alliance League, Illinois, USA
// REAL Supply Oracle - Upgradeable Proxy

// This proxy provides the permanent address for the REAL Supply Oracle.
// It delegates calls to an implementation that can be upgraded by
// the authorized owner.

// REAL Token: 0x325Aa344761c19F7ab6dc45A95f01d6907A30DCA
// https://thisisreal.io   /    support@thisisreal.io

// Developed by Building Blocks Developers Co. (https://BBDc.io)
// for Real Estate Alliance League Inc.

pragma solidity ^0.8.28;

import {ERC1967Proxy} from
    "@openzeppelin/contracts@5.1.0/proxy/ERC1967/ERC1967Proxy.sol";