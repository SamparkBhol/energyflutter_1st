const admin = require('firebase-admin');

exports.handleTrade = async (beforeData, afterData) => {
  const beforeAmount = beforeData.amount;
  const afterAmount = afterData.amount;

  if (beforeAmount !== afterAmount) {
    const changeInAmount = beforeAmount - afterAmount;
    const offerRef = admin.firestore().collection('offers').doc(afterData.offerId);

    if (changeInAmount > 0) {
      await offerRef.update({
        status: 'completed',
        completedAt: new Date().toISOString(),
      });
      console.log(`Trade completed for offer ${afterData.offerId}`);
    } else {
      await offerRef.update({
        status: 'pending',
      });
      console.log(`Trade pending for offer ${afterData.offerId}`);
    }

    const userRef = admin.firestore().collection('users').doc(afterData.buyerId);
    await userRef.update({
      energyBalance: admin.firestore.FieldValue.increment(-changeInAmount),
    });

    console.log(`Updated energy balance for user ${afterData.buyerId}`);
  }
};
