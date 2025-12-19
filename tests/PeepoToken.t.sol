// SPDX-License-Identifier: MIT
pragma solidity >=0.8.29 <0.9.0;

import { Test } from "forge-std/src/Test.sol";
import { console2 } from "forge-std/src/console2.sol";
import { Base64 } from "@openzeppelin/contracts/utils/Base64.sol";

import { PeepoToken } from "../src/PeepoToken.sol";

/// @dev If this is your first time with Forge, read this tutorial in the Foundry Book:
/// https://book.getfoundry.sh/forge/writing-tests
contract PeepoTokenTest is Test {
    PeepoToken internal peepoToken;

    /// @dev A function invoked before each test case is run.
    function setUp() public virtual {
        // Instantiate the contract-under-test.
        uint256 initialSupply = 100_000 ether;
        peepoToken = new PeepoToken(initialSupply);
    }

    /// @dev Basic test. Run it with `forge test -vvv` to see the console log.
    function test_Example() external view {
        console2.log("Hello World");
        assertEq(peepoToken.totalSupply(), 100_000 ether, "total supply mismatch");
    }

    /// @dev Fuzz test that provides random values for an unsigned integer, but which rejects zero as an input.
    /// If you need more sophisticated input validation, you should use the `bound` utility instead.
    /// See https://twitter.com/PaulRBerg/status/1622558791685242880
    function testFuzz_Example(uint256 x) external view {
        vm.assume(x != 0); // or x = bound(x, 1, 100)
        assertEq(peepoToken.totalSupply(), 100_000 ether, "total supply mismatch");
    }

    /// @dev Fork test that runs against an Ethereum Mainnet fork. For this to work, you need to set `API_KEY_ALCHEMY`
    /// in your environment You can get an API key for free at https://alchemy.com.
    function testFork_Example() external {
        // Silently pass this test if there is no API key.
        string memory alchemyApiKey = vm.envOr("API_KEY_ALCHEMY", string(""));
        if (bytes(alchemyApiKey).length == 0) {
            return;
        }

        // Otherwise, run the test against the mainnet fork.
        vm.createSelectFork({ urlOrAlias: "mainnet", blockNumber: 16_428_000 });
        address usdc = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
        address holder = 0x7713974908Be4BEd47172370115e8b1219F4A5f0;
        uint256 actualBalance = PeepoToken(usdc).balanceOf(holder);
        uint256 expectedBalance = 196_307_713.810457e6;
        assertEq(actualBalance, expectedBalance);
    }

    /// @dev Fuzz test: Ensure only the owner can mint.
    /// Forge will call this 256 times (default) with random addresses and amounts.
    function testFuzz_OnlyOwnerCanMint(address randomUser, uint256 amount) external {
        vm.assume(randomUser != address(this));

        // (though ERC20 handles this, it's cleaner to test realistic numbers)
        amount = bound(amount, 1, 1e30);

        // Note: OpenZeppelin 5.x uses custom errors, so we check for 'OwnableUnauthorizedAccount'
        vm.expectRevert(abi.encodeWithSelector(bytes4(keccak256("OwnableUnauthorizedAccount(address)")), randomUser));

        vm.prank(randomUser);
        peepoToken.mint(randomUser, amount);
    }

    function testFuzz_MintAsOwner(uint256 amount) external {
        amount = bound(amount, 1, 1_000_000_000 ether);
        uint256 preMintSupply = peepoToken.totalSupply();

        peepoToken.mint(address(this), amount);

        assertEq(peepoToken.totalSupply(), preMintSupply + amount);
    }

    function test_Metadata() public {
        string memory expectedJson = string(
            abi.encodePacked(
                "{",
                '"name": "PeepoToken",',
                '"description": "Peepo is 100% on-chain!",',
                '"image": "https://cdn.betterttv.net/emote/5a16ee718c22a247ead62d4a/3x.webp"',
                "}"
            )
        );

        string memory expectedMetadata =
            string(abi.encodePacked("data:application/json;base64,", Base64.encode(bytes(expectedJson))));

        string memory actualMetadata = peepoToken.metadata();

        assertEq(actualMetadata, expectedMetadata, "Metadata mismatch");
    }
}
