// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract IoTDataStorage {

    struct IoTRecord {
        string packageID;
        string dataType;
        string value;
        string status;
        string location;
        uint timestamp;
    }

    IoTRecord[] private records;

    event DataStored(
        string packageID,
        string dataType,
        string value,
        string status,
        string location,
        uint timestamp
    );

    function storeData(
        string memory packageID,
        string memory dataType,
        string memory value,
        string memory status,
        string memory location
    ) public {
        require(bytes(packageID).length > 0, "Package ID is required");
        require(bytes(value).length > 0, "Value is required");

        IoTRecord memory newRecord = IoTRecord({
            packageID: packageID,
            dataType: dataType,
            value: value,
            status: status,
            location: location,
            timestamp: block.timestamp
        });

        records.push(newRecord);
        emit DataStored(packageID, dataType, value, status, location, block.timestamp);
    }

    function getAllData() public view returns (IoTRecord[] memory) {
        return records;
    }

    function getDataByPackageID(string memory packageID) public view returns (IoTRecord[] memory) {
        uint count = 0;

        // First pass: count matching records
        for (uint i = 0; i < records.length; i++) {
            if (keccak256(bytes(records[i].packageID)) == keccak256(bytes(packageID))) {
                count++;
            }
        }

        IoTRecord[] memory result = new IoTRecord[](count);
        uint index = 0;

        // Second pass: collect matching records
        for (uint i = 0; i < records.length; i++) {
            if (keccak256(bytes(records[i].packageID)) == keccak256(bytes(packageID))) {
                result[index] = records[i];
                index++;
            }
        }

        return result;
    }
}


