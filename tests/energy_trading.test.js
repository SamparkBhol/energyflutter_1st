const EnergyTrading = artifacts.require("EnergyTrading");

contract("EnergyTrading", accounts => {
  const [admin, user1, user2] = accounts;
  let energyTrading;

  before(async () => {
    energyTrading = await EnergyTrading.deployed();
  });

  it("should register a user", async () => {
    await energyTrading.registerUser({ from: user1 });
    const userDetails = await energyTrading.getUserDetails(user1);
    assert.equal(userDetails.energyProduced.toNumber(), 0, "Initial energyProduced should be 0");
  });

  it("should log energy produced", async () => {
    await energyTrading.logEnergyProduced(100, { from: user1 });
    const userDetails = await energyTrading.getUserDetails(user1);
    assert.equal(userDetails.energyProduced.toNumber(), 100, "Energy produced should be logged correctly");
  });

  it("should log energy consumed", async () => {
    await energyTrading.logEnergyConsumed(50, { from: user1 });
    const userDetails = await energyTrading.getUserDetails(user1);
    assert.equal(userDetails.energyConsumed.toNumber(), 50, "Energy consumed should be logged correctly");
  });

  it("should trade energy between users", async () => {
    await energyTrading.registerUser({ from: user2 });
    await energyTrading.tradeEnergy(user2, 30, { from: user1 });
    const user1Details = await energyTrading.getUserDetails(user1);
    const user2Details = await energyTrading.getUserDetails(user2);
    assert.equal(user1Details.energyBalance.toNumber(), 20, "User1's balance should be reduced");
    assert.equal(user2Details.energyBalance.toNumber(), 30, "User2's balance should be increased");
  });
});
