const request = require('supertest');
const app = require('../app');

(async () => {
  try {
    await request(app)
      .get('/')
      .expect(200)
      .expect('Hello World!');

    console.log('PASS: GET / returned Hello World!');
    process.exit(0);
  } catch (error) {
    console.error('FAIL:', error);
    process.exit(1);
  }
})();
