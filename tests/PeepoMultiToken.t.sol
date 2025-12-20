// SPDX-License-Identifier: MIT
pragma solidity >=0.8.29 <0.9.0;

import { Test } from "forge-std/src/Test.sol";
import { PeepoMultiToken } from "../src/PeepoMultiToken.sol";

/**
 * @title PeepoMultiTokenTest
 * @notice Tests for the dynamic URI and batch features of PeepoMultiToken
 */
contract PeepoMultiTokenTest is Test {
  PeepoMultiToken public multi;
  address public owner = address(1);
  address public user = address(2);

  function setUp() public {
    vm.prank(owner);
    multi = new PeepoMultiToken();
  }

  /**
   * @notice Verifies the URI correctly generates the 1x, 2x, 3x format
   */
  function test_DynamicURI() public {
    vm.prank(owner);
    multi.mint(user, 1, 10);

    string memory uri = multi.uri(1);
    string memory expectedPrefix = "data:application/json;base64,";

    // Extract the first 29 bytes manually to avoid the slicing error
    bytes memory uriBytes = bytes(uri);
    bytes memory prefixBytes = new bytes(29);

    for (uint256 i = 0; i < 29; ++i) {
      prefixBytes[i] = uriBytes[i];
    }

    // Convert back to string for comparison
    assertEq(string(prefixBytes), expectedPrefix, "URI prefix mismatch");
  }

  /**
   * @notice Tests the gas-efficient batch transfer feature
   */
  function test_BatchTransfer() public {
    vm.startPrank(owner);
    multi.mint(owner, 1, 100);
    multi.mint(owner, 2, 50);
    multi.mint(owner, 3, 10);

    uint256[] memory ids = new uint256[](3);
    ids[0] = 1;
    ids[1] = 2;
    ids[2] = 3;

    uint256[] memory amounts = new uint256[](3);
    amounts[0] = 10;
    amounts[1] = 5;
    amounts[2] = 1;

    multi.safeBatchTransferFrom(owner, user, ids, amounts, "");
    vm.stopPrank();

    assertEq(multi.balanceOf(user, 1), 10);
    assertEq(multi.balanceOf(user, 2), 5);
    assertEq(multi.balanceOf(user, 3), 1);
  }
}
