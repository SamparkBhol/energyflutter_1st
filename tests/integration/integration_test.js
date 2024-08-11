const request = require('supertest');
const app = require('../server');
const { expect } = require('chai');

describe('Integration Tests', function () {
  it('should register a new user and return 200 status', async function () {
    const res = await request(app)
      .post('/api/register')
      .send({
        username: 'testuser',
        password: 'password123',
      });

    expect(res.status).to.equal(200);
    expect(res.body).to.have.property('token');
  });

  it('should login a registered user and return 200 status', async function () {
    const res = await request(app)
      .post('/api/login')
      .send({
        username: 'testuser',
        password: 'password123',
      });

    expect(res.status).to.equal(200);
    expect(res.body).to.have.property('token');
  });

  it('should return user data after login', async function () {
    const loginRes = await request(app)
      .post('/api/login')
      .send({
        username: 'testuser',
        password: 'password123',
      });

    const token = loginRes.body.token;

    const res = await request(app)
      .get('/api/user')
      .set('Authorization', `Bearer ${token}`);

    expect(res.status).to.equal(200);
    expect(res.body).to.have.property('username', 'testuser');
  });

  it('should allow energy trading between users', async function () {
    const loginRes = await request(app)
      .post('/api/login')
      .send({
        username: 'testuser',
        password: 'password123',
      });

    const token = loginRes.body.token;

    await request(app)
      .post('/api/energy/log')
      .set('Authorization', `Bearer ${token}`)
      .send({
        energyProduced: 100,
        energyConsumed: 50,
      });

    const res = await request(app)
      .post('/api/energy/trade')
      .set('Authorization', `Bearer ${token}`)
      .send({
        toUser: 'user2',
        amount: 20,
      });

    expect(res.status).to.equal(200);
    expect(res.body).to.have.property('message', 'Trade successful');
  });

  it('should fetch energy trading history', async function () {
    const loginRes = await request(app)
      .post('/api/login')
      .send({
        username: 'testuser',
        password: 'password123',
      });

    const token = loginRes.body.token;

    const res = await request(app)
      .get('/api/energy/history')
      .set('Authorization', `Bearer ${token}`);

    expect(res.status).to.equal(200);
    expect(res.body).to.be.an('array');
  });
});
