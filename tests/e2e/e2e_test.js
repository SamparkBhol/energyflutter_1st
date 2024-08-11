const { expect } = require('chai');
const request = require('supertest');
const app = require('../server');

describe('End-to-End Tests', function () {
  it('should complete the full user journey', async function () {
    // Register user
    const registerRes = await request(app)
      .post('/api/register')
      .send({
        username: 'testuser',
        password: 'password123',
      });

    expect(registerRes.status).to.equal(200);

    // Login user
    const loginRes = await request(app)
      .post('/api/login')
      .send({
        username: 'testuser',
        password: 'password123',
      });

    const token = loginRes.body.token;
    expect(loginRes.status).to.equal(200);
    expect(token).to.exist;

    // Log energy production
    const logEnergyRes = await request(app)
      .post('/api/energy/log')
      .set('Authorization', `Bearer ${token}`)
      .send({
        energyProduced: 100,
        energyConsumed: 50,
      });

    expect(logEnergyRes.status).to.equal(200);

    // Trade energy
    const tradeRes = await request(app)
      .post('/api/energy/trade')
      .set('Authorization', `Bearer ${token}`)
      .send({
        toUser: 'user2',
        amount: 20,
      });

    expect(tradeRes.status).to.equal(200);
    expect(tradeRes.body).to.have.property('message', 'Trade successful');

    // Fetch energy history
    const historyRes = await request(app)
      .get('/api/energy/history')
      .set('Authorization', `Bearer ${token}`);

    expect(historyRes.status).to.equal(200);
    expect(historyRes.body).to.be.an('array');
  });
});
