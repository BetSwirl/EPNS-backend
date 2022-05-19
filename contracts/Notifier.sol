// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/proxy/utils/Initializable.sol";

import "../interfaces/IEPNSComV1.sol";

contract Notifier is Initializable, Ownable {
    address public constant EPNS_COMM_ADDRESS=0x87da9Af1899ad477C67FeA31ce89c1d2435c77DC;
    string[] notificationCIDS;

    function initialize() public initializer {
        uint length = notificationCIDS.length;
        if (length < 1) {
            // 10 matic message
            notificationCIDS.push("QmPV3mMQCKYf9127mtpq1gftVw3tEdn3khptvWCFYH1tGq");
        }
        if (length < 2) {
            // 50 matic message
            notificationCIDS.push("QmPjn7bdPHj5w3V9tHxhJ3iAJx1wBmpc8VBRxwyJMpmXgo");
        }
        if (length < 3) {
            // 100 matic message
            notificationCIDS.push("QmRLgBPQ3vFcNty1QRxNia9mmSU6JBb9AFuKwyfhkErCZd");
        }
    }

    function identity(uint256 _id) public view returns(bytes memory) {
        // 3: targeted notification
        return abi.encodePacked("3", "+", notificationCIDS[_id]);
    }

    function send(address _channel, address _recipient, uint256 _id) public {
        bytes memory _identity = identity(_id);
        IEPNSComV1(EPNS_COMM_ADDRESS).sendNotification(_channel, _recipient, _identity);
    }
}