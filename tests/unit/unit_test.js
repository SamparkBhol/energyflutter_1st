const { expect } = require('chai');
const { calculateEnergyBalance, logEnergyProduction, logEnergyConsumption } = require('../services/energy_service');

describe('Unit Tests', function () {
  it('should calculate energy balance correctly', function () {
    const balance = calculateEnergyBalance(100, 50);
    expect(balance).to.equal(50);
  });

  it('should log energy production correctly', function () {
    const user = { energyProduced: 100, energyBalance: 100 };
    logEnergyProduction(user, 50);
    expect(user.energyProduced).to.equal(150);
    expect(user.energyBalance).to.equal(150);
  });

  it('should log energy consumption correctly', function () {
    const user = { energyConsumed: 50, energyBalance: 100 };
    logEnergyConsumption(user, 30);
    expect(user.energyConsumed).to.equal(80);
    expect(user.energyBalance).to.equal(70);
  });

  it('should not log energy consumption if balance is insufficient', function () {
    const user = { energyConsumed: 50, energyBalance: 20 };
    expect(() => logEnergyConsumption(user, 30)).to.throw('Insufficient energy balance');
  });

  it('should handle energy trading between users correctly', function () {
    const user1 = { energyBalance: 100 };
    const user2 = { energyBalance: 50 };
    const amount = 30;

    tradeEnergy(user1, user2, amount);

    expect(user1.energyBalance).to.equal(70);
    expect(user2.energyBalance).to.equal(80);
  });
});
