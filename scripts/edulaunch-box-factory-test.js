const { expect, assert, should } = require("chai");
const { ethers } = require("hardhat");

describe("EduLaunchBox", function () {
    before(async function () {
        const [deployer] = await ethers.getSigners();
        const EduLaunchBoxFactory = await ethers.getContractFactory("EduLaunchBoxFactory");
        const factory = await EduLaunchBoxFactory.deploy();

        await factory.waitForDeployment();

        this.factory = factory;
        this.factoryAddress = await factory.getAddress();
        this.deployer = deployer;
        this.deployerAddress = await deployer.getAddress();
    });

    describe("LaunchBox Token", function () {
        it("Should deploy token with known address", async function () {
            const salt = await this.factory.getdeployedLaunchBoxesLen(this.deployerAddress);

            const name = "Happy Hour";
            const symbol = "HPPR";
            const tokenSupply = ethers.parseEther("1000000000");

            const byteCode = await this.factory.getBytecode(name, symbol, tokenSupply);
            const address = await this.factory.getAddressCreate2(byteCode, salt);

            await this.factory.newLaunchBox(name, symbol, tokenSupply);

            const deployedPumpTokens = await this.factory.getdeployedLaunchBoxes(
                this.deployerAddress
            );

            assert.equal(address, deployedPumpTokens[0]);
            assert.equal(deployedPumpTokens.length, 1);

            console.table({
                EduLaunchBoxFactory: this.factoryAddress,
                HappyHour: deployedPumpTokens[0],
            });
        });
    });
});

//For testing: npx hardhat test scripts/edulaunch-box-factory-test.js --network hardhat
//For deployment: npx hardhat test scripts/edulaunch-box-factory-test.js --network hardhat
